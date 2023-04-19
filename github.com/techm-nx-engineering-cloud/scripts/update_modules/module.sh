#!/bin/bash

remove_module(){
    if [ $# -gt 0 ]; then
        MODULE=$1
        REGION=$2
        ERROR_COUNT=0
        echo "Module to deregister ${MODULE}"
        echo $REGION
        #Get arn module
        echo 'MODULE_ARN'
        MODULE_ARN=$(aws cloudformation list-types --type MODULE --output json | jq -r '.TypeSummaries | map(select(.TypeName == "TechM::NX::'${MODULE}'::MODULE")) | .[].TypeArn')
        echo $MODULE_ARN
        #Get version module
        echo 'MODULE_VERSION'
        MODULE_VERSION=$(aws cloudformation list-types --type MODULE --output json | jq -r '.TypeSummaries | map(select(.TypeName == "TechM::NX::'${MODULE}'::MODULE")) | .[].DefaultVersionId')
        echo $MODULE_VERSION
        #Get module name
        echo 'MODULE_NAME'
        MODULE_NAME=$(aws cloudformation list-types --type MODULE --output json | jq -r '.TypeSummaries | map(select(.TypeName == "TechM::NX::'${MODULE}'::MODULE")) | .[].TypeName' | sed 's/::/-/g')
        echo $MODULE_NAME
        MODULE_NAME2=$(aws cloudformation list-types --type MODULE --output json | jq -r '.TypeSummaries | map(select(.TypeName == "TechM::NX::'${MODULE}'::MODULE")) | .[].TypeName')
        echo $MODULE_NAME2
        
        #=================================================================================================
        #=================================================================================================
        echo 'deregistering module' ${MODULE_NAME}
        ERRORS=$(aws cloudformation deregister-type --type MODULE --type-name ${MODULE_NAME2})
        if [ "$?" -gt "0" ]; then
            ((ERROR_COUNT++));
            echo "[fail]" $ERRORS;
            echo "Deregistering all previous module versions ${MODULE_NAME}"
            TEMP=$(echo $MODULE_VERSION | sed 's/^0*//')
            let "TEMP+=1"
            while [ $TEMP -ge 1 ]
            do
                echo ${MODULE_NAME2}
                if [ $TEMP -gt 9 ]; then
                    aws cloudformation deregister-type --arn arn:aws:cloudformation:${REGION}:520983883852:type/module/${MODULE_NAME}/000000${TEMP}
                    if [ "$?" -gt "0" ]; then
                    aws cloudformation deregister-type --type MODULE --type-name ${MODULE_NAME2}
                    fi
                else
                    aws cloudformation deregister-type --arn arn:aws:cloudformation:${REGION}:520983883852:type/module/${MODULE_NAME}/0000000${TEMP}
                    if [ "$?" -gt "0" ]; then
                    aws cloudformation deregister-type --type MODULE --type-name ${MODULE_NAME2}
                    fi
                fi
            let "TEMP-=1"
            done
        fi;
        cfn submit
        echo "Module updated"
        cd -
    else
        for entry in ../../modules/*/ ; 
        do
            echo "=================================================================="
            echo "START"
            echo "=================================================================="
            echo "Module path"
            echo $entry
            cd $entry

            echo "Module name from rpdk-config file"
            MODULE_NAME=$(jq '.typeName' .rpdk-config)
            n=${#MODULE_NAME}
            echo $MODULE_NAME

            echo "Just the module name"
            b=${MODULE_NAME:12:$((n-21))}
            echo $b
            echo "Region"
            region=$(aws configure get region)
            echo $region
            MODULE_ARN=$(aws cloudformation list-types --type MODULE --output json | jq -r '.TypeSummaries | map(select(.TypeName == "TechM::NX::'${b}'::MODULE")) | .[].TypeArn')
            
            if [ "$MODULE_ARN" = "" ]; then
              echo "module doesn't exist"
              echo "registering the module"
              cfn submit
              cd -
            else
              echo "modules exist, updating"
              remove_module $b $region
            fi;
        done

    fi;
}
remove_module $1 $2

