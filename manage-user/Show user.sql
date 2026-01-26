/*
Scopo:
  Mostra tutti gli utenti
Vista: DBA_USERS
Uso:
  Elenco utenti per controllo accessi.
*/
select user_id, username, created, account_status
from dba_users;
