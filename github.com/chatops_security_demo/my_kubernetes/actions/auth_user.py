import sys
import yaml

from st2actions.runners.pythonrunner import Action

class MyAuthUser(Action):
    def run(self, users_list , user, channel):
        print("current slack user :   ",user)
        print("users_list: ", users_list)
        
        #users_dict=yaml.load(users_list)   
        #print ("users dict: ", users_dict)
        if (user in users_list['users']) and (channel in users_list['channels']):
            return (True)
        exit(1)
