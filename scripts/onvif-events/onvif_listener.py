from onvif import ONVIFCamera
import time
import os

CAMERA_IP = '192.168.50.84'
PORT=2020
USERNAME=os.environ['ONVIF_USERNAME']
PASSWORD=os.environ['ONVIF_PASS'] 

camera = ONVIFCamera(CAMERA_IP, PORT, USERNAME, PASSWORD)

events = camera.create_events_service()
pullpoint = events.CreatePullPointSubscription()

while True:
    messages = pullpoint.PullMessages({'Timeout': 'PT10S', 'MessageLimit': 10})
    for msg in messages.NotificationMessage:
        print(msg.Topic._value_1)
        try:
            print(msg.Message.Message.__dict__)
        except:
            pass
    time.sleep(1)

