import json
import yaml
from lib import action


class VaultWriteAction(action.VaultBaseAction):
    def run(self, path, secret_file):
        try:
		with open(secret_file,"r+") as myfile:
			secrets = myfile.read()

		return self.vault.write(path, **yaml.load(secrets))
	except Exception as e:
		print ("Exception in write to vault from file : " , e)
		exit(1)
