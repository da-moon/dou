import sys
import json,ast

from st2actions.runners.pythonrunner import Action

class MyAuthUser(Action):

    def run(self, secret_dict , new_user, secret_file):
        
    	secret_dict = ast.literal_eval(json.dumps(secret_dict))	

    	new_user = new_user.encode("utf-8")

        if secret_dict.has_key('users') :
            secret_dict['users'].append(new_user)

        try:
            with open(secret_file,"w+") as myfile:
                myfile.write(str(secret_dict).encode("utf-8"))

            return True
        except: 
            exit(1)
