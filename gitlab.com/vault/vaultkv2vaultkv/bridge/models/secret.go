package bridge

type VaultSecret struct {
	Path          string
	VersionedData map[int64]VaultSecretData
	Secret        []*VaultSecret
}

type VaultSecretData struct {
	Data        map[string]interface{}
	CreatedTime string
}
