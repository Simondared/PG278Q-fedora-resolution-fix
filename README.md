# Fix EDID per Asus ROG PG278Q su Linux

Questo progetto fornisce una soluzione per risolvere i problemi di riconoscimento del monitor **Asus ROG PG278Q** su sistemi Linux, specialmente quando si utilizza una scheda video AMD. Il problema è comune sui monitor con hardware G-Sync di prima generazione, che potrebbero non inviare correttamente i dati EDID al sistema.

## **Problema**
Il monitor potrebbe essere riconosciuto con una risoluzione non ottimale (es. 640x480) e potrebbe non funzionare correttamente dopo la ripresa dalla sospensione.

## **Soluzione**
La soluzione consiste nell'utilizzare un file EDID personalizzato per forzare il sistema a riconoscere correttamente il monitor. Questo progetto include uno script automatizzato che:
1. Copia il file EDID nella directory corretta.
2. Configura GRUB per utilizzare il file EDID.
3. Crea uno script per gestire il caricamento dell'EDID dopo la ripresa dalla sospensione.

## **Requisiti**
- Un file EDID valido per il monitor Asus ROG PG278Q (es. `PG278Q.bin`).
- Sistema operativo Linux (testato su Ubuntu).
- Scheda video AMD con driver `amdgpu`.

## **Come utilizzare**

### **Passo 1: Prepara il file EDID**
1. Ottieni il file EDID (`PG278Q.bin`) per il tuo monitor. Puoi generarlo utilizzando una scheda Nvidia o scaricarlo da una fonte affidabile.
2. Posiziona il file EDID sul Desktop.

### **Passo 2: Esegui lo script**
1. Scarica lo script `setup_edid.sh` da questo repository.
2. Rendi eseguibile lo script:
   ```bash
   chmod +x setup_edid.sh
