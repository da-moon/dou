package vault

import (
	"context"
	"encoding/json"
	"fmt"
	"path"
	"time"

	strutils "github.com/DigitalOnUs/kvctl/internal/strutils"
	api "github.com/hashicorp/vault/api"
	"github.com/kr/pretty"
	stacktrace "github.com/palantir/stacktrace"
)

// GetInternal sends a request to Vault via a goroutine and returns an interface
// representing the data response from the Vault API
func (b *Backend) GetInternal(ctx context.Context, key string) (interface{}, error) {
	var err error
	errCh := make(chan error)
	entryCh := make(chan *Entry)
	entriesCh := make(chan []*Entry)
	logCh := make(chan string)

	var mountPath string
	var v2 bool

	go func() {
		var versionParam map[string]string
		time.Sleep(100 * time.Millisecond)

		targetpath := strutils.SanitizePath(path.Join(b.Mount, key))
		b.log.Trace("GetInternal: SourcePath: %s", targetpath)

		metadatapath := ""

		mountPath, v2, err = b.isKVv2(targetpath)
		b.log.Trace("GetInternal: MountPath: %s", mountPath)
		b.log.Trace("GetInternal: v2: %t", v2)

		logCh <- pretty.Sprintf(mountPath, v2)

		if err != nil {
			errCh <- stacktrace.Propagate(err, "Get operation error .unsupported path (%s) type", targetpath)
			return
		}

		if v2 {
			metadatapath = addPrefixToVKVPath(targetpath, mountPath, "metadata")
			b.log.Trace("GetInternal: V2 metadatapath: %s", metadatapath)

			targetpath = addPrefixToVKVPath(targetpath, mountPath, "data")
			b.log.Trace("GetInternal: V2 targetpath: %s", targetpath)

			var secrets []*api.Secret

			metadata, err := b.kvReadMetadata(metadatapath, versionParam)
			if err != nil {
				errCh <- stacktrace.Propagate(err, "Get operation error reading (%s)", metadatapath)
				return
			}

			b.log.Trace("GetInternal: metadata Fetched: %v", metadata)

			if len(metadata) > 0 {
				verMap, ok := metadata["data"].(map[string]interface{})["versions"].(map[string]interface{})
				if !ok {
					err = fmt.Errorf("could not assert interface")
					errCh <- stacktrace.Propagate(err, "Error asserting version map for (%s)", metadatapath)
					return
				}
				cVerBase, ok := metadata["data"].(map[string]interface{})["current_version"].(json.Number)
				if !ok {
					err = fmt.Errorf("could not assert")
					errCh <- stacktrace.Propagate(err, "Error asserting current version to interface (%s)", metadatapath)
					return
				}
				b.log.Trace("value of metadata.data.current_version: %d", cVerBase)
				cVerAssert, err := cVerBase.Int64()
				if err != nil {
					errCh <- stacktrace.Propagate(err, "Error asserting json.Number to int (%s)", metadatapath)
					return
				}
				cVer := int(cVerAssert)
				verCount := len(verMap)
				var loopStart int
				var loopFinish int
				if cVer > verCount {
					loopStart = cVer - verCount
					loopFinish = loopStart + verCount
				} else {
					loopStart = 0
					loopFinish = verCount
				}
				for i := loopStart; i < loopFinish; i++ {
					secret, err := b.kvReadRequest(targetpath, map[string]string{"version": fmt.Sprintf("%d", i+1)})
					if err != nil {
						errCh <- stacktrace.Propagate(err, "Get operation error reading (%s)", targetpath)
						return
					}

					b.log.Trace("GetInternal: secret version %d Fetched: %+v", i+1, secret.Data["data"].(map[string]interface{}))
					b.log.Trace("GetInternal: metadata version %d Fetched: %+v", i+1, secret.Data["metadata"].(map[string]interface{}))

					secrets = append(secrets, secret)

					// meta, err := b.kvReadMetadata(metadatapath, map[string]string{"version": fmt.Sprintf("%d", i+1)})
					// if err != nil {
					// 	errCh <- stacktrace.Propagate(err, "Get operation error reading (%s)", targetpath)
					// 	return
					// }

					// b.log.Trace("GetInternal: metadata version %d Fetched: %+v", i+1, secret.Data["metadata"].(map[string]interface{}))
					// metadatas = append(metadatas, secret.Data["metadata"].(map[string]interface{}))

				}
			} else {
				goto SIMPLESECRET
			}

			values := []map[string]interface{}{}
			entries := make([]*Entry, 0)

			for k, v := range secrets {
				dataRaw := v.Data["data"]
				metadataRaw := v.Data["metadata"]

				if dataRaw != nil && metadataRaw != nil {
					data := dataRaw.(map[string]interface{})
					metadata := metadataRaw.(map[string]interface{})

					b.log.Trace("#################### O P E N ##############################")
					b.log.Trace("GetInternal: Entry %s Version %d Data Fetched: %+v", key, k+1, data)
					b.log.Trace("GetInternal: Entry %s Version %d Metadata Fetched: %+v", key, k+1, metadata)
					b.log.Trace("##################### C L O S E #############################")

					if data != nil && metadata != nil {
						values = append(values, map[string]interface{}{
							"data":     data,
							"metadata": metadata,
						})
						// b.log.Trace("GetInternal: secret version %d Encoded: %+v", k+1, values)
					}
				}

				enc, err := json.Marshal(values[k])
				if err != nil {
					errCh <- err
					return
				}

				entries = append(entries, &Entry{
					Key:   key,
					Value: enc,
				})
			}

			entriesCh <- entries
			return
		}

	SIMPLESECRET:
		secret, err := b.kvReadRequest(targetpath, versionParam)
		if err != nil {
			errCh <- stacktrace.Propagate(err, "Get operation error reading (%s)", targetpath)
			return
		}

		b.log.Trace("GetInternal: secret Fetched: %v", secret)

		if (secret == nil) || (secret.Data == nil) {
			logCh <- pretty.Sprintf("Get operation warning. No value found at path (%s)", targetpath)

			ent := &Entry{
				Key:   key,
				Value: nil,
			}
			entryCh <- ent
			return
		}

		b.log.Trace("GetInternal: secret Fetched ?: %v", secret)

		metadata := secret.Data["metadata"]
		data := secret.Data
		if v2 && data != nil {
			data = nil
			dataRaw := secret.Data["data"]
			if dataRaw != nil {
				data = dataRaw.(map[string]interface{})
			}
		}
		value := map[string]interface{}{
			"data":     data,
			"metadata": metadata,
		}

		b.log.Trace("GetInternal: value Fetched: %v", value)

		// enc, err := codec.EncodeJSON(value)

		enc, err := json.Marshal(value)

		if err != nil {
			errCh <- err
			return
		}
		logCh <- pretty.Sprintf("%v", value)

		ent := &Entry{
			Key:   key,
			Value: enc,
		}

		b.log.Trace("GetInternal: Entry Complete Fetched: %v", ent)

		entryCh <- ent
	}()
	for {
		select {
		case ent := <-entryCh:
			{
				return ent, nil
			}
		case ents := <-entriesCh:
			{
				return ents, nil
			}
		case err = <-errCh:
			{
				return nil, err
			}
		case logs := <-logCh:
			{
				if b.logOps {
					b.log.Trace("GetInternal: Channel: %s", logs)
				}
			}
		case <-time.After(b.requestTimeout):
			return nil, stacktrace.NewError("Get operation timeout")
		}
	}
}
