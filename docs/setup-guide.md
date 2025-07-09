# Pippy Setup guide

Follow these steps if you have a Pippy without a pre-flashed SD card.

## Create a Boot SD

On another computer, use Raspberry Pi Imager to prepare a bootable SD card for Pippy:

1. Device: Raspberry Pi Zero 2 W
2. OS: Raspberry Pi OS (64-bit)
3. Storage: Technically, 64 MB is enough, but we recommend a 4 GB or larger SD card to ensure room for packages and updates.

Configure in Raspberry Pi Imager (click the gear icon before flashing):

1. Enable SSH
2. Set a username: admin
3. Set a hostname: pippy
4. Set a password: anything you like
5. Configure Wi-Fi: enter your Wi-Fi SSID and password

NOTE: Once Pippy is fully configured, you won’t need Wi-Fi to use it with your iPad — the iPad connects over USB.
However, during initial setup, Wi-Fi is required so Pippy can download and install the necessary software.

## Boot Your Pippy

1. Insert the flashed SD card into your Pippy.
2. Connect Pippy to your iPad using a USB-C to USB-C cable. This provides power and display, but network-over-USB will not work until Pippy is fully configured.
3. Wait ~30 seconds. You should see the red power LED light up.

#### NOTE: You’ll configure USB networking later during the Pippy software setup process.

## Connect from iPad

1. On your iPad, launch [La Terminal](https://apps.apple.com/us/app/la-terminal-ssh-client/id1629902861), [Termius](https://apps.apple.com/us/app/termius-modern-ssh-client/id549039908), or any app that supports SSH.
2. After the Pi boots, connect via:

```
ssh admin@pippy.local
```

3. Enter the password you created earlier when prompted.

#### If pippy.local doesn’t work, check that:

- The Pippy is fully booted
- The USB cable supports data
- Your terminal app has permission to access the network

# Install the Pippy Software

#### Once connected via SSH, run:

```
git clone https://github.com/oaklandgit/pippy.git
cd pippy/scripts
sudo ./setup.sh
```

This script will install everything Pippy needs. You can review or run individual steps from inside the `pippy/setup/` folder if needed.
