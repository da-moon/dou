[![CircleCI](https://circleci.com/gh/DigitalOnUs/sentinel-datadog-poc.svg?style=shield&circle-token=8f7eaf0919587d46ad02649d5e8ca44adf5b20dc)](https://circleci.com/gh/DigitalOnUs/sentinel-datadog-poc)
[![CircleCI](https://circleci.com/gh/DigitalOnUs/sentinel-datadog-poc.svg?style=svg&circle-token=8f7eaf0919587d46ad02649d5e8ca44adf5b20dc)](https://circleci.com/gh/DigitalOnUs/sentinel-datadog-poc)

---

# Sentinel DataDog POC

This POC demonstrates how to leverage TFE and DataDog to provide insights about Sentinel Policies.

![DataDog Visualization1](./_docs/DD-1.png)

---

## Filtering by TFE Workspace is also posible!

![DataDog Visualization2](./_docs/DD-2.png)



### Requirements
* TFE Account  
* DataDog Account
---

## How this works?
It uses TFE API to get policy checks and [sentinel-datadog.sh](./sentinel-datadog.sh) script do the magic!. This shell script leverage DataDog API to create custom metrics.