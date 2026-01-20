# Rimozione Oracle Home da Inventory

* Data: 20 Gennaio 2026
* Ambiente: Oracle Database 11g/12c/18c/19c
* Piattaforma: Linux/Unix

## Sommario

Questa guida descrive la procedura supportata da Oracle per rimuovere un Oracle Home dall'inventario centrale (inventory.xml) prima della rimozione fisica delle directory. L'approccio corretto previene corruzioni dell'inventario e errori OUI-10197 in operazioni future.

Key Learning: Eseguire sempre runInstaller -detachHome prima di rm -rf della directory Oracle Home.

## Procedura

### Step 1: Identificare l'Oracle Home da Rimuovere
```bash
# Lista tutti gli Oracle Home installati
grep "HOME NAME" $INVENTORY_LOCATION/ContentsXML/inventory.xml | grep db

# Esempio output:
# <HOME NAME="OraDB18Home1" LOC="/u01/oracle/product/18c/db_1" TYPE="O" IDX="12"/>
# <HOME NAME="OraDB19Home1" LOC="/u01/oracle/product/19c/db_1" TYPE="O" IDX="13"/>
```
Prendi nota di:

NAME (es: OraDB18Home1)

LOC (es: /u01/oracle/product/18c/db_1)

### Step 2: Eseguire detachHome (CRITICO - Prima della Cancellazione)
```bash
# Usa runInstaller da un Oracle Home ATTIVO (es: 19c)
$ORACLE_HOME/oui/bin/runInstaller -silent -detachHome \
  ORACLE_HOME="/u01/oracle/product/18c/db_1" \
  ORACLE_HOME_NAME="OraDB18Home1"
```
Output atteso:

```text
Starting Oracle Universal Installer...
Checking swap space: must be greater than 500 MB.   Actual 16397 MB    Passed
The inventory pointer is located at /etc/oraInst.loc
You can find the log of this install session at:
 /u01/oracle/oraInventory/logs/DetachHome2022-10-20_07-10-38AM.log
'DETACHHOME' WAS SUCCESSFUL.
Verifica che sia stato rimosso:
```
```bash
grep "OraDB18Home1" $INVENTORY_LOCATION/ContentsXML/inventory.xml
# NON dovrebbe mostrare nulla
```
### Step 3: Rimuovere Fisicamente la Directory Oracle Home
OPPURE

#### Opzione 3a: Rimuovi la directory (se non hai bisogno di conservare dati)
Usa la directory specificata nel passo 1.

```bash
cd /u01/oracle/product
rm -rf 18c/db_1
```
Esempio di verifica:

```bash
ls -ld 18c/db_1
# ls: cannot access '18c/db_1': No such file or directory
```
#### Opzione 3b: Sposta/Rinomina la directory (se vuoi conservarla temporaneamente)
```bash
cd /u01/oracle/product
mv 18c/db_1 18c/db_1_old_$(date +%Y%m%d)
```
Step 4: Pulire Directory Residue (se detachHome le ha ricreate)
In alcuni casi, runInstaller ricrea una directory minima:

```bash
# Verifica se esiste directory 18c/ (o equivalente)
ls -l /u01/oracle/product/18c/

# Se esiste, rimuovila:
rm -rf /u01/oracle/product/18c/
```