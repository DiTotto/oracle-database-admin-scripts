#####################################
####### Clonazione DB HOME 11 #######
#####################################

/* 
 * NROP = NOME DB SORGENTE
 * NROP_STB = NOME DB DESTINAZIONE
 * 
 */

/* sulla macchina sorgente, v1dbi002858, spostarsi in: */
cd /ora11s/app/oracle/product/

/* Verifica spazio disponibile */
df -h /staging/NROP

/* 
 * Stima dimensione ORACLE_HOME 
 */

du -sh $ORACLE_HOME -> 5GB

tar cvfzp /staging/NROP/NROP_OH_112.tgz /ora11s/app/oracle/product/11.2

cd /staging/NROP

scp NROP_OH_112.tgz oracle@<ip_destinazione>:/oracles11/app/oracle/product

/*
 * Sulla destinazione:
 */

mkdir -p /oracles11/app/oracle/product

time tar xvfzp NROP_OH_112.tgz

/* 
 * verifica estrazione
 */

ls -las /oracles11/app/oracle/product/11.2

env |more

unset CLASSPATH LD_LIBRARY_PATH
export ORACLE_BASE=/oracles11/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2
export PATH=/usr/sbin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$ORACLE_HOME/bin
export ORACLE_SID=NROP_STB

/oracles11/app/oracle/product/11.2/perl/bin/perl /oracles11/app/oracle/product/11.2/clone/bin/clone.pl ORACLE_BASE=/oracles11/app/oracle -invPtrLoc /etc/oraInst.loc ORACLE_HOME=/oracles11/app/oracle/product/11.2 OSDBA_GROUP=oinstall ORACLE_HOME_NAME=OraDB11Home1


cd /oracles/oraInventory/ContentsXML/
cat inventory.xml -> controllare che sia stata registrata la home_name nuova

#####################################
####### Aggancio Data Guard #######
#####################################

############## MACCHINA SORGENTE ############ 

/* Controllare che sia in archive mode: */
archive log list;

select force_logging from v$database;
-> se non è in force logging -> alter database force logging;

/* - Vanno ora aggiunti i file di standby: */

/* Verificare la dimensione dei logfile dalla v$logfile e dalla v$logfile_standby */

set lin 132 pages 2000 
col status for a16
select GROUP#,THREAD#,BYTES/1024/1024 MB,STATUS ,MEMBERS
from v$log order by 2,1;

/* Lanciare lo script ricordandosi di adattare poi la dimensione dei logfile: 
 * 
 * La dimensione da dare ai nuovi logfile di standby, deve essere uguale alla dimensione dei logfile gia esistenti.
 * 
 * Per il numero di standby logfile da creare, questi devono essere tanti quanti sono i logfile già presenti, più uno.
 * 
 */

