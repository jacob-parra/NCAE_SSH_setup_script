#!/bin/bash

KEY_SOURCE="/home/blueteam/scoringkey.pub"

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

# Make sure scoring key exists
if [ ! -f "$KEY_SOURCE" ]; then
    echo "ERROR: $KEY_SOURCE not found!"
    exit 1
fi

for USER in "${USERS[@]}"; do
    echo "Setting up $USER..."

    # Create user if it does not exist
    if ! id "$USER" &>/dev/null; then
        useradd -m -s /bin/bash "$USER"
        echo "User $USER created."
    else
        echo "User $USER already exists."
    fi

    HOME_DIR="/home/$USER"
    SSH_DIR="$HOME_DIR/.ssh"
    AUTH_KEYS="$SSH_DIR/authorized_keys"

    # Create .ssh directory
    mkdir -p "$SSH_DIR"

    # Overwrite authorized_keys with scoring key (clean & safe)
    cat "$KEY_SOURCE" > "$AUTH_KEYS"

    # Set correct ownership and permissions
    chown -R "$USER:$USER" "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    chmod 600 "$AUTH_KEYS"

    echo "SSH configured for $USER."
done

echo "All users configured successfully."
