#!/bin/sh
install_amazon_cloudwatch_agent(){
    # replace buildserver with machine_name value
    sudo sed -i "s|machine_name|${MACHINE_NAME}|g" /tmp/deployment_log_files.json 
    echo "Download installer"
    sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
    echo "echo install package"
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
    echo "starting agent"
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/tmp/config.json -s
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m ec2 -s -c file:/tmp/deployment_log_files.json
    echo "Installation completed"
    sudo systemctl enable amazon-cloudwatch-agent.service
    sudo systemctl start amazon-cloudwatch-agent.service
    echo cloudwatch agent started
}
install_amazon_cloudwatch_agent