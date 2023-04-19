package vault

import (
	"bytes"
	"context"
	"io"
	"path"
	"strings"
	"time"

	strutils "github.com/DigitalOnUs/kvctl/internal/strutils"
	api "github.com/hashicorp/vault/api"
	"github.com/hashicorp/vault/sdk/helper/jsonutil"
	"github.com/kr/pretty"

	stacktrace "github.com/palantir/stacktrace"
)

// DeleteInternal -
func (b *Backend) DeleteInternal(ctx context.Context, key string) error {
	var err error
	errCh := make(chan error)
	logCh := make(chan string)

	go func() {

		time.Sleep(100 * time.Millisecond)
		targetpath := strutils.SanitizePath(path.Join(b.Mount, key))
		mountPath, v2, err := b.isKVv2(targetpath)
		if err != nil {
			errCh <- stacktrace.Propagate(err, "Delete operation error .unsupported path (%s) type", targetpath)
			return
		}
		logCh <- pretty.Sprintf("Delete operation warning at path (%s).", targetpath)

		if v2 {
			versions := make([]string, 0)

			vs := ctx.Value("versions")
			if vs != nil {
				var ok bool
				versions, ok = vs.([]string)
				if !ok {
					logCh <- pretty.Sprintf("Delete operation warning at path (%s).could not extract versions []string excoded in context", targetpath)
				}
			}
			_, err = b.deleteV2(targetpath, mountPath, versions)
		} else {
			_, err = b.Client.Logical().Delete(targetpath)
		}
		if err != nil {
			errCh <- stacktrace.Propagate(err, "Delete operation error. could not delete entity at target path")
			return
		}
		errCh <- nil
	}()
	for {
		select {
		case err = <-errCh:
			{
				if err != nil {
					return err
				}
				return nil
			}
		case logs := <-logCh:
			{
				if b.logOps {
					b.log.Trace(logs)
				}
			}
		case <-time.After(b.requestTimeout):
			{

				return stacktrace.NewError("Delete operation timeout ")
			}
		}
	}
}

// ListInternal -
func (b *Backend) ListInternal(ctx context.Context, prefix string) ([]string, error) {
	var err error
	errCh := make(chan error)
	outCh := make(chan []string)
	logCh := make(chan string)

	go func() {
		time.Sleep(100 * time.Millisecond)

		targetpath := strutils.EnsureTrailingSlash(strutils.SanitizePath(path.Join(b.Mount, prefix)))
		mountPath, v2, err := b.isKVv2(targetpath)
		if err != nil {
			errCh <- stacktrace.Propagate(err, "List operation error .unsupported path (%s) type", targetpath)
			return
		}
		if v2 {
			targetpath = addPrefixToVKVPath(targetpath, mountPath, "metadata")
			if err != nil {
				errCh <- stacktrace.Propagate(err, "List operation error .could not add v2 prefix to  path (%s)", targetpath)
				return
			}
		}

		secret, err := b.Client.Logical().List(targetpath)
		if err != nil {

			errCh <- stacktrace.Propagate(err, "List operation error .could not list secrets at path (%s)", targetpath)
			return
		}
		result := make([]string, 0, 1)
		if secret == nil || secret.Data == nil {
			// errCh <- stacktrace.NewError("List operation error .No value found at path (%s)", targetpath)
			outCh <- result
			errCh <- nil
			return
		}
		extracted, ok := extractListData(secret)
		if !ok {
			errCh <- stacktrace.NewError("List operation error .No entries found at (%s)", targetpath)
			return
		}
		for _, v := range extracted {
			result = append(result, pretty.Sprintf("%v", v))
		}

		outCh <- result
		errCh <- nil
	}()
	for {
		select {
		case out := <-outCh:
			{
				return out, nil
			}
		case err = <-errCh:
			{
				err = stacktrace.Propagate(err, "List operation error ")
				return nil, err
			}
		case logs := <-logCh:
			{
				if b.logOps {
					b.log.Trace(logs)
				}
			}
		case <-time.After(b.requestTimeout):
			err = stacktrace.Propagate(err, "List operation timeout")
			return nil, err
		}
	}
}

