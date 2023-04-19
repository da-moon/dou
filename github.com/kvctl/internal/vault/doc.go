// Package vault is a physical backend that stores data on Vault cluster KV secrets engine.
// Run the following to start vault server in debug mode
// vault server -log-level=debug -tls-skip-verify -dev -dev-transactional -dev-ha -dev-listen-address=127.0.0.1:9200 -dev-root-token-id=root
package vault
