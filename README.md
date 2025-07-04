# The House of Ill Compute
My adventures in computing which may or may not be useful to someone.


## USB Gadget Mode - July 3, 2025

### Goal
Using an iPad as a portable display for a Raspberry Pi (Zero W in my case) that can provide power and can "see" the Pi via SSH and VNC. So far, I've managed to get it working with a Mac -> Pi. Will update when (if?) I get to the real goal of connecting an iPad.

### The physical connection
Mac's USB C -> Pi's USB Micro. Make sure to use the Data/Power USB port on the Pi and NOT the Power-only one. Also make sure your cable isn't garbage.

### On the Raspberry Pi Zero W

Add the following to the `[all]` section of `/boot/config.txt`

```bash
dtoverlay=dwc2
```

Add the following after the word `rootwait` in `/boot/cmdline.txt`. Make sure it's all one big block like so, and notice where there is and isn't any spaces.

```bash
console=serial0,115200 console=tty1 root=PARTUUID=71603c9d-02 rootfstype=ext4 fsck.repair=yes rootwait modules-load=dwc2,g_ether quiet splash plymouth.ignore-serial-consoles cfg80211.ieee80211_regdom=US
```

Here's the part that's not well documented elsewhere. The Mac and the Pi would not cooperate with dynamic IP addresses. So on the PI:

Add this to the end of `/etc/dhcpcd.conf`

```bash
interface usb0
static ip_address=192.168.2.2/24
static routers=192.168.2.1
static domain_name_servers=192.168.2.1 8.8.8.8
```

### On the Mac
1. Find the "RNDIS/Ethernet Gadget" interface in system preferences > Network
2. Manually configure IP to 192.168.2.1, subnet mask to 255.255.255.0

![mac-interface](https://github.com/user-attachments/assets/799bfada-4074-401c-9f54-89f6f92c17b5)

### Give it a whirl
You should be able to connect the same way you would over the network. Mac's Bonjour service can reference both a wireless and "gadget" connection with the host name, e.g.
```
ssh mypiuser@mypihost.local
```

My next steps is to get this working on the iPad.
