/*
Scopo:
  Crea un nuovo utente Oracle.
Uso:
  Gestione utenti, test, o nuovi schemi applicativi.
*/
create user demo identified by 1234;

/* 
  Assegna i privilegi di base all'utente creato.
*/
grant connect, resource to demo;
grant create session to demo;

/* 
  Assegna un tablespace di default all'utente creato.
*/
alter user demo default tablespace tbs4;
alter user demo quota 10m on tbs4;