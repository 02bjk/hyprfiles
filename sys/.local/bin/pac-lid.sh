#! /usr/bin/env bash 


paconf='/etc/pacman.conf'

if [[ -f "$paconf" ]]; then
    sudo sed -i 's/#Color/Color/' "$paconf"
    #echo "ILoveCandy" | sudo tee -a "$paconf"
fi

###########-------------------------------


if [[ -f /etc/systemd/logind.conf ]]; then
    sudo sed -i 's/^#\?\s*HandlePowerKey=.*/HandlePowerKey=sleep/' /etc/systemd/logind.conf
    sudo sed -i 's/^#\?\s*HandleLidSwitch=.*/HandleLidSwitch=suspend/' /etc/systemd/logind.conf
    sudo sed -i 's/^#\?\s*HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
fi
