import sys
import json,ast

from st2actions.runners.pythonrunner import Action

class MyAuthAdmin(Action):

    def run(self, admin_list , admin):
        
    	admin_list = ast.literal_eval(json.dumps(admin_list))	
	    admin = admin.encode("utf-8")
        
        if (admin in admin_list['admins']):
            return (True)
        
        exit(1)

