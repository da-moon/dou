# chatops_security_demo
demo security model to execute kubernetes commands on remote servers through slack

Preconditions 
  1. A chatops environment with slack, hubot and stackstorm. 
  2. AWS ec2 instances with kubernetes environment.

Steps 
  1. install and configure vault package from : https://github.com/StackStorm/st2contrib/tree/master/packs/vault
  
  2. Add admin for chatops:
          vault write secret/admins admin="slack_username"
  
  3. Add initial users and channels list:
          vault write secret/demo users=["users1", "users2",...] channels=["channel1", ...]
  
  4. Add aws pem key :
          vault write secret/aws_key key=@your_key.pem
          #delete the pem file from the system now.
 
  5. clone the packages provided in this repo to /opt/stackstorm/packs/ .

  6. copy the scripts inside my_vault to the vault package and register the actions.
