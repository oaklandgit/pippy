# Setting up a direct connection between a Pi Zero and a Mac or iPad

![A12EB628-EBE5-44D2-84C9-B6D3E6645E56_1_102_o](https://github.com/user-attachments/assets/0fe63425-5cce-4ba3-9cff-e3d9bc87aac9)

## Setting up USB Gadget Mode

### Goal
Using an iPad as a portable display for a Raspberry Pi (Zero W in my case) that can provide power and can directly communicate with the Pi via SSH and VNC, even without network access on either device.

### Making the physical connection
Mac or iPad's USB C → Pi's Micro USB. IMPORTANT: Make sure to use the Data/Power USB port on the Pi and NOT the Power-only one. Also make sure your cable isn't garbage.

### Good news: An additional Power source is not required!
In the photo, you may notice a PiSugar batter pack. That's not necessary for this to work, as the Pi will receive its power from the Gadget Mode connection. For my project, the portability will remain either way, since the presence of the iPad is necessary. However, the battery may be useful but that's another discussion.

### On the Raspberry Pi Zero W
Add the following to the `[all]` section of `/boot/config.txt`

```sh
dtoverlay=dwc2
```

Add `modules-load=dwc2,g_ether` after `rootwait` in `/boot/cmdline.txt`. **Make sure it's all on one line, and notice where there are and aren't spaces.** It doesn't matter if what you have is different as long as `modules-load=dwc2,g_ether` is inserted after `rootwait`.

```sh
console=serial0,115200 console=tty1 root=PARTUUID=71603c9d-02 rootfstype=ext4 fsck.repair=yes rootwait modules-load=dwc2,g_ether quiet splash plymouth.ignore-serial-consoles cfg80211.ieee80211_regdom=US
```

**Here's the part that's not well documented elsewhere.** The Mac and the Pi would not cooperate with dynamic IP addresses. So on the PI:

Add this to the end of `/etc/dhcpcd.conf`

```sh
interface usb0
static ip_address=192.168.2.2/24
static routers=192.168.2.1
static domain_name_servers=192.168.2.1 8.8.8.8
```

### Connecting from a Mac
![mac-interface](https://github.com/user-attachments/assets/799bfada-4074-401c-9f54-89f6f92c17b5)
1. Find the "RNDIS/Ethernet Gadget" interface in system preferences > Network
2. Manually configure IP to 192.168.2.1, subnet mask to 255.255.255.0

## Connecting from an iPad
1. Since the iPad only has a single USB C port, this is where a small USB hub becomes necessary: Keyboard and Pi Zero → Hub → iPad USB C.
2. You'll find the RNDIS/Ethernet gadget connection under Settings → Ethernet. There, they work the same as on a Mac. Set the Manual IP and Subnet Mask.
3. On the iPad, `Accessibility → Keyboards & Typing → Full Keyboard Access` should be turned OFF. With it on, many of the iPad's special keyboard shortcuts for operating the iPad interfere with the SSH Client (Blink app).

### Give it a whirl
You should be able to connect the same way you would over the network, using the machine's host name, as opposed to the IP address.
```sh
ssh mypiuser@mypihost.local
```
To make sure it's working, do this with your Mac or iPad's wifi disabled.




