package bridge_test

import (
	"testing"

	"gitlab.com/DigitalOnUs/vault/vaultkv2vaultkv/bridge"
	"gitlab.com/DigitalOnUs/vault/vaultkv2vaultkv/bridge/vault"
)

func Test_StartMigration(t *testing.T) {
	//args := flag.Args()

	manager := bridge.NewVaultInstanceManager(
		&vault.Instance{
			Name:    "test_origin",
			Address: "http://127.0.0.1:8210",
			Token:   "root",
		},
		&vault.Instance{
			Name:    "test_destination",
			Address: "http://127.0.0.1:8220",
			Token:   "root",
		},
	)

	err := manager.StartMigration()
	if err != nil {
		t.Fatal(err)
	}

}
