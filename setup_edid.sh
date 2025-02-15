#!/bin/bash

# Variabili
EDID_FILE="PG278Q.bin"
EDID_SOURCE="$HOME/Desktop/$EDID_FILE"
EDID_TARGET="/usr/lib/firmware/edid/$EDID_FILE"
GRUB_CONFIG="/etc/default/grub"
SUSPEND_SCRIPT="/etc/pm/sleep.d/99_edid_fix"

# Verifica che il file EDID esista sul Desktop
if [[ ! -f "$EDID_SOURCE" ]]; then
    echo "Errore: File EDID non trovato sul Desktop ($EDID_FILE)."
    exit 1
fi

# Crea la directory per il firmware EDID
echo "Creazione della directory /usr/lib/firmware/edid/..."
sudo mkdir -p /usr/lib/firmware/edid

# Copia il file EDID nella directory corretta
echo "Copio il file EDID in /usr/lib/firmware/edid/..."
sudo cp "$EDID_SOURCE" "$EDID_TARGET"
sudo chmod 644 "$EDID_TARGET"

# Configura GRUB per utilizzare il file EDID
echo "Configuro GRUB per utilizzare il file EDID..."
if grep -q "drm.edid_firmware=DP-1:edid/$EDID_FILE" "$GRUB_CONFIG"; then
    echo "La configurazione di GRUB è già aggiornata."
else
    sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"drm.edid_firmware=DP-1:edid\/$EDID_FILE /" "$GRUB_CONFIG"
    echo "Configurazione di GRUB aggiornata."
fi

# Aggiorna GRUB
echo "Aggiorno GRUB..."
sudo update-grub

# Crea lo script per gestire la sospensione
echo "Creo lo script per la sospensione..."
sudo bash -c "cat > $SUSPEND_SCRIPT << 'EOF'
#!/bin/bash
case \"\$1\" in
    resume|thaw)
        echo \"DP-1:edid/$EDID_FILE\" > /sys/module/drm_kms_helper/parameters/edid_firmware
        ;;
esac
EOF"
sudo chmod +x "$SUSPEND_SCRIPT"

# Messaggio di completamento
echo "Configurazione completata con successo!"
echo "Riavvia il sistema per applicare le modifiche."

exit 0
