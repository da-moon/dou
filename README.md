# IIDK-hello-world

hello-world for IIDK building of immutable images.

# Description

This repository is an example of how to build a custom image for any of the supported platforms for the IIDK framework. These can be found [here](https://github.com/DigitalOnUs/IIDK/tree/sam-testing#supported-cloud-platforms)

## Prerequisites to create you own images

1. You will need to make sure the roles and playbooks you plan to use have been created and testing in the main repository for [IIDK](https://github.com/DigitalOnUs/IIDK)
2. Then you will need to create a repository of you own in github.

  - The name of the repo should match the name of the playbook that was created in the main [IIDK](https://github.com/DigitalOnUs/IIDK/tree/main/linux/ubuntu/playbooks) playbooks.

3. Now you can copy of the .circleci folder that contains the logic for the build process to you repository.

4. Now you can create you `build.config` file that controls the building of your image.

  - You will need to provide `IIDK_GIT_URL` , `IIDK_VERSION` [versions](https://github.com/DigitalOnUs/IIDK/releases), `BASE_AMI`, `PLATFORM`

    ```
    IIDK_GIT_URL=github.com/DigitalOnUs/IIDK
    IIDK_VERSION=0.0.3
    BASE_AMI=ubuntu
    PLATFORM=aws
    ```

## Notes

To patch your custom image you will need to just rerun your circle pipeline. [API Triggers](https://circleci.com/docs/2.0/api-job-trigger/)

## Maintainers

- Sam Flint sam.flint@digitalonus.com
