# Setting up a direct connection between a Pi Zero W and a Mac or iPad

![IMG_5345](https://github.com/user-attachments/assets/cc9c53af-c0c0-4e9b-b7e8-bcbc421aea37)


## Goal
Using an iPad as a portable display for a Raspberry Pi (Zero W in my case) that can provide power and can directly communicate with the Pi via SSH and VNC, even without network access on either device.

### STEP 1: Make the physical connection
Connect the Mac or iPad's USB C port to the Pi's Micro USB Data/Power port. IMPORTANT: Make sure to use the Data/Power USB port on the Pi and NOT the Power-only one. Also make sure your cable isn't garbage.

**NOTE:** An additional Power source is not required! The Pi will receive its power from the Gadget Mode connection.

### STEP 2: Configure the Pi for "USB Gadget Mode"
Add the following to the `[all]` section of `/boot/config.txt`

```sh
dtoverlay=dwc2
```

Add `modules-load=dwc2,g_ether` after `rootwait` in `/boot/cmdline.txt`. **Make sure it's all on one line, and notice where there are and aren't spaces.** It doesn't matter if what you have is different as long as `modules-load=dwc2,g_ether` is inserted after `rootwait`.

```sh
console=serial0,115200 console=tty1 root=PARTUUID=71603c9d-02 rootfstype=ext4 fsck.repair=yes rootwait modules-load=dwc2,g_ether quiet splash plymouth.ignore-serial-consoles cfg80211.ieee80211_regdom=US
```

### STEP 3: Configure networking on the Pi 
**Here's the part that I haven't found well documented elsewhere.**

I had two problems at this point. 1) The Pi would not cooperate with dynamic IP addresses and 2) The Pi could only handle one type of connection at a time, which means it couldn't access the Internet which connected to the iPad. Sort of a a dealbreaker.

The solution is to set up the Pi with a static IP address for the USB mode, and two interfaces: "usb0" for allowing the iPad to connect to it and "wlan0" for giving itself access to the Interwebs.

To do this, add this to the end of `/etc/dhcpcd.conf`

```sh
interface usb0
    static ip_address=192.168.2.2/24
    static routers=192.168.2.1
    static domain_name_servers=192.168.2.1 8.8.8.8
    metric 300

interface wlan0
    metric 100
```

### STEP 3A: Connecting from a Mac
![mac-interface](https://github.com/user-attachments/assets/799bfada-4074-401c-9f54-89f6f92c17b5)
1. Find the "RNDIS/Ethernet Gadget" interface in system preferences > Network
2. Manually configure IP to 192.168.2.1, subnet mask to 255.255.255.0

### STEP 3B: Connecting from an iPad
1. Since the iPad only has a single USB C port, this is where a small USB hub becomes necessary: Keyboard and Pi Zero → Hub → iPad USB C.
2. You'll find the RNDIS/Ethernet gadget connection under Settings → Ethernet. There, they work the same as on a Mac. Set the Manual IP and Subnet Mask.
3. On the iPad, `Accessibility → Keyboards & Typing → Full Keyboard Access` should be turned OFF. With it on, many of the iPad's special keyboard shortcuts for operating the iPad interfere with the SSH Client (Blink app).

### STEP 4: Give it a whirl!
You should be able to connect the same way you would over the network, using the machine's host name, as opposed to the IP address. Of course, use the username and hostname of your Pi.
```sh
ssh laz@pippy.local
```

## Changing WIFI networks
To recap, the whole point of this was to be able to connect an iPad to a Pi Zero with a single USB cable even without them both being on a shared network. That said, you likely DO want the Pi to have Internet access and, as mentioned, the iPad won't share it's connection because Tim Cook said so. We prepared for this by setting up `wlan0` in step 3, but how do we provide our credentials for new WIFI locations? Pretty simple:

```sh
sudo raspi-config
```
![CleanShot 2025-07-05 at 06 12 37](https://github.com/user-attachments/assets/89d7454d-fa0d-4386-8845-e091721da62b)