func addPrefixToVKVPath(p, mountPath, apiPrefix string) string {
	switch {
	case p == mountPath, p == strings.TrimSuffix(mountPath, "/"):
		return path.Join(mountPath, apiPrefix)
	default:
		p = strings.TrimPrefix(p, mountPath)
		return path.Join(mountPath, apiPrefix, p)
	}
}

func (b *Backend) isKVv2(path string) (string, bool, error) {

	if b.version == 2 {
		return b.Mount, true, nil
	}

	mountPath, version, err := b.kvPreflightVersionRequest(path)
	if err != nil {
		return "", false, err
	}

	return mountPath, version == 2, nil
}

func (b *Backend) deleteV2(path, mountPath string, versions []string) (*api.Secret, error) {
	var err error
	var secret *api.Secret
	client := b.Client
	switch {
	case len(versions) > 0:
		path = addPrefixToVKVPath(path, mountPath, "delete")
		if err != nil {
			return nil, err
		}

		data := map[string]interface{}{
			"versions": kvParseVersionsFlags(versions),
		}

		secret, err = client.Logical().Write(path, data)
	default:

		path = addPrefixToVKVPath(path, mountPath, "data")
		if err != nil {
			return nil, err
		}

		secret, err = client.Logical().Delete(path)
	}

	return secret, err
}

func (b *Backend) kvPreflightVersionRequest(path string) (string, int, error) {
	client := b.Client
	// We don't want to use a wrapping call here so save any custom value and
	// restore after
	currentWrappingLookupFunc := client.CurrentWrappingLookupFunc()
	client.SetWrappingLookupFunc(nil)
	defer client.SetWrappingLookupFunc(currentWrappingLookupFunc)
	currentOutputCurlString := client.OutputCurlString()
	client.SetOutputCurlString(false)
	defer client.SetOutputCurlString(currentOutputCurlString)

	b.log.Trace("kvPreflightVersionRequest: path: %v", path)

	b.log.Trace("kvPreflightVersionRequest: request: %v", "/v1/sys/internal/ui/mounts/"+path)

	r := client.NewRequest("GET", "/v1/sys/internal/ui/mounts/"+path)
	resp, err := client.RawRequest(r)
	if resp != nil {
		defer resp.Body.Close()
	}
	if err != nil {
		// If we get a 404 we are using an older version of vault, default to
		// version 1
		if resp != nil && resp.StatusCode == 404 {
			return "", 1, nil
		}

		return "", 0, err
	}

	secret, err := api.ParseSecret(resp.Body)
	if err != nil {
		return "", 0, err
	}
	if secret == nil {
		return "", 0, stacktrace.NewError("nil response from pre-flight request")
	}

	b.log.Trace("kvPreflightVersionRequest: response: %v", secret)

	var mountPath string
	if mountPathRaw, ok := secret.Data["path"]; ok {
		mountPath = mountPathRaw.(string)
	}

	b.log.Trace("kvPreflightVersionRequest: mountPath: %v", mountPath)

	options := secret.Data["options"]
	if options == nil {
		return mountPath, 1, nil
	}
	b.log.Trace("kvPreflightVersionRequest: options: %v", options)

	versionRaw := options.(map[string]interface{})["version"]
	if versionRaw == nil {
		return mountPath, 1, nil
	}
	version := versionRaw.(string)
	switch version {
	case "", "1":
		return mountPath, 1, nil
	case "2":
		return mountPath, 2, nil
	}

	return mountPath, 1, nil
}

// extractListData reads the secret and returns a typed list of data and a
// boolean indicating whether the extraction was successful.
func extractListData(secret *api.Secret) ([]interface{}, bool) {
	if secret == nil || secret.Data == nil {
		return nil, false
	}

	k, ok := secret.Data["keys"]
	if !ok || k == nil {
		return nil, false
	}

	i, ok := k.([]interface{})
	return i, ok
}

