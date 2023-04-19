#!/bin/sh

set -ex 

get_kubeconfig() {
    aws eks --region "${REGION}" update-kubeconfig --name tc-${NAMESPACE}-eks
}

regenerate_secrets() {
    echo "Regenerating secrets"
    cd /usr/Siemens/Teamcenter13/teamcenter_root/jwt_config_tool
    mkdir -p /usr/Siemens/Teamcenter13/teamcenter_root/signer_config
    chmod +x generate_keystore
    KEYSTORE_PWD=$(aws secretsmanager get-secret-value --secret-id=${KEYSTORE_SECRET_NAME} | jq -r '.SecretString')
    ./generate_keystore '$KEYSTORE_PWD'
    cp signer_config/* ../container/secrets/
    cp validator_config/* ../container/secrets/
    cp signer_config/* ../signer_config/
    cd /usr/Siemens/Teamcenter13/teamcenter_root/container/secrets/
    if [ -f "signer_tc_micro_security.properties" ]; then
        mv signer_tc_micro_security.properties signer_tc_micro_security.properties.bkp
        cp tc_micro_security.properties signer_tc_micro_security.properties
    fi
}

delete_previous() {
    for s in $(kubectl -n ${NAMESPACE} get secrets -o=jsonpath='{.items[*].metadata.name}') ; do 
        if [[ "$s" =~ ^default.* ]] ; then
            continue
        fi
        kubectl -n ${NAMESPACE} delete secret $s
    done
    for cm in $(kubectl -n ${NAMESPACE} get cm -o=jsonpath='{.items[*].metadata.name}') ; do 
        kubectl -n ${NAMESPACE} delete cm $cm
    done

    kubectl -n ${NAMESPACE} delete deployment filerepo --ignore-not-found
    kubectl -n ${NAMESPACE} delete pvc ffilerepo-pvc --ignore-not-found=true --grace-period=0 --force

    if kubectl get pv filerepo-pv-${NAMESPACE} ; then
        kubectl patch pv filerepo-pv-${NAMESPACE} -p '{"metadata":{"finalizers":null}}'
        kubectl delete pv filerepo-pv-${NAMESPACE} --ignore-not-found=true --grace-period=0 --force &
        sleep 5
        if kubectl get pv filerepo-pv-${NAMESPACE} ; then
            kubectl patch pv filerepo-pv-${NAMESPACE} -p '{"metadata":{"finalizers":null}}'
        fi
    fi
}

apply_manifests() {
    cd /usr/Siemens/Teamcenter13/teamcenter_root/container/kubernetes/setup/scripts
    sudo chmod +x *
    ls -la

    sh ./tcgql_loadfiles.sh
    sh ./loadSecrets.sh

    cd /usr/Siemens/Teamcenter13/teamcenter_root/container/kubernetes/deployment

    kubectl apply -f darsi.yaml
    kubectl apply -f msf_env.yaml
    kubectl apply -f tc_microservice_framework.yaml
    kubectl apply -f microserviceparameterstore.yaml
    kubectl apply -f tcgql.yaml
    
    cd /usr/Siemens/Teamcenter13/teamcenter_root/container/kubernetes/setup/scripts

    sh ./gateway_loadfiles.sh

    cd /home/tc/kubernetes
    kubectl apply -f storageclass.yaml

    cd /usr/Siemens/Teamcenter13/teamcenter_root/container/kubernetes/setup

    kubectl apply -f gateway_persistentvolume.yaml
    kubectl apply -f gateway_pvc.yaml

    cd /usr/Siemens/Teamcenter13/teamcenter_root/container/kubernetes/deployment
    kubectl apply -f gateway.yaml
}

patch_filerepo() {
    cd /home/tc/kubernetes

    if ! kubectl get pv filerepo-pv-${NAMESPACE} ; then
        kubectl apply -f filerepo_persistentvolume.yaml
    fi

    kubectl apply -f filerepo_pvc.yaml
    cd /usr/Siemens/Teamcenter13/teamcenter_root/container/kubernetes/deployment
    TC_USER_ID=$(id tc -u)
    TC_GROUP_ID=$(id tc -g)
    yq e -i 'eval(.spec.template.spec.securityContext.runAsUser='$TC_USER_ID')' filerepo.yaml
    yq e -i 'eval(.spec.template.spec.securityContext.runAsGroup='$TC_GROUP_ID')' filerepo.yaml

    kubectl apply -f filerepo.yaml
}

get_kubeconfig
#regenerate_secrets
delete_previous
apply_manifests
patch_filerepo

