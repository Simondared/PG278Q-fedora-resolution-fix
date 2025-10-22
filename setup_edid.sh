#!/bin/bash

# Variables
EDID_FILE="PG278Q.bin"
EDID_SOURCE="$HOME/Desktop/$EDID_FILE"
EDID_TARGET="/usr/lib/firmware/edid/$EDID_FILE"
GRUB_CONFIG="/etc/default/grub"
SUSPEND_SCRIPT="/etc/pm/sleep.d/99_edid_fix"
DRM_PARAM="drm.edid_firmware=DP-1:edid/$EDID_FILE"

# Check that the EDID file exists on the Desktop
if [[ ! -f "$EDID_SOURCE" ]]; then
    echo "Error: EDID file not found on Desktop ($EDID_FILE)."
    exit 1
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
    sudo sed -i "s|^GRUB_CMDLINE_LINUX=\"\(.*\)\"|GRUB_CMDLINE_LINUX=\"\1 $DRM_PARAM\"|" "$GRUB_CONFIG"
    echo "GRUB configuration updated."
fi

# Update GRUB
echo "Updating GRUB configuration..."
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Create the suspend/resume hook
echo "Creating suspend/resume hook script..."
sudo bash -c "cat > $SUSPEND_SCRIPT << 'EOF'
#!/bin/bash
case \"\$1\" in
    resume|thaw)
        echo \"$DRM_PARAM\" > /sys/module/drm_kms_helper/parameters/edid_firmware
        ;;
esac
EOF"
sudo chmod +x "$SUSPEND_SCRIPT"

# Completion message
echo "EDID setup completed successfully!"
echo "Please reboot your system to apply the changes."

exit 0
