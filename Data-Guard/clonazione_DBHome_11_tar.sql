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
