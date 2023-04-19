package bridge

import (
	"fmt"
	"log"

	"gitlab.com/DigitalOnUs/vault/vaultkv2vaultkv/bridge/vault"
)

type VaultInstancesManager struct {
	Origin      vault.Manager
	Destination vault.Manager
}

func NewVaultInstanceManager(originInstance vault.Manager, destinationInstance vault.Manager) *VaultInstancesManager {
	return &VaultInstancesManager{
		Origin:      originInstance,
		Destination: destinationInstance,
	}
}

func (vim *VaultInstancesManager) StartMigration() error {
	err := vim.Origin.StartClient()
	if err != nil {
		return fmt.Errorf("error in origin instance: %s", err)
	}

	err = vim.Destination.StartClient()
	if err != nil {
		return fmt.Errorf("error in destination instance: %s", err)
	}

	_, err = vim.Origin.CheckSeal()
	if err != nil {
		return fmt.Errorf("error in origin instance: %s", err)
	}

	_, err = vim.Origin.CheckSeal()
	if err != nil {
		return fmt.Errorf("error in destination instance: %s", err)
	}

	_, err = vim.Origin.GetNamespace()
	if err != nil {
		return fmt.Errorf("error when retrieve origin instance namespaces: %s", err)
	}

	tokenData, err := vim.Origin.GetTokenData()
	if err != nil {
		return err
	}

	isKvEngine, err := vim.Origin.IsKvEngineType()
	if err != nil {
		return err
	}

	if !isKvEngine {
		return fmt.Errorf("instance does not have K/V engine mount")
	}

	fmt.Printf("%v", tokenData)
	testSecretPath := "secret/data/my-secret-password"
	/*	testKv := map[string]interface{}{
			"mysecret": "mypassword",
		}

		_, err = vim.Origin.PutSecret(testSecretPath, testKv)
		if err != nil {
			return fmt.Errorf("error trying to create secret in origin :%s", err.Error())
		}
	*/
	responseKv, err := vim.Origin.GetSecret(testSecretPath)
	if err != nil {
		return fmt.Errorf("error trying to get secret in origin :%s", err.Error())
	}

	log.Printf("response from vault:%v", responseKv)

	/*
		_, err = vim.Destination.PutSecret(testSecretPath, responseKv.(map[string]interface{}))
		if err != nil {
			return fmt.Errorf("error trying to get secret in origin :%s", err.Error())
		}
	*/



	err = vim.Origin.GetKVEngines()
	if err!=nil{
		return err
	}


	secretDataPath := "secret/data"
	secretMetadataPath := "secret/metadata"
	if "i" == "1" {
		secretMetadataPath = "secret"
		secretMetadataPath = "secret"
	}
	secretTree, _ := vim.Origin.GetSecretList("")

	fmt.Sprintf("%v", secretTree)
	return nil
}

func (vim *VaultInstancesManager) IsAlive() error {

	return nil
}
