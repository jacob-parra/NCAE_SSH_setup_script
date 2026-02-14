#!/bin/bash

############################################################
# SSH USER SETUP SCRIPT (Ubuntu)
#
# This script:
#   - Creates required users
#   - Configures SSH key authentication
#   - Fixes home directory ownership issues
#   - Sets correct permissions required by OpenSSH
#
# RUN AS ROOT OR WITH SUDO
############################################################


###############################
# EDIT THESE IF NEEDED
###############################

# Location of scoring public key
# Change this if your key is located somewhere else
KEY_SOURCE="/home/blueteam/scoringkey.pub"

# Default shell for created users
# Change if your lab requires something different
DEFAULT_SHELL="/bin/bash"

# Base home directory path
# Change only if your system stores homes elsewhere
HOME_BASE="/home"


###############################
# USER LIST
###############################

USERS=(
camille_jenatzy
gaston_chasseloup
leon_serpollet
william_vanderbilt
henri_fournier
maurice_augieres
arthur_duray
henry_ford
louis_rigolly
pierre_caters
paul_baras
victor_hemery
fred_marriott
lydston_hornsted
kenelm_guinness
rene_thomas
ernest_eldridge
malcolm_campbell
ray_keech
john_cobb
dorothy_levitt
paula_murphy
betty_skelton
rachel_kushner
kitty_oneil
jessi_combs
andy_green
)


###############################
# VERIFY KEY EXISTS
###############################

if [ ! -f "$KEY_SOURCE" ]; then
    echo "ERROR: Public key not found at $KEY_SOURCE"
    echo "Edit KEY_SOURCE in this script if needed."
    exit 1
fi


###############################
# PROCESS USERS
###############################

for USER in "${USERS[@]}"; do
    echo "--------------------------------------"
    echo "Processing user: $USER"

    HOME_DIR="$HOME_BASE/$USER"
    SSH_DIR="$HOME_DIR/.ssh"
    AUTH_KEYS="$SSH_DIR/authorized_keys"

    ####################################
    # Create user if not exists
    ####################################
    if ! id "$USER" &>/dev/null; then
        echo "Creating user $USER"
        useradd -m -s "$DEFAULT_SHELL" "$USER"
    else
        echo "User $USER already exists"
        # Ensure correct shell (important for SSH login)
        usermod -s "$DEFAULT_SHELL" "$USER"
    fi

    ####################################
    # Ensure home directory exists
    ####################################
    mkdir -p "$HOME_DIR"

    ####################################
    # FIX HOME DIRECTORY OWNERSHIP
    # (CRITICAL FOR SSH TO WORK)
    ####################################
    chown -R "$USER:$USER" "$HOME_DIR"
    chmod 755 "$HOME_DIR"

    ####################################
    # Create .ssh directory
    ####################################
    mkdir -p "$SSH_DIR"

    ####################################
    # Copy scoring key
    # Overwrites old authorized_keys cleanly
    ####################################
    cp "$KEY_SOURCE" "$AUTH_KEYS"

    ####################################
    # Set proper SSH permissions
    ####################################
    chown -R "$USER:$USER" "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    chmod 600 "$AUTH_KEYS"

    echo "SSH configured for $USER"

done


###############################
# Restart SSH Service
###############################

echo "Restarting SSH service..."
systemctl restart ssh

echo "--------------------------------------"
echo "All users processed successfully."
echo "--------------------------------------"
