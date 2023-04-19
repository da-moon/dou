package vault

import bridge "gitlab.com/DigitalOnUs/vault/vaultkv2vaultkv/bridge/models"

type Manager interface {
	StartClient() error
	CheckSeal() (string, error)
	HasValidToken() (bool, error)
	GetNamespace() (string, error)
	GetKVEngines() error
	GetSecretList(string) ([]*bridge.VaultSecret, error)
	GetSecret(secretPath string) (interface{}, error)
	PutSecret(secretPath string, kv map[string]interface{}) (interface{}, error)
	GetTokenData() (map[string]interface{}, error)
}
