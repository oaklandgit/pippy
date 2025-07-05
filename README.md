# Setting up a direct connection between a Pi Zero W and an iPad

![IMG_5345](https://github.com/user-attachments/assets/cc9c53af-c0c0-4e9b-b7e8-bcbc421aea37)


## Background
I've been working on building my dream console I'll refer to as "Pippy." In concept, it's compact, yet sports a delicious-to-type-on ortholinear "planck" style keyboard, and is driven by a Raspberry Pi Zero W under the hood. What it lacks in power it makes up for in portability, user experience and, yes, my own personal aesthetic.

From the start, while the choice of keyboard was obvious to me, a suitable display and battery proved elusive. I simply couldn't find a screen with the brightness power efficiency and form factor I wanted.

But it occured to me that I already have a device with a display an battery that I would want to carry around alongside Pippy anyway. My iPad.

My iPad Air not only has a nice, bright screen and long-lasting battery, I can use it to draw my web comic ([B-Lab](https://blabcomic.com), watch YouTube, browse the web and  access my Apple ecosystem.

What my iPad sorely lacks, however, is the ability to do any modicum of coding (for my professional work as a user experience designer and software developer) and tinkering with the system itself (part and parcel for what it means to do computing IMHO). Despite all the processing power of its iPad lineup, Apple still refuses to endow it with the capabilities of an openly-accessible system like MacOS. Despite recently-announced updates that give iPadOS a more Mac-like windowing experience, it's not sufficient for coders and tinkerers like myself.

But pairing an iPd with a Raspberry Pi, I could leverage each's strengths: all the benefits of iPad things while providing power and a great display power for my Pi, so that *it* can handle the Linuxy things.

But figuring out precicely how sent me down a rabbit hole of false starts, dead ends. And while it was surprisingly tricky to figure out how to actually pull it off, once I learned it is actually quite elegant and easy.

So I'll share that with you. But first, let's look at…

## What Didn't Work

### Over-the-Network Connectivity
Using SSH and VNC to interact with a Pi over the network is trival, and there are plenty of tutorials to show you the ropes. Basically, both the iPad and Pi join the same network, and the Pi is configured to open its SSH and/or VNC to be accessed by a guest device. It works fine, but has one fatal flaw for my use case: It's not a good choice for use on a *portable, and integrated* device because it relies on that shared network connection which 1) may not always be available and 2) must be configured on each device to join a new network and 3) firewalls and the like. Also, it seems like overkill to leverage a *remote-connection* technology by two devices that are literally attached to one another!

### Serial UART Connectivity
Which brings me to the option of serial communications. Could I connect from the iPad's USB C to the Pi using good, old-fashioned TX and RX? Between a Mac and Pi yes. You need USB to Serial adapter (ie one with an FTDI chip) and some simple wiring to the Pi's GPIO pins. But when you swap in an iPad for the Mac, you're suddenly faced with the frustrating truth: being a closed system, the only devices and software I could find to make that connection are proprietary and expensive (and often recurring, subscription-based at that!) No thanks. Regardless, even if it were free, Serial has limitations of its own. It's a slow way to send data back and forth. Remember, these 2 devices are meant to act as one. Being *physically connected* yet still slower than Over-the-Network connectivity seemed like a step backwards.

## Enter "USB Gadget Mode!"
This solution not only works for my use case, it brings with it benefits that align perfectly that -- once you figure out *how* -- does not feel at all like a hack. It's both elegant and aligned with the task.

Basically, USB Gadget mode turns a USB connection into a direct ethernet connection between the devices. While ethernet is itself a "networking" technology, it is fast enough to be considered a bridge for local computing. When you keep in mind that a cluster of Raspberry Pis are often wired together via Ethernet as a single big brain, you realize this. And one incredibly convenient benefit is that this connection can share both data and power, which speaks to my original goal: using my iPad as a display AND power source for the Pi.

## Here's how to do it:

### STEP 1: Make the physical connection
Connect the Mac or iPad's USB C port to the Pi's Micro USB Data/Power port. IMPORTANT: Make sure to use the Data/Power USB port on the Pi and NOT the Power-only one. Also make sure your cable isn't garbage. **An additional Power source is not required!** The Pi will receive its power from the Gadget Mode connection.

### STEP 2: Configure the Pi for Gadget Mode
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

I had two problems at this point. 1) The Pi would not cooperate with dynamic IP addresses and 2) The Pi could only handle one type of connection at a time, which means it couldn't access the Internet while simultaneously connected to the iPad. Sort of a a dealbreaker.

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
Even though a Mac-to-Pi connection was not my intended goal, I found it helpful to do first since there are fewer gotchas.

![mac-interface](https://github.com/user-attachments/assets/799bfada-4074-401c-9f54-89f6f92c17b5)
1. Find the "RNDIS/Ethernet Gadget" interface in `System Preferences → Network`
2. Manually configure IP to `192.168.2.1`, subnet mask to `255.255.255.0`

### STEP 3B: Connecting from an iPad
1. Since the iPad only has a single USB C port, this is where a small USB hub becomes necessary: Keyboard and Pi Zero → Hub → iPad USB C.
2. You'll find the RNDIS/Ethernet gadget connection under `Settings → Ethernet`. There, they work the same as on a Mac. Set the Manual IP and Subnet Mask.
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

