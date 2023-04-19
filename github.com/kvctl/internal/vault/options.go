package vault

import (
	"sync"
	"time"

	semaphore "github.com/da-moon/go-semaphore"
	api "github.com/hashicorp/vault/api"

	logger "github.com/da-moon/go-logger"
)

// Option - options setter method
type Option func(*Backend)

// Backend -
type Backend struct {
	sync.Once
	stateLock      sync.Mutex
	log            *logger.WrappedLogger
	logOps         bool
	transactional  bool
	initialized    bool
	requestTimeout time.Duration
	// -----
	sync.RWMutex
	semaphore  semaphore.Semaphore
	Mount      string
	namespace  string
	Client     *api.Client
	version    int
	address    string
	token      string
	caCert     string
	clientCert string
	clientKey  string
	// Prompt Options
	skipAllFlag         bool
	overwriteAllFlag    bool
	overwritePromptFlag bool
}

func (b *Backend) EnableOverwritePrompt() {
	b.overwritePromptFlag = true
}

func (b *Backend) DisableOverwritePrompt() {
	b.overwritePromptFlag = false
}

// WithAddress -
func WithAddress(arg string) Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.address = arg
	}
}

// WithToken -
func WithToken(arg string) Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.token = arg
	}
}

// WithMount -
func WithMount(arg string) Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.Mount = arg
	}
}
func WithNamespace(arg string) Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.namespace = arg
	}
}

func WithDestinationNamespace(arg string) Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.namespace = arg
	}
}

// WithCertificate ...
func WithCACertificate(ca string) Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.caCert = ca
	}
}
func WithClientCert(cert string) Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.clientCert = cert
	}
}
func WithClientKey(key string) Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.clientKey = key
	}
}

// VersionOne -
func VersionOne() Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.version = 1
	}
}

func VersionTwo() Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.version = 2
	}
}

// LogOps -
func LogOps() Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.logOps = true
	}
}

// TransactionalOperation -
func TransactionalOperation() Option {
	return func(b *Backend) {
		b.stateLock.Lock()
		defer b.stateLock.Unlock()
		b.transactional = true

	}
}
