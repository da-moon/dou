#Directories
DIR_INFRA = ./infrastructure
DIR_IMAGE = ./image
#Files
#IMAGES_SRC := $(shell cd ${DIR_IMAGE} && find . -name '*.json')
#Commands
P_BUILD = packer build
T_PLAN = terraform plan
T_APPLY = terraform apply --auto-approve

build_jenkins:
		cd ${DIR_IMAGE} && ${P_BUILD} jenkins.json
		
build_vault:
		cd ${DIR_IMAGE} && ${P_BUILD} vault.json

plan: 
		cd ${DIR_INFRA} && ${T_PLAN}

apply: 
		cd ${DIR_INFRA} && ${T_APPLY}
	