select 'alter database add standby logfile  group 50 '||MEMBER ||''' size 512M;'from v$logfile;
oppure 
set pages 200
col member format a200
select 'ALTER DATABASE ADD STANDBY LOGFILE (''' || member || ''') SIZE 512M;' as cmd
from v$logfile;


alter database add standby logfile  group 50 '/oradata/NROP/system/redo50.log' size 512M;
alter database add standby logfile  group 51 '/oradata/NROP/system/redo51.log' size 512M;
alter database add standby logfile  group 52 '/oradata/NROP/system/redo52.log' size 512M;
alter database add standby logfile  group 53 '/oradata/NROP/system/redo53.log' size 512M;


/* Controlla poi con */
select GROUP#,THREAD#,BYTES/1024/1024 MB,STATUS from v$standby_log order by 2,1;

########### MACCHINA STANDBY ##########

Controllare che sotto $ORACLE_HOME/dbs ci sia già l'spfileCLMARPP che si sarebbe dovuto portare dentro con il tar

create pfile from spfile;

-> è necessario ora modificare l'init
##Rinomina: mv initNROP.ora initNROP_STB.ora
vi initNROP.ora

- accertarsi che db_name sia NROP (non deve cambiare dal primario)
- cancellare le prime righe dinamiche che iniziano per NROP
- aggiungere una riga: *.db_unique_name='NROP_STB'
- modificare local_listener: *.local_listener='LISTENER_NROP_STB'
##- stare attento a tutti gli /oradata/NROP che devono cambiare in /oradata/NROP_STB






Controllare che siano presenti i path /oradata/NROP/ siano presenti i admin, system e dati e dentro admin ci sia adump


Sul primario, fare un check su dove sono i datafile, quindi:
set pages 999
select name from v$datafile order by name; 

Dopo aver finito la configurazione del pfile, ricreiamo lo spfile:
create spfile from pfile='/oracles11/app/oracle/product/11.2/dbs/initNROP_STB.ora';
create spfile from pfile;

controlla lo spfile generato:
strings $ORACLE_HOME/dbs/spfileNROP_STB.ora

Configurazione di rete
############### standby###############:
lsnrctl status listener
lsnrctl stop listener

listener.ora:

SID_LIST_NROP_STB =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = NROP)
      (ORACLE_HOME = /oracles11/app/oracle/product/11.2)
      (SID_NAME = NROP)
    )
  )


NROP_STB =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = v1dbs020011)(PORT = 1742))
    )
  )
  

ADR_BASE_NROP = /oracles11/app/oracle

Testa il listener
lsnrctl stop listener NROP_STB
lsnrctl start listener NROP_STB


############### standby###############
vi tnsnames.ora
##################parte standby ###################
################ per il db locale ################
NROP_STB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = v1dbs020011)(PORT = 1742))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = NROP)
    )
  )

LISTENER_NROP_STB=
(ADDRESS_LIST =
    (ADDRESS = (PROTOCOL = TCP)(HOST = v1dbs020011)(PORT = 1742))
  )

############# parte standby ##############
############ per il db remoto ############
NROP =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 10.219.141.49)(PORT = 1742))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = NROP)
    )
  )
  
RMAN =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.219.141.57)(PORT = 1526))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = RMAN)
    )
)


###################PRIMARIO##################

vi tnsnames.ora
aggiungere la seguente parte:
NROP_STB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = v1dbs020011)(PORT = 1742))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = NROP)
    )
  )


Facciamo ora lo start del listener dello standby:
lsnrctl start NROP_STB
tnsping NROP e tnsping NROP_STB


startup nomount
show parameter name
se non partito con l'init corretto, usare:
startup nomount pfile=/oracles11/app/oracle/product/11.2/dbs/initNROP_STB.ora

############### Sul primario ###############:

Controllare il parametro db_recovery_file_dest che sia settato, altrimenti il database andra in errore. Se non lo fosse: 
alter system set db_recovery_file_dest_size=50G scope=both;

alter system set db_recovery_file_dest='/oradata/NROP/arch' scope=both;

// con questa riga, stiamo dicendo al database che deve archiviare gli archivelog della destinazione 1, nella fast recvoery area, ovvero nel path configurato in db_recovery_file_dest. Gli diciamo poi che deve archiviare tutti i logfile, quindi sia quelli online che quelli standby, e lo deve fare quando è in qualsiasi ruolo, quindi sia quando è in ruolo primario sia quando è in ruolo di standby. 

alter system set log_archive_dest_1='location=use_db_recovery_file_dest valid_for=(all_logfiles,all_roles) db_unique_name=NROP' scope=both;

// con questa configurazione invece gli si dice di far parte di una configurazione data guard composta dai due database specificati. 
alter system set log_archive_config='DG_CONFIG=(NROP,NROP_STB)' scope=both;

// con questa invece viene detto al database, che se si accorge che mancano degli archivelog, devono essere richiesti al nodo specificato
alter system set fal_server='NROP_STB' scope=both; 

############### Standby #################:
// impostiamo la grandezza della recovery file dest, ovvero della FRA
alter system set db_recovery_file_dest_size=50G scope=both;

alter system set db_recovery_file_dest='/oradata/NROP/arch' scope=both;

// anche in questo caso, gli viene specificato che deve utilizzare la db_recovery_file_dest per gli archivelog, 
alter system set log_archive_dest_1='location=use_db_recovery_file_dest valid_for=(all_logfiles,all_roles) db_unique_name=NROP_STB' scope=both;

alter system set log_archive_config='DG_CONFIG=(NROP_STB,NROP)' scope=both;

alter system set fal_server='NROP' scope=both; 

Su entrambi:
 
alter system set standby_file_management=auto scope=both; 
alter system set standby_file_management=auto scope=both;

Oss: se ti viene il dubbio, il nome del password file, deve essere senza _STB. Se per caso ti accorgi che connettendoti con @NROP_STB non ti funziona la password di sys, allora c'è qualcosa di sbagliato nel listener.

Verifico su entrambi i nodi la connettività :
 
sqlplus sys@NROP as sysdba   sys11NROP  
select host_name from v$instance;
show parameter name;
sqlplus sys@NROP_STB as sysdba
select host_name from v$instance;      
show parameter name;

Sullo standby:

alter system set db_file_name_convert='/oradata/NROP/dati/','/oradata/NROP/dati/','/oradata/NROP/system/','/oradata/NROP/system/','/oradata/NROP/cold/','/oradata/NROP/dati/','/oradata/NROP/','/oradata/NROP/dati/' scope=spfile;

alter system set db_file_name_convert='/oradata/NROP/dati/cold/','/oradata/NROP/dati/','/oradata/NROP/dati/','/oradata/NROP/dati/','/oradata/NROP/system/','/oradata/NROP/system/','/oradata/NROP/','/oradata/NROP/dati/' scope=spfile;

Riavvia l'istanza perche senno non si prende le modifiche del db_file_name_convert


Sullo standby:


connect auxiliary sys/sys11NROP@NROP_STB
connect target sys/sys11NROP@NROP
run{
ALLOCATE AUXILIARY CHANNEL A01 TYPE DISK;
ALLOCATE AUXILIARY CHANNEL A02 TYPE DISK;
ALLOCATE AUXILIARY CHANNEL A03 TYPE DISK;
ALLOCATE CHANNEL C01 TYPE DISK;
ALLOCATE CHANNEL C02 TYPE DISK;
ALLOCATE CHANNEL C03 TYPE DISK;
DUPLICATE TARGET DATABASE 
FOR STANDBY
FROM ACTIVE DATABASE
NOFILENAMECHECK;
RELEASE CHANNEL A01;
RELEASE CHANNEL A02;
RELEASE CHANNEL A03;
RELEASE CHANNEL C01;
RELEASE CHANNEL C02;
RELEASE CHANNEL C03;
}

Primario:
alter system set log_archive_dest_2='SERVICE=NROP_STB NOAFFIRM ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=NROP_STB' scope=both;

standby:
alter system set log_archive_dest_2='SERVICE=NROP NOAFFIRM ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=NROP' scope=both;

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

select process,sequence#,status from v$managed_standby;

Mettere ora sul primario la policy per non cancellare gli archive
rman target /
CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;

controllare la crontab tramite crontab -l e controllare che ci sia la delete per questo database. Copiare l'sh che si trova sotto /home/oracle/SCHED, copiare uno gia esistente e cambiare sid e log file. 


cd /oradata/NROP
cd system 
rm *
cd ../dati
rm *



Per vedere alert:
cd /oradata/NROP/admin/diag/
oppure
cd $ORACLE_BASE/diag/rdbms/NROP




Oss: nel caso in cui l'associazione data guard riesce correttamente, ma il processo MRP0 sullo standby, rimane in attesa di una sequence di un log in particolare, antecedente alla attuale sequence di redo con cui il db sta lavorando, significa che lo standby sta aspettando di ricevere e applicare quella sequence, prima di poter applicare tutte le altre che nel frattempo sta ricevendo dal primario. Il problema quindi non sta nella comunicazione tra i  due, ma sta nel fatto che lo standby sta aspettando per un file che il primario dovrebbe mandargli, ma che non gli sta mandando. è usccesso che il primario non riesce a mandarlo perche proprio durante il processo di associazione data guard, sul primario sono stati eliminati gli archive, e perchio il primario non ha piu fisicamente il file che lo standby sta aspettando di ricevere. Per questo motivo, per risolvere, è necessario andare a rigenerare il log a partire dagli archive del db presenti, con un comando simile al seguente:

run {
allocate channel ch1 type 'sbt_tape' 
PARMS="SBT_LIBRARY=/commvault/commvault/Base/libobk.so , BLKSIZE=1048576 ENV=(CV_mmsApiVsn=2,ThreadCommandLine= -vm Instance001)"
TRACE 0;
restore archivelog from sequence 102116 thread 2;
}

Con questo, il primario tornerà ad avere fisicamente il file di log chem anca allo standby, potra inviarglielo e questo potrà finalmenteiniziare ad applicare i redolog e sincronizzarsi correttamente con il primario. 



Controlli utili:
-- conferma name/unique
select name, db_unique_name from v$database;

-- online datafiles
select file#,name from v$datafile order by name;

-- online redo log info
select group#,thread#,bytes/1024/1024 MB,status from v$log order by 2,1;

-- standby log
select group#,thread#,bytes/1024/1024 MB,status from v$standby_log order by 2,1;

-- archivelog shipping
select sequence#,archived,applied,first_time from v$archived_log where dest_id is not null order by sequence# desc;
