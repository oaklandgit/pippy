#!/bin/bash
set -e

echo "Setting up Pippy!"

./00-configure-network.sh
./01-setup-apps.sh

echo "Done!"