#!/bin/bash
modprobe usbip_host
usbip bind --busid=<bus_id>
usbipd -D
tail -f /dev/null
