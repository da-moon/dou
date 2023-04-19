# Simulator IoT

It sends messages D2C (Device To cloud)

## How to start

### Pre-requisites

1. Python3 Installed

2. Get Device Primary Connection String in IoT Hub for `IOTHUB_DEVICE_CONNECTION_STRING`

3. Install the modules with `pip3 install -r requirements.txt`

## Run simulator

1. Set the environment variable `IOTHUB_DEVICE_CONNECTION_STRING`
   ```bash
   export IOTHUB_DEVICE_CONNECTION_STRING="HostName=FIS-IoTHub.azure-devices.net;DeviceId=TestDevice;SharedAccessKey=a8FPHuQFDaVg1eDOjqocIVttvs12wSEzlnr761/f3zE="
   ``` 
2. Run `simulator.py`
    ``` bash
    python3 simulator.py
    ```

## Stop simulator


To Stop simulator, press `ctrl + c`