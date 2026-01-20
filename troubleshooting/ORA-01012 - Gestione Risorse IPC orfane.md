# Risoluzione ORA-01012 e Gestione Risorse IPC Orfane in Oracle Data Guard

* Data Creazione: 20 Gennaio 2026
* Ambiente: Oracle Database 11.2.0.4, Data Guard
* Piattaforma: Linux (Red Hat/Oracle Linux)
* Categoria: Problemi di Startup e Connessione IPC

## Sommario

Durante operazioni di clonazione e configurazione di un ambiente Oracle Data Guard 11.2.0.4, si è manifestato un errore ORA-01012: not logged on durante tentativi di connessione sqlplus / as sysdba. L'analisi ha rivelato la presenza di risorse IPC (Inter-Process Communication) orfane associate a un ORACLE_SID precedentemente utilizzato, non completamente pulite dal kernel del sistema operativo. 

## Sintomi e riconoscimento del problema


2.1 Comportamento Anomalo di SQL*Plus
```bash
# Comando eseguito:
export ORACLE_SID=LCMARPP
sqlplus / as sysdba
connected
SQL> show parameter name
ORA-01012: not logged on
Process ID: 0
Session ID: 0 Serial number: 0

# vs comportamento corretto:
export ORACLE_SID=LCMARPP_STB
sqlplus / as sysdba
SQL> show parameter name
# (funziona correttamente)
```

### 2.2 Output Differenziato di Connessione
Con ORACLE_SID problematico (LCMARPP): Connected. → ORA-01012

Con ORACLE_SID funzionante (LCMARPP_STB): Connected to an idle instance. → Comandi SQL funzionanti

### 2.3 Stato Processi IPC
```bash
# Output sysresv per SID problematico:
sysresv -l LCMARPP
Oracle Instance not alive for sid "LCMARPP"
# Ma segmenti IPC esistono ancora!
```

## Analisi

### 3.1 Causa Primaria: Risorse IPC Orfane
Quando un'istanza Oracle viene arrestata in modo non pulito (shutdown abort, kill -9, crash del server), i segmenti di memoria condivisa e i semafori possono rimanere allocati nel kernel anche senza processi Oracle attivi. Queste risorse vengono chiamate "orfane".

### 3.2 Meccanismo di Handshake di SQL*Plus
Quando si esegue sqlplus / as sysdba, prima di leggere l'spfile, Oracle esegue:

Lookup del segmento IPC basato su ORACLE_SID

Verifica presenza processi (PMON, SMON)

Se trova segmenti IPC senza processi: Handshake parzialmente riuscito → Connected. (falsa connessione)

Al primo comando SQL: Fallimento con ORA-01012 perché i processi reali non esistono

### 3.3 Differenza con Connessione Corretta
Con ORACLE_SID="LCMARPP_STB", i segmenti IPC sono coerenti con i processi attivi, quindi l'handshake completa correttamente e mostra Connected to an idle instance.

## 4. Risoluzione

### 4.1 Verifica Stato Attuale
```bash
# Controlla tutti i segmenti IPC Oracle
ipcs -m | grep oracle
ipcs -s | grep oracle

# Verifica specificamente per ciascun SID
sysresv -l LCMARPP
sysresv -l LCMARPP_STB

# Controlla processi reali
ps -ef | grep -E "ora_(pmon|smon|dbw)" | grep -v grep

# Controlla file lock
ls -l $ORACLE_HOME/dbs/lk*

```

### 4.2 Identificazione Risorse Orfane
Risorse sono orfane quando:
```bash
sysresv -l <SID> mostra segmenti IPC

Oracle Instance not alive for sid "<SID>"

ps -ef | grep pmon | grep <SID> NON mostra processi
```
### 4.3 Rimozione Risorse IPC Orfane
Metodo Oracle (raccomandato):

``` bash
sysresv -f -l LCMARPP
```
Metodo Manuale (se sysresv non disponibile):

```bash
# Esempio con ID dal sysresv output
ipcrm -m <shared_memory_id>
ipcrm -s <semaphore_id>
```
Rimozione file lock residui:

```bash
cd $ORACLE_HOME/dbs
rm -f lkLCMARPP sgadefLCMARPP.dbf mpool_LCMARPP
```
### 4.4 Verifica Pulizia
```bash
# Dovrebbe mostrare nessuna risorsa per SID pulito
sysresv -l LCMARPP

# Dovrebbe mostrare solo risorse per SID attivo
sysresv -l LCMARPP_STB
```
### 4.5 Avvio Istanza Pulita
```bash
export ORACLE_SID=LCMARPP
sqlplus / as sysdba
SQL> startup nomount pfile='/tmp/initLCMARPP.ora';
SQL> create spfile from pfile;
SQL> shutdown immediate;
SQL> startup;
SQL> show parameter instance_name;
```