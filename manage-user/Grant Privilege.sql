/*
Scopo:
  Concede il privilegio SESSION all’utente,
  permettendogli di connettersi al database.
Uso:
  Preparazione utente per login e operazioni base.
*/
grant session to demo;

/*
  con la clausola WITH ADMIN OPTION, l'utente demo può concedere
  il privilegio SESSION ad altri utenti.
*/

grant session to demo with admin option;


/*
  Co la clausola any table l'utente demo può operare su qualsiasi tabella
*/
grant any table to demo;

/* 
  Gli object privilege invece permettono di effettuare operazioni su specifici oggetti
  come tabelle, viste, procedure, ecc.
*/

grant select, insert, update, delete on hr.employees to demo;