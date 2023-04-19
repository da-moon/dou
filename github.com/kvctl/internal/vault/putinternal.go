package vault

import (
	"bufio"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path"
	"time"

	strutils "github.com/DigitalOnUs/kvctl/internal/strutils"
	codec "github.com/da-moon/go-codec"
	api "github.com/hashicorp/vault/api"
	"github.com/kr/pretty"
	stacktrace "github.com/palantir/stacktrace"
)

func (b *Backend) readInput(input chan<- int) error {
	var u int
	reader := bufio.NewReader(os.Stdin)
	s, _, err := reader.ReadRune()
	if err != nil {
		return err
	}
	u = int(s - '0')
	b.log.Trace("readInput: User input int %d", u)
	input <- u
	return nil
}

const writePromptText string = `
    Found data at path %s
	Please enter a single digit to select an option:
	1) Skip
	2) Overwrite
	3) Skip All
	4) Overwrite All
	5) Panic Exit
::`

func (b *Backend) checkDataAtPath(path string) (bool, error) {
	secret, err := b.kvReadRequest(path, nil)
	if err != nil {
		return false, err
	}
	if secret == nil {
		return false, nil
	} else {
		return true, nil
	}
}

// PutInternal -
func (b *Backend) PutInternal(ctx context.Context, entry *Entry, ns, srcVersion string) error {
	var err error
	errCh := make(chan error)
	logCh := make(chan string)
	promptCh := make(chan string)
	userInput := make(chan int)

	var mountPath string
	var v2 bool
	var dstVersion string = "1"

	go func() {
		time.Sleep(100 * time.Millisecond)
		data := make(map[string]interface{})
		err = codec.DecodeJSON(entry.Value, &data)

		if err != nil {
			errCh <- stacktrace.Propagate(err, "Backend Put operation error.could decode entry data")
			return
		}

		metadatapath := ""
		targetpath := strutils.SanitizePath(path.Join(b.Mount, entry.Key))
		b.log.Trace("PUTInternal: targetpath: %s", targetpath)
		logCh <- pretty.Sprintf("PUTInternal: Mount source version: %s", srcVersion)

		if srcVersion == "2" {

			mountPath, v2, err = b.isKVv2(targetpath)

			if err != nil {
				errCh <- stacktrace.Propagate(err, "Backend Delete operation error .unsupported path (%s) type", targetpath)
				return
			}
			if v2 {
				dstVersion = "2"
				metadatapath = addPrefixToVKVPath(targetpath, mountPath, "metadata")
				b.log.Trace("GetInternal: V2 metadatapath: %s", metadatapath)

				//targetpath = addPrefixToVKVPath(targetpath, mountPath, "data")
				data = map[string]interface{}{
					"data":    data,
					"options": map[string]interface{}{},
				}
				cas := ctx.Value("cas")
				if cas != nil {
					checkAndSet, ok := cas.(int)
					if !ok {
						logCh <- pretty.Sprintf("Backend Put operation warning .could not extract check and set (cas) int from context")
					} else {
						if checkAndSet > -1 {
							data["options"].(map[string]interface{})["cas"] = checkAndSet
						}
					}
				}
			}
		}
		mountPath, v2, err = b.isKVv2(targetpath)
		if err != nil {
			errCh <- stacktrace.Propagate(err, "Backend Delete operation error .unsupported path (%s) type", targetpath)
			return
		}
		if v2 {
			targetpath = addPrefixToVKVPath(targetpath, mountPath, "data")
			b.log.Trace("PUTInternal addPrefixToVKVPath: targetpath: %s", targetpath)
			dstVersion = "2"
		}
		if ns != "" {
			logCh <- pretty.Sprintf("PUTInternal: Namespace detected %s", ns)
			b.Client.SetNamespace(ns)
		}

		b.log.Trace("PUTInternal: Data information: %v", data["data"])

		jsonString, err := json.Marshal(data)
		fmt.Println(err)
		b.log.Trace("PUTInternal: JSON: Data information: %s", jsonString)
		b.log.Trace("PUTInternal: JSON: Secret information: %+v", data["data"])
		var secret *api.Secret
		dt, ok := data["data"].(map[string]interface{})
		if ok {
			b.log.Trace("PUTInternal: Data is not nil and conversion successful")
		}
		if (data["data"] != nil) && (srcVersion == dstVersion) {
			b.log.Trace("PUTInternal: Data is not nil and src/dst match, target is %v", targetpath)
			if b.overwritePromptFlag && !b.overwriteAllFlag {
				var overwrite bool
				full, err := b.checkDataAtPath(targetpath)
				if err != nil {
					logCh <- ""
					errCh <- stacktrace.Propagate(err, "Could not check for data at path")
					return
				}
				if full && !b.skipAllFlag {
				fullOutOnMatch:
					for {
						//go b.readInput(userInput)
						promptCh <- fmt.Sprintf(writePromptText, targetpath)
						userAnswer := <-userInput
						switch userAnswer {
						case 1:
							b.log.Trace("User selects %d for path %v", userAnswer, targetpath)
							overwrite = false
							break fullOutOnMatch
						case 2:
							b.log.Trace("User selects %d for path %v", userAnswer, targetpath)
							overwrite = true
							break fullOutOnMatch
						case 3:
							// Skip All (Default)
							b.log.Trace("User selects %d for path %v", userAnswer, targetpath)
							b.skipAllFlag = true
							overwrite = false
							break fullOutOnMatch
						case 4:
							// Overwrite All
							b.log.Trace("User selects %d for path %v", userAnswer, targetpath)
							b.overwriteAllFlag = true
							overwrite = true
							break fullOutOnMatch
						case 5:
							// Panic
							b.log.Trace("User selects %d for path %v", userAnswer, targetpath)
							panic("User requested runtime panic")
						default:
							fmt.Println("Invalid selection, re-prompting...")
							continue fullOutOnMatch
						}
					}
					if !overwrite {
						b.log.Warn("User requested path %v be skipped; skipping...", strutils.SanitizePath(entry.Key))
						logCh <- pretty.Sprintf("User requested path %v be skipped; skipping..", strutils.SanitizePath(entry.Key))
						errCh <- nil
						//promptCh <- ""
						return
					}
				} else if full && b.skipAllFlag {
					b.log.Warn("ALLSKIP: Data at path %v; skipping...", strutils.SanitizePath(entry.Key))
					logCh <- pretty.Sprintf("ALLSKIP: Data at path %v; skipping...", strutils.SanitizePath(entry.Key))
					errCh <- nil
					//promptCh <- ""
					return
				}
			}
			secret, err := b.Client.Logical().Write(targetpath, data["data"].(map[string]interface{}))
			if err != nil {
				logCh <- ""
				errCh <- stacktrace.Propagate(err, "Put operation error.could not write data")
				return
			}
			b.log.Trace("PUTInternal: JSON: Data update response: %+v", secret)
		} else if dt != nil {
			b.log.Trace("PUTInternal: Data is not nil: %+v", dt)
			b.log.Trace("PUTInternal: Mismatch KV version scenario, target is %v", targetpath)
			if b.overwritePromptFlag && !b.overwriteAllFlag {
				full, err := b.checkDataAtPath(targetpath)
				if err != nil {
					logCh <- ""
					errCh <- stacktrace.Propagate(err, "Could not check for data at path")
					return
				}
				if full && !b.skipAllFlag {
				fullOutOnMismatch:
					for {
						//go b.readInput(userInput)
						promptCh <- fmt.Sprintf(writePromptText, targetpath)
						select {
						case userAnswer := <-userInput:
							switch userAnswer {
							case 1:
								// Skip All (Default)
								b.log.Trace("User selects %d for path %v", userAnswer, targetpath)
								b.skipAllFlag = true
								break fullOutOnMismatch
							case 2:
								// Overwrite All
								b.log.Trace("User selects %d for path %v", userAnswer, targetpath)
								b.overwriteAllFlag = true
								break fullOutOnMismatch
							case 3:
								// Panic
								b.log.Trace("User selects %d for path %v", userAnswer, targetpath)
								panic("User requested runtime panic")
							default:
								fmt.Println("Invalid selection, re-prompting...")
								continue fullOutOnMismatch
							}
						case <-time.After(10 * time.Second):
							b.log.Trace("User selection timeout for path %v", targetpath)
							b.log.Trace("User defaults to 1 for path %v", targetpath)
							b.skipAllFlag = true
							break fullOutOnMismatch
						}
					}
					if b.skipAllFlag {
						b.log.Warn("User requested path %v be skipped; skipping...", strutils.SanitizePath(entry.Key))
						logCh <- pretty.Sprintf("User requested path %v be skipped; skipping..", strutils.SanitizePath(entry.Key))
						errCh <- nil
						promptCh <- ""
						return
					}
				} else if full && b.skipAllFlag {
					b.log.Warn("ALLSKIP: Data at path %v; skipping...", strutils.SanitizePath(entry.Key))
					logCh <- pretty.Sprintf("ALLSKIP: Data at path %v; skipping...", strutils.SanitizePath(entry.Key))
					errCh <- nil
					promptCh <- ""
					return
				}
			}
			resp, err := b.Client.Logical().Write(targetpath, map[string]interface{}{"data": dt})
			if err != nil {
				logCh <- ""
				errCh <- stacktrace.Propagate(err, "Put operation error: could not write data")
				return
			}
			b.log.Trace("PUTInternal: JSON: Data update response: %+v", resp)
		} else {
			b.log.Warn("Data from secret %v was nil; skipping...", strutils.SanitizePath(entry.Key))
			logCh <- pretty.Sprintf("Data from secret %v was nil; skipping...", strutils.SanitizePath(entry.Key))
			errCh <- nil
			return
		}

		md, ok := data["data"].(map[string]interface{})["metadata"]
		if ok {
			b.log.Trace("PUTInternal: JSON: Metadata not nil: %+v", data["data"])
			b.log.Trace("PUTInternal: JSON: Metadata information: %+v", data["data"].(map[string]interface{})["metadata"])
			converted, ok := md.(map[string]interface{})

			if ok {
				metadata, err := b.Client.Logical().Write(metadatapath, converted)
				if err != nil {
					logCh <- ""
					errCh <- stacktrace.Propagate(err, "POST operation error.could not write data")
					return
				}

				b.log.Trace("PUTInternal: JSON: Metadata update response: %+v", metadata)
			}
		}

		if secret != nil {
			if versionRaw, ok := secret.Data["version"]; ok && versionRaw != nil {
				logCh <- pretty.Sprintf("PUTInternal: Transfer of key %s version: %v complete!", entry.Key, versionRaw)
			}

			// var metadataString string

			// if secret.Data != nil {
			// 	metadata, ok := secret.Data["metadata"]

			// 	if ok && metadata != nil {
			// 		mm, ok := metadata.(map[string]interface{})
			// 		if ok && mm != nil {
			// 			metadataString, err = jsonStringify(mm)
			// 			if err != nil {
			// 				logCh <- stacktrace.Propagate(err, "Get operation error reading (%s). Could not Decode and Stringify Metadata", targetpath).Error()
			// 				// return
			// 			}
			// 		}
			// 	}
			// 	data := secret.Data
			// 	if srcVersion == "2" && data != nil {
			// 		data = nil
			// 		dataRaw := secret.Data["data"]
			// 		if dataRaw != nil {
			// 			data = dataRaw.(map[string]interface{})
			// 		}
			// 	}
			// 	var dataString string

			// 	if data != nil {
			// 		dataString, err = jsonStringify(data)
			// 		if err != nil {
			// 			logCh <- stacktrace.Propagate(err, "Get operation error reading (%s). Could not Decode and Stringify data", targetpath).Error()
			// 		}
			// 	}
			// 	value := map[string]string{
			// 		"data":     dataString,
			// 		"metadata": metadataString,
			// 	}
			// 	logCh <- pretty.Sprintf("PUTInternal: %v", value)
			// }
		}

		errCh <- nil
	}()
	for {
		select {
		case logs := <-logCh:
			{
				if b.logOps {
					b.log.Trace(logs)
				}
			}
		case err = <-errCh:
			{
				if err != nil {
					return err
				}
				return nil
			}
		case prompt := <-promptCh:
			if prompt != "" {
				b.log.Println(prompt)
				err := b.readInput(userInput)
				if err != nil {
					return stacktrace.NewError("User Input Error: ", err)
				}
			}
		case <-time.After(b.requestTimeout):
			return stacktrace.NewError("Put operation timeout ")
		}
	}

}
