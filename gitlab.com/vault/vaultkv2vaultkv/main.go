package main

import (
	"flag"
	"log"

	"gitlab.com/DigitalOnUs/vault/vaultkv2vaultkv/bridge"
	"gitlab.com/DigitalOnUs/vault/vaultkv2vaultkv/bridge/vault"
)

func main() {
	originUrl := flag.String("origin-address", "", "origin vault instance url")
	originName := flag.String("origin-name", "10", "origin vault instance name")
	originToken := flag.String("origin-token", "root", "origin vault instance token")
	destinationUrl := flag.String("destination-address", "", "destination vault instance url")
	destinationName := flag.String("destination-name", "10", "destination vault instance name")
	destinationToken := flag.String("destination-token", "root", "destination vault instance token")
	originNamespace := flag.String("origin-ns", "root/", "origin vault instance namespace")
	destinationNamespace := flag.String("destination-ns", "root/", "destination vault instance namespace")
	flag.Parse()

	if *originUrl == "" {
		log.Fatal("origin-instance-url not set in params")
	}

	if *destinationUrl == "" {
		log.Fatal("destination-instance-url not set in params")
	}

	//args := flag.Args()

	manager := bridge.NewVaultInstanceManager(
		&vault.Instance{
			Name:      *originName,
			Address:   *originUrl,
			Token:     *originToken,
			Namespace: *originNamespace,
		},
		&vault.Instance{
			Name:      *destinationName,
			Address:   *destinationUrl,
			Token:     *destinationToken,
			Namespace: *destinationNamespace,
		},
	)

	err := manager.StartMigration()
	if err != nil {
		log.Fatal(err)
	}
	log.Println("secrets migrated successfully!")
}
