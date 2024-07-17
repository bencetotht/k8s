# Running it with installation
## Install the package
```bash
sudo apt install usbip
```
### For `CANDIDATE NOT FOUND` errors:
```bash
sudo apt install linux-tools-generic linux-tools-6.8.0-1005-raspi -y
```
## Connect
```bash
usbip list -p -l
usbip bind --busid=<BUS_ID>
usbipd
```
## Attach
```bash
usbip.exe attach -r <IP> -b 2-2
```
# Running it with docker
```bash
docker build -t custom-usbip-server .
```
# Attach the USB device
## Get USB bus id
```bash
dmesg | grep -i usb

lsusb
usbip list -p -l
```
```bash
docker run -d --name usbip-server --privileged --device=/dev/bus/usb/001/002 dperson/usbip-server
docker exec -it usbip-server bash
usbip bind -b <bus_id>
```
---
https://superuser.com/questions/1811071/usbip-client-for-windows-without-needing-to-put-the-whole-system-in-test-mode