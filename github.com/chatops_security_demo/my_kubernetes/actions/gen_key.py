import sys,os,stat
import yaml

from st2actions.runners.pythonrunner import Action

class Gen_Key(Action):
    def run(self, key_pair, dest_file):

		dest_file = dest_file.encode("utf-8")

		try :
			with open(dest_file,"w+") as myfile:
				myfile.write(key_pair['key'].encode("utf-8"))
			os.chmod(dest_file,stat.S_IREAD)
			return (True)
		except Exception as e:
			print "Exception in generating ssh key : ", e
			exit(1)
