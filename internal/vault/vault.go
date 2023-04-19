package vault

import (
	"context"
	"crypto/md5"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"os"
	"time"

	logger "github.com/da-moon/go-logger"
	semaphore "github.com/da-moon/go-semaphore"
	api "github.com/hashicorp/vault/api"
	approle "github.com/hashicorp/vault/api/auth/approle"
	stacktrace "github.com/palantir/stacktrace"
)

func New(log *logger.WrappedLogger, opts ...Option) *Backend {
	result := &Backend{
		Mount:          "kv",
		version:        2,
		logOps:         false,
		requestTimeout: 5 * time.Second,
	}
	for _, opt := range opts {
		opt(result)
	}
	result.log = log
	result.semaphore = semaphore.NewCountingSemaphore()
	if result.transactional {
		result.semaphore = semaphore.NewBinarySemaphore()
	}
	if result.token == "" {
		result.token = "root"
	}
	if result.address == "" {
		result.address = "http://127.0.0.1:8200"
	}
	return result
}
func (b *Backend) Configure(opts ...Option) {
	for _, opt := range opts {
		opt(b)
	}
}

func (b *Backend) AppRoleAuth(ctx context.Context, roleID, secretID string) error {
	S := approle.SecretID{
		FromString: secretID,
	}

	newAppRole, err := approle.NewAppRoleAuth(roleID, &S)
	if err != nil {
		return fmt.Errorf("unable to initialize AppRole auth method: %w", err)
	}

	b.log.Trace("AppRoleAuth: newAppRole: %v", newAppRole)
	authInfo, err := b.Client.Auth().Login(context.Background(), newAppRole)

	if err != nil {
		return fmt.Errorf("unable to login to AppRole auth method: %w", err)
	}
	if authInfo == nil {
		return fmt.Errorf("no auth info was returned after login")
	}

	return nil
}

// Init -
func (b *Backend) Init() error {
	errCh := make(chan error)
	logCh := make(chan string)
	defer func() {
		if b.initialized && b.logOps {
			b.log.Trace("Initialized completed \n")
		}
	}()
	b.stateLock.Lock()
	defer b.stateLock.Unlock()
	if b.token == "" {
		b.token = "root"
	}
	if b.address == "" {
		b.address = "http://127.0.0.1:8200"
	}
	go b.Do(func() {
		var err error
		logCh <- "Started Setting Up Client ... "
		// config := api.DefaultConfig()
		// TODO address this err
		vaultconfig := api.DefaultConfig()
		if b.caCert == "" {
			b.caCert = os.Getenv("VAULT_CACERT")

		}
		if b.clientKey == "" {
			b.clientKey = os.Getenv("VAULT_CLIENT_KEY")
		}
		if b.caCert != "" && b.clientCert != "" && b.clientKey != "" {
			err = vaultconfig.ConfigureTLS(&api.TLSConfig{
				CACert:     b.caCert,
				ClientCert: b.clientCert,
				ClientKey:  b.clientKey,
			})
			if err != nil {
				err = stacktrace.Propagate(err, "initialization error. Could not setup client with provided certificates")
				errCh <- err
				return
			}
		}
		b.Client, err = api.NewClient(vaultconfig)
		if err != nil {
			err = stacktrace.Propagate(err, "initialization error. Could not setup client with default config")
			errCh <- err
			return
		}
		if b.namespace != "" {
			b.Client.SetNamespace(b.namespace)
		}
		b.Client.SetToken(b.token)
		err = b.Client.SetAddress(b.address)
		if err != nil {
			err = stacktrace.Propagate(err, "initialization error. fault address", b.address)
			errCh <- err
			return

		}
		errCh <- nil
	})
	for {
		select {
		case logs := <-logCh:
			{
				if b.logOps {
					b.log.Debug(logs)
				}
			}
		case err := <-errCh:
			{
				if err != nil {
					b.initialized = false

					return err
				}
				b.initialized = true
				return nil
			}
		}
	}
}

// Put -
func (b *Backend) Put(ctx context.Context, entry *Entry, ns, srcVersion string) error {
	if !b.initialized {
		stacktrace.NewError("was not initialized")
	}
	// b.semaphore.Wait()
	// defer b.semaphore.Signal()

	b.Lock()
	defer b.Unlock()
	if b.logOps {
		b.log.Debug("PUT: put key %v", entry.Key)
	}
	return b.PutInternal(ctx, entry, ns, srcVersion)
}

// Get -
func (b *Backend) Get(ctx context.Context, key string) (interface{}, error) {
	if !b.initialized {
		stacktrace.NewError("was not initialized")
	}

	b.RLock()
	defer b.RUnlock()

	b.log.Trace("Get: key: %s", key)
	return b.GetInternal(ctx, key)
}

// Delete -
func (b *Backend) Delete(ctx context.Context, path string) error {
	if !b.initialized {
		stacktrace.NewError("was not initialized")
	}

	b.Lock()
	defer b.Unlock()
	return b.DeleteInternal(ctx, path)
}

// List -
func (b *Backend) List(ctx context.Context, prefix string) ([]string, error) {
	if !b.initialized {
		stacktrace.NewError("was not initialized")
	}
	// b.semaphore.Wait()
	// defer b.semaphore.Signal()

	b.RLock()
	defer b.RUnlock()
	return b.ListInternal(ctx, prefix)
}

func (b *Backend) ListMounts(ctx context.Context) ([]string, error) {
	if !b.initialized {
		stacktrace.NewError("was not initialized")
	}
	// b.semaphore.Wait()
	// defer b.semaphore.Signal()

	b.RLock()
	defer b.RUnlock()
	return b.ListMountsInternal()
}

// MD5CurrentHexString -
func (e *Entry) MD5CurrentHexString() string {
	hash := md5.New()
	hash.Write(e.Value)
	md5sumCurr := hash.Sum(nil)
	var appendHyphen bool
	if len(md5sumCurr) == 0 {
		md5sumCurr = make([]byte, 16)
		rand.Read(md5sumCurr)
		appendHyphen = true
	}
	if appendHyphen {
		return hex.EncodeToString(md5sumCurr)[:32] + "-1"
	}
	return hex.EncodeToString(md5sumCurr)
}
