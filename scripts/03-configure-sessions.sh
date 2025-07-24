#!/bin/bash
set -e

echo "Configuring user session startup..."

PROFILE="$HOME/.bash_profile"

# Add a timestamp for testing purposes
echo "# Created by setup script on $(date)" > "$PROFILE"
echo "" >> "$PROFILE"

# Create or overwrite .bash_profile with required content
echo "# Send the HUD (wifi strength, local and public IP) to the attached OLED" >> "$PROFILE"
echo "~/pippy/scripts/hud.sh | ~/pippy/scripts/oledmsg.py &" >> "$PROFILE"
echo "" >> "$PROFILE"

echo "# Fix an issue with the Ghostty terminal that was making it suck" >> "$PROFILE"
echo "export TERM=xterm" >> "$PROFILE"

# Make sure the profile is readable
chmod 644 "$PROFILE"

# Report installation progress
echo ".bash_profile configured at $PROFILE"
