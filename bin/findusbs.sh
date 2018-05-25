#!/bin/bash

function is_usb_disk()
{
        device=$1
        is_usb_attached=$(udevadm info --query=property --path="/sys/block/$device" | grep -i "^ID_BUS=usb$")
        is_disk=$(udevadm info --query=property --path="/sys/block/$device" | grep -i "^ID_TYPE=disk$")
        if [[ -n $is_usb_attached && -n $is_disk ]]; then
                return 0
        else
                return 1
        fi
}

for block_device in $(ls /sys/block); do
        is_usb_disk $block_device
        if [[ $? -eq 0 ]]; then
                serial=$(udevadm info --query=property --path="/sys/block/$block_device" | grep "^ID_SERIAL=" | cut -d "=" -f 2)
                echo "/dev/$block_device ($serial) is an USB disk."
        fi
done
