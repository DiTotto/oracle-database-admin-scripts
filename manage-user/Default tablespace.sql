/*
Scopo:
  Mostra quale tablespace è assegnato come default a ciascun utente.
Vista: DBA_USERS
Uso:
  Controllo allocazione spazio utenti e gestione tablespace.
*/
select user_id, username, default_tablespace
from dba_users;