func kvParseVersionsFlags(versions []string) []string {
	versionsOut := make([]string, 0, len(versions))
	for _, v := range versions {
		versionsOut = append(versionsOut, strutils.ParseStringSlice(v, ",")...)
	}
	return versionsOut
}

func (b *Backend) kvReadRequest(path string, params map[string]string) (*api.Secret, error) {
	client := b.Client
	r := client.NewRequest("GET", "/v1/"+path)
	b.log.Trace("kvReadRequest: request: %s", "/v1/"+path)
	b.log.Trace("kvReadRequest: params: %v", params)

	for k, v := range params {
		r.Params.Set(k, v)
	}
	resp, err := client.RawRequest(r)
	if resp != nil {
		defer resp.Body.Close()
	}
	if resp != nil && resp.StatusCode == 404 {
		secret, parseErr := api.ParseSecret(resp.Body)
		switch parseErr {
		case nil:
		case io.EOF:
			return nil, nil
		default:
			return nil, err
		}
		if secret != nil && (len(secret.Warnings) > 0 || len(secret.Data) > 0) {
			return secret, nil
		}
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return api.ParseSecret(resp.Body)
}

func (b *Backend) kvReadMetadata(path string, params map[string]string) (map[string]interface{}, error) {
	client := b.Client
	r := client.NewRequest("GET", "/v1/"+path)
	b.log.Trace("kvReadRequest: request: %s", "/v1/"+path)

	for k, v := range params {
		r.Params.Set(k, v)
	}
	resp, err := client.RawRequest(r)
	if resp != nil {
		defer resp.Body.Close()
	}
	if resp != nil && resp.StatusCode == 404 {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	// First read the data into a buffer. Not super efficient but we want to
	// know if we actually have a body or not.
	var buf bytes.Buffer
	_, err = buf.ReadFrom(resp.Body)
	if err != nil {
		return nil, err
	}
	if buf.Len() == 0 {
		return nil, nil
	}

	// First decode the JSON into a map[string]interface{}
	var data map[string]interface{}
	if err := jsonutil.DecodeJSONFromReader(&buf, &data); err != nil {
		return nil, err
	}

	// return api.ParseSecret(resp.Body)
	return data, err
}

func (b *Backend) MountKV(path string) error {
	client := b.Client
	r := client.NewRequest("POST", "/v1/sys/mounts/"+path)
	r.BodyBytes = []byte(`{"path":"` + path + `", "type": "kv", "options": { "version": "2" } }`)

	resp, err := client.RawRequest(r)
	if resp != nil {
		defer resp.Body.Close()
	}
	if resp != nil && resp.StatusCode == 404 {
		return err
	}
	if err != nil {
		return err
	}
	return nil
}

func (b *Backend) ListMountsInternal() ([]string, error) {
	client := b.Client
	r := client.NewRequest("GET", "/v1/sys/mounts")

	resp, err := client.RawRequest(r)
	if resp != nil && resp.StatusCode == 404 {
		_, parseErr := api.ParseSecret(resp.Body)
		switch parseErr {
		case nil:
		case io.EOF:
			return nil, nil
		default:
			return nil, err
		}
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	list := []string{}
	data, err := api.ParseSecret(resp.Body)
	if err != nil {
		return nil, err
	}

	for k := range data.Data {
		list = append(list, k)
	}

	return list, nil
}

func (b *Backend) ListMountsUIInternal() ([]string, error) {
	client := b.Client
	r := client.NewRequest("GET", "/v1/sys/internal/ui/mounts")

	resp, err := client.RawRequest(r)
	if resp != nil && resp.StatusCode == 404 {
		_, parseErr := api.ParseSecret(resp.Body)
		switch parseErr {
		case nil:
		case io.EOF:
			return nil, nil
		default:
			return nil, err
		}
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	list := []string{}
	data, err := api.ParseSecret(resp.Body)
	if err != nil {
		return nil, err
	}

	for k := range data.Data {
		list = append(list, k)
	}

	return list, nil
}

/*
func jsonStringify(data map[string]interface{}) (string, error) {
	b, err := json.MarshalIndent(data, "", "  ")
	return string(b), err
}
*/
