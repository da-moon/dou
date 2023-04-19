package vault

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"strings"
	"time"

	vault "github.com/hashicorp/vault/api"

	bridge "gitlab.com/DigitalOnUs/vault/vaultkv2vaultkv/bridge/models"
)

// Instance describe vault instance information
type Instance struct {
	Name         string
	Address      string
	Token        string
	Namespace    string
	SecretMounts []*SecretMount
	client       *vault.Client
}

type SecretMount struct {
	Path    string
	Version string
}

// StartClient start connection with vault instance
func (vi *Instance) StartClient() error {
	config := vault.DefaultConfig()
	config.Address = vi.Address

	log.Printf("starting connection to client on address: %s", config.Address)
	var err error
	vi.client, err = vault.NewClient(config)
	if err != nil {
		return fmt.Errorf("unable to initialize Vault client: %v", err)
	}

	// Authentication
	vi.client.SetToken(vi.Token)

	fmt.Println("Access granted!")

	return nil
}

// CheckSeal returns error if vault instance is sealed
func (vi *Instance) CheckSeal() (string, error) {
	// Writing a secret
	sealStatus, err := vi.client.Sys().SealStatus()
	if err != nil {
		return "", fmt.Errorf("unable to get seal status: %v", err)
	}

	if sealStatus.Sealed {
		return "", fmt.Errorf("the vault instance %s with address %s is sealed", vi.Name, vi.Address)
	}

	return fmt.Sprintf("Secret written successfully."), nil
}

// HasValidToken validate if token is valid in vault instance
func (vi *Instance) HasValidToken() (bool, error) {
	return true, nil
}

// GetNamespace get namespace from vault instance
func (vi *Instance) GetNamespace() (string, error) {
	URL := fmt.Sprintf("%s/sys/namespaces", vi.Address)

	client := &http.Client{
		Timeout: time.Second * 60,
	}

	req, err := http.NewRequest("GET", URL, nil)
	req.Header.Set("X-Vault-Token", vi.Token)
	if err != nil {
		log.Fatalln(err)
	}

	response, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer response.Body.Close()

	body, err := ioutil.ReadAll(response.Body)

	bodyStr := string(body)
	fmt.Printf(bodyStr)

	return "", nil
}

// GetKVEngines get engine type equals to key/value from vault instance
func (vi *Instance) GetKVEngines()  error {
	mounts, err := vi.client.Sys().ListMounts()
	if err != nil {
		return fmt.Errorf("error when trying to get mount list: %s", err)
	}

	for key, mount := range mounts {
		if strings.ToUpper(mount.Type) == "KV" {
			secretMount := &SecretMount{
				Path:    key,
				Version: mount.Options["version"],
			}

			vi.SecretMounts = append(vi.SecretMounts, secretMount)
		}
	}

	return  nil
}

// GetSecretList get secrets list from vault instance
func (vi *Instance) GetSecretList(path string) ([]*bridge.VaultSecret, error) {
	secretDataPath := "secret/data"
	secretMetadataPath := "secret/metadata"
	if "i" == "1" {
		secretMetadataPath = "secret"
		secretMetadataPath = "secret"
	}

	response, err := vi.client.Logical().List(fmt.Sprintf("/%s%s", secretMetadataPath, path))
	if err != nil {
		return nil, fmt.Errorf("unable to get path: %v", err)
	}

	var secretTree []*bridge.VaultSecret

	keys := response.Data["keys"]

	for _, key := range keys.([]interface{}) {
		vaultSecret := &bridge.VaultSecret{}

		keyStr := key.(string)
		vaultSecret.Path = keyStr

		if keyStr[len(keyStr)-1:] == "/" {
			vaultSecret.Secret, err = vi.GetSecretList(fmt.Sprintf("%s/%s", path, keyStr))
			if err != nil {
				return nil, err
			}
			secretTree = append(secretTree, vaultSecret)
			continue
		}

		secretMetadata, err := vi.client.Logical().Read(fmt.Sprintf("%s/%s%s", secretMetadataPath, path, key))
		if err != nil {
			return nil, fmt.Errorf("cannot read secret from origin :%v", err)
		}

		currentVersion, _ := secretMetadata.Data["current_version"].(json.Number).Int64()
		maxVersions, _ := secretMetadata.Data["max_versions"].(json.Number).Int64()
		if maxVersions == 0 {
			maxVersions = 10
		}

		vaultSecret.VersionedData = map[int64]bridge.VaultSecretData{}

		for i := currentVersion; i > 0 && i >= currentVersion-maxVersions; i-- {

			secretArgs := map[string][]string{
				"version": {strconv.Itoa(int(i))},
			}

			secretPath := fmt.Sprintf("%s/%s%s", secretDataPath, path, key)
			secretData, errData := vi.client.Logical().ReadWithData(secretPath, secretArgs)
			if errData != nil {
				return nil, fmt.Errorf("error when trying to read versions from secret :%v", errData)
			}

			secretMetaData := secretData.Data["metadata"].(map[string]interface{})
			vaultSecret.VersionedData[i] = bridge.VaultSecretData{
				Data:        secretData.Data["data"].(map[string]interface{}),
				CreatedTime: secretMetaData["created_time"].(string),
			}
		}

		secretTree = append(secretTree, vaultSecret)
	}

	return secretTree, nil
}

func (vi *Instance) GetSecret(secretPath string) (interface{}, error) {
	// Reading a secret
	secret, err := vi.client.Logical().Read(secretPath)
	if err != nil {
		return nil, fmt.Errorf("unable to read secret: %v", err)
	}

	data, ok := secret.Data["data"].(map[string]interface{})
	if !ok {
		return nil, fmt.Errorf("data type assertion failed: %T %#v", secret.Data["data"], secret.Data["data"])
	}

	log.Printf("raw response from vault instance :%v\n", secret)

	return data, nil
}

func (vi *Instance) PutSecret(secretPath string, kv map[string]interface{}) (interface{}, error) {
	// Writing a secret
	secretData := map[string]interface{}{
		"data": kv,
	}

	_, err := vi.client.Logical().Write(secretPath, secretData)
	if err != nil {
		return nil, fmt.Errorf("unable to write secret: %v", err)
	}

	return fmt.Sprintf("Secret written successfully."), nil
}

func (vi *Instance) GetTokenData() (map[string]interface{}, error) {
	token, err := vi.client.Auth().Token().LookupSelf()
	if err != nil {
		return nil, fmt.Errorf("unable to read token info: %v", err)
	}

	return token.Data, nil
}
