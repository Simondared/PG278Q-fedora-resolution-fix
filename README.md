# Fix EDID for Asus ROG PG278Q on Linux

This project provides a solution to resolve recognition issues for the **Asus ROG PG278Q** monitor on Linux systems, especially when using an AMD graphics card. The problem is common on first-generation G-Sync hardware monitors, which may not correctly send EDID data to the system.

## Table of Contents

- [Problem](#problem)  
- [Solution](#solution)  
- [Requirements](#requirements)  
- [How to Use](#how-to-use)  
  - [Step 1: Prepare the EDID File](#step-1-prepare-the-edid-file)  
  - [Step 2: Run the Script](#step-2-run-the-script)  
  - [Step 3: Reboot](#step-3-reboot)  
- [What the Script Does](#what-the-script-does)  
- [Customization](#customization)  
- [Disclaimer](#disclaimer)

## Problem

The monitor may be detected with a suboptimal resolution (e.g., 640×480) and may not function correctly after resuming from suspend.

## Solution

Use a custom EDID file to force the system to recognize the monitor correctly. This project includes an automated script that:

1. Copies the EDID file into the correct directory.  
2. Configures GRUB to use the EDID file.  
3. Creates a hook script to reload the EDID after resuming from suspend.

## Requirements

- A valid EDID file for the Asus ROG PG278Q monitor (e.g., `PG278Q.bin`).  
- Linux operating system (tested on Ubuntu).  
- AMD graphics card with the `amdgpu` driver.

## How to Use

### Step 1: Prepare the EDID File

1. Obtain the EDID file (`PG278Q.bin`) for your monitor. You can generate it using an NVIDIA card or download it from a reliable source.  
2. Place the EDID file on your Desktop.

### Step 2: Run the Script

1. Clone or download this repository.  
2. Make the script executable:
   ```bash
   chmod +x setup_edid.sh
   ```
3. Run the script with root privileges:
   ```bash
   chmod +x setup_edid.sh
   ```

### Step 3: Reboot

Reboot your system so that GRUB loads using the new EDID file.

### **What the Script Does**

Creates the /usr/lib/firmware/edid/ directory if it does not already exist.
Copies the EDID file (PG278Q.bin) into /usr/lib/firmware/edid/.
Updates GRUB’s configuration to use the custom EDID at boot.

### **Customization**
If your monitor is connected to a port other than DP-1, edit the script and replace DP-1 with the correct port (e.g., DP-3).

### **Disclaimer**
Use this script at your own risk. The author is not responsible for any damage to your system.
