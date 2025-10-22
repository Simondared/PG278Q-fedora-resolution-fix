# Fix EDID for Asus ROG PG278Q on Fedora Linux

This is a fork of a script that provides an easy way to resolve recognition issues for the **Asus ROG PG278Q** monitor on Linux systems, especially when using an AMD graphics card. The problem is common on first-generation G-Sync hardware monitors, which may not correctly send EDID data to the system.
I changed the original script to work on Fedora Linux. I also commented out the suspend script part, as I have not yet encountered this problem on Fedora (I am also not entirely sure how it works as I only started using Linux recently and have very little experience).

## Table of Contents

- [Problem](#problem)  
- [Solution](#solution)  
- [How to Use](#how-to-use)  
  - [Step 1: Prepare the EDID File](#step-1-prepare-the-edid-file)  
  - [Step 2: Run the Script](#step-2-run-the-script)  
  - [Step 3: Reboot](#step-3-reboot)  
- [What the Script Does](#what-the-script-does)  
- [Customization](#customization)  
- [Disclaimer](#disclaimer)

## Problem

The monitor may be detected with a suboptimal resolution which can not be changed (e.g., 640×480) and may not function correctly after resuming from suspend.

## Solution

Use a custom EDID file to force the system to recognize the monitor correctly. This project includes an automated script that:

1. Copies the EDID file into ```/usr/lib/firmware/edid/```.
2. Changes the GRUB config at ```/etc/default/grub``` to use the correct EDID file:
   - Appends ```drm.edid_firmware=DP-1:edid/PG278Q.bin video=DP-1:e``` inside the double quotes of the option named GRUB_CMDLINE_LINUX.
3. Updates the config by running.
   ```bash
   $ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
   ```

## How to Use

### Step 1: Prepare the EDID File

1. Obtain the EDID file (`PG278Q.bin`) for your monitor. You can generate it using an NVIDIA card or download it from a reliable source.  
2. Place the EDID file on your Desktop.

### Step 2: Run the Script
Run the script with:
   ```bash
   $ . setup_edid.sh
   ```

### Step 3: Reboot

Reboot your system so that GRUB loads using the new EDID file.

### **Customization**
If your monitor is connected to a port other than DP-1, edit the script and replace DP-1 with the correct port (e.g., DP-3).

### **Disclaimer**
Use this script at your own risk. The author is not responsible for any damage to your system.
