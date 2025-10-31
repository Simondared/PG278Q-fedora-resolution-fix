#!/bin/bash

# Variables
EDID_FILE="PG278Q.bin"
EDID_SOURCE="$EDID_FILE"
EDID_TARGET="/usr/lib/firmware/edid/$EDID_FILE"
GRUB_CONFIG="/etc/default/grub"
DRM_PARAM="drm.edid_firmware=DP-1:edid/$EDID_FILE video=DP-1:e"

function get_user_YorN () {
	read -p "$*" user_input

	if [ $user_input == "y" -o $user_input == "Y" ]; then
		true
	elif [ $user_input == "n" -o $user_input == "N" ]; then
		false
	else
		echo "ERROR: User Input not valid! Please use [Y,y,N,n]."
		get_user_YorN "$*"
	fi
}

# Check that the EDID file exists on the Desktop
if [[ ! -f "$EDID_SOURCE" ]]; then
    echo "Error: EDID file not found on Desktop ($EDID_FILE)."
    return
fi

# Create the firmware directory if needed
echo "Creating /usr/lib/firmware/edid/ directory..."
sudo mkdir -p /usr/lib/firmware/edid

# Copy the EDID file into place
echo "Copying EDID file to /usr/lib/firmware/edid/..."
sudo cp "$EDID_SOURCE" "$EDID_TARGET"
sudo chmod 644 "$EDID_TARGET"

# Configure GRUB to use the custom EDID
echo "Configuring GRUB to load the EDID..."
if grep -q "$DRM_PARAM" "$GRUB_CONFIG"; then
    echo "GRUB is already configured."
else
    sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $DRM_PARAM\"|" "$GRUB_CONFIG"
    echo "GRUB configuration updated."
fi

# Update GRUB
echo "Updating GRUB configuration..."
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Create the suspend/resume hook
#echo "Creating suspend/resume hook script..."
#sudo bash -c "cat > $SUSPEND_SCRIPT << 'EOF'
#!/bin/bash
#case \"\$1\" in
#    resume|thaw)
#        echo \"$DRM_PARAM\" > /sys/module/drm_kms_helper/parameters/edid_firmware
#        ;;
#esac
#EOF"
#sudo chmod +x "$SUSPEND_SCRIPT"

# Completion message
echo "EDID setup completed successfully!"
echo "Changes will only apply after reboot!"

if get_user_YorN "Do you want to reboot right now? [Y/N]: "; then
	echo "Reboot will commence now!"
	systemctl reboot
else
	echo "Please reboot manualy later."
fi
