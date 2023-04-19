import json
from datetime import timezone
import datetime
from random import sample, randint, uniform
from re import A
from time import sleep
import threading
from azure.iot.device import IoTHubDeviceClient, Message
import os
import uuid

timerEnded = False
timerRestarted = False
countSentMessages = 0
countDownTimer = 600


def main():
    global countDownTimer

    absolute_path = os.path.dirname(os.path.abspath(__file__))

    stations = ["110", "120", "130", "140", "150", "160", "170", "180", "190"]
    threadsA = []
    threadsB = []
    threadsC = []
    lock = threading.Lock()

    
    # End 110

    for station in stations:
        unitsPath = absolute_path + \
            "/data/stations/{}/units.json".format(station)
        jphPath = absolute_path + "/data/stations/{}/jph.json".format(station)
        statePath = absolute_path + \
            "/data/stations/{}/state_code.json".format(station)

        threadsA.append(threading.Thread(target=worker, args=[unitsPath, station, lock])) 
        threadsB.append(threading.Thread(target=worker, args=[jphPath, station, lock])) 
        threadsC.append(threading.Thread(target=worker, args=[statePath, station, lock])) 

    # Start threads
    for thread in threadsA:
        thread.start()
    for thread in threadsB:
        thread.start()
    for thread in threadsC:
        thread.start()

    # For countdown thread
    a = threading.Thread(target=countdown, args=[countDownTimer])
    a.start()

    # Join threads
    for thread in threadsA:
        thread.join()
    for thread in threadsA:
        thread.join()
    for thread in threadsA:
        thread.join()
    
    a.join()

def processFakeData(station, message):
    if station == "110":
        message["Bottleneck_Rank"] = 2
        message["Sole_Bottleneck"] = round(uniform(0.5, 1.5), 1)
        message["Shared_Bottleneck"] = round(uniform(12, 14.5), 1)
    elif station == "120":
        message["Sole_Bottleneck"] = round(uniform(0.2, 1.0), 1)
        message["Shared_Bottleneck"] = round(uniform(10, 11.2), 1)
    elif station == "130":
        message["Bottleneck_Rank"] = 3
        message["Sole_Bottleneck"] = round(uniform(0.5, 1.5), 1)
        message["Shared_Bottleneck"] = round(uniform(12, 14.0), 1)
    elif station == "140":
        message["Sole_Bottleneck"] = round(uniform(0.1, 1.0), 1)
        message["Shared_Bottleneck"] = round(uniform(7.5, 9.0), 1)
    elif station == "150":
        message["Sole_Bottleneck"] = round(uniform(0.1, 1.0), 1)
        message["Shared_Bottleneck"] = round(uniform(7.0, 8.0), 1)
    elif station == "160":
        message["Sole_Bottleneck"] = round(uniform(0.1, 0.8), 1)
        message["Shared_Bottleneck"] = round(uniform(6.5, 7.7), 1)
    elif station == "170":
        message["Sole_Bottleneck"] = round(uniform(0.1, 0.85), 1)
        message["Shared_Bottleneck"] = round(uniform(6.5, 7.7), 1)
    elif station == "180":
        message["Bottleneck_Rank"] = 1
        message["Sole_Bottleneck"] = round(uniform(62.5, 64.0), 1)
        message["Shared_Bottleneck"] = round(uniform(23.5, 25.0), 1)
    elif station == "190":
        message["Sole_Bottleneck"] = round(uniform(0.1, 0.8), 1)
        message["Shared_Bottleneck"] = round(uniform(6.5, 7.7), 1)

    return make_stoppage(message)


def worker(path, station, lock):
    dataPath = open(path)
    dataPath = json.load(dataPath)

    listRandom = sample(range(0, len(dataPath) - 1), len(dataPath) - 1)

    # Units
    for rand in listRandom:
        data = dataPath[rand]
        dt = datetime.datetime.now(timezone.utc)
        utc_time = dt.replace(tzinfo=timezone.utc)
        utc_timestamp = (utc_time.timestamp() + 0.5) * 1000
        data["timestamp"] = str(int(utc_timestamp))
        randomSec = randint(30, 60)
        lock.acquire()
        send_message(rand, json.dumps(processFakeData(station, data)))
        lock.release()
        print("{} seconds to sleep for {}\n".format(randomSec, rand))

        print("Messages sent: {}".format(countSentMessages))
        sleep(randomSec)



def send_message(randInt, message):
    global countSentMessages
    # The connection string for a device should never be stored in code. For the sake of simplicity we're using an environment variable here.
    conn_str = os.getenv("IOTHUB_DEVICE_CONNECTION_STRING")
    # The client object is used to interact with your Azure IoT hub.
    device_client = IoTHubDeviceClient.create_from_connection_string(conn_str)

    # Connect the client.
    device_client.connect()

    print("sending message #" + str(randInt))
    msg = Message(message)
    msg.message_id = uuid.uuid4()
    msg.content_encoding = "utf-8"
    msg.content_type = "application/json"
    device_client.send_message(msg)
    data = json.loads(message)
    print("message sent #{} for {} with {} and {}\n".format(
        randInt, data["Device_ID"], data["timestamp"], next(iter(data))))
    device_client.shutdown()

    countSentMessages += 1


def make_stoppage(message):
    global timerEnded
    global timerRestarted
    global count 
    global countLimit
    makeStoppage = False


    if randint(1, 20) % 2 == 0:  # If it's a pair, make stoppage to simulate
        makeStoppage = True

    print("timerRestarted: {}".format(timerRestarted))
    if makeStoppage and "State_Code" in message and timerRestarted != True:
        print("Simulator of Stoppage started")
        message["Device_ID"] = 32110
        message["Device_Alias"] = "Station 110"
        

        message["Sub_State_Code"] = 3200
        message["Event_Code"] = 0
        message["State_Desc"] = "Stoppage"
        message["Sub_State_Desc"] = "STARVED"
        message["Event_Desc"] = "BLOCKED UPSTREAM"
        message["State_Code"] = 3000

        print("Simulator of Stoppage ended\n")

    return message



def countdown(time_sec):
    global timerEnded
    global timerRestarted
    time_secOriginal = time_sec
    print("Countdown started for {} seconds".format(time_sec))
    while time_sec:
        #mins, secs = divmod(time_sec, 60)
        #timeformat = '{:02d}:{:02d}'.format(mins, secs)
        #print(timeformat, end='\r')
        sleep(1)
        if time_sec == 1:
            if timerRestarted:
                timerRestarted = False
            else:
                timerRestarted = True

            time_sec = time_secOriginal
            print("Countdown restarted")
        time_sec -= 1

    print("Countdown ended")
    timerRestarted = False
    timerEnded = True

    
if __name__ == "__main__":
    main()

