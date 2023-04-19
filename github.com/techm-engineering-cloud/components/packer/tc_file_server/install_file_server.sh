#!/bin/sh
if_user_group_exist(){
getent passwd "${USERNAME}"
if [ $? -eq 0 ]; then
    echo "The user ${USERNAME} already exist"
else
    echo "The user does not exist"
    echo "==== creating the user ===="
    sudo useradd -M -d "${SHARE_PATH}" -s /usr/sbin/nologin -G "${USERNAME}" "${USERNAME}"
    sudo useradd -M -d "${SHARE_PATH}" -s /usr/sbin/nologin -G "${USERNAME}" "${USERNAME}"
fi

getent group "${USERNAME}"
if [ $? -eq 0 ]; then
    echo "The group ${USERNAME} already exist"
else
    echo "The group does not exist"
    echo "==== creating the group ===="
    sudo groupadd "${USERNAME}"
fi
}

if_directory_exist(){
  if [ -d "${SHARE_PATH}" ]; then
  # Take action if "${SHARE_PATH}" exists. #
    echo "The directory already exist"
  else
    sudo chown "${USERNAME}":"${USERNAME}" /usr/Siemens/
    sudo -u tc mkdir -p "${SHARE_PATH}"
    echo "Directory created ${SHARE_PATH}"
fi
}

##Code will be added later
echo "=============== installing samba-client ======================="
sudo yum -y install samba samba-client 
sudo systemctl start nmb.service
sudo systemctl start smb.service
sudo systemctl enable smb.service
sudo systemctl enable nmb.service
echo "=============== Create share directory ========================="
if_directory_exist
echo "=================== Creating User ============================="
if_user_group_exist
echo "=========== Set the shared directory group ownership to tc  ================="
sudo chgrp "${USERNAME}" "${SHARE_PATH}"
echo "============ Add the user account to the Samba database by setting the user password ============"
SAMBA_PASS=$(aws secretsmanager get-secret-value --secret-id=${SAMBA_PASSWORD} | jq -r '.SecretString')
echo -e "${SAMBA_PASS}\n${SAMBA_PASS}" | sudo smbpasswd -a -s "${USERNAME}"
echo "============= Activate the account ======================"
sudo smbpasswd -e "${USERNAME}"

echo "========== creating custom smb.conf =================="
echo "[global]
	workgroup = ${USERNAME}
	security = user

	map to guest =  never
    guest ok = no
    client min protocol = SMB2
    client max protocol = SMB3

[tc]
        path = ${SHARE_PATH}
        browseable = yes   
        read only = yes   
        force create mode = 0660   
        force directory mode =  2770   
        create mask = 0775   
        directory mask = 0775   
        available = yes
        public = yes  
        valid users =  ${USERNAME}" | sudo tee -a /etc/samba/smb.conf

echo "=========== change a type of a web directory  =============="
sudo setsebool -P samba_share_nfs 1

echo "========== restart the services ====================="
sudo systemctl restart smb.service
sudo systemctl restart nmb.service

#/etc/samba/smb.conf