/*
Scopo:
  Mostra tutti gli utenti
Vista: DBA_USERS
Uso:
  Elenco utenti per controllo accessi.
*/
select user_id, username, created, account_status
from dba_users;

/* 
  Elenco utenti esclusi quelli di sistema per le versioni di oracle antecedenti alla ersione 12c
*/
select distinct tab.owner
from dba_tables tab
where tab.owner not in ('ANONYMOUS','CTXSYS','DBSNMP','EXFSYS',
 'LBACSYS', 'MDSYS','MGMT_VIEW','OLAPSYS','OWBSYS','ORDPLUGINS',
 'ORDSYS','OUTLN', 'SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM',
 'TSMSYS','WK_TEST','WKSYS', 'WKPROXY','WMSYS','XDB','APEX_040000',
 'APEX_PUBLIC_USER','DIP', 'FLOWS_30000','FLOWS_FILES','MDDATA',
 'ORACLE_OCM','SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR',
 'XS$NULL','PUBLIC');


/* 
  Elenco utenti esclusi quelli di sistema per le versioni di oracle successive alla versione 12c
*/
select distinct tab.owner
from dba_tables tab
where tab.owner in 
(select username from all_users where oracle_maintained = 'N');
