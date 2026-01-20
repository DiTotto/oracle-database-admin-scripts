--   Elenca tutti gli oggetti del database a cui l’utente ha accesso,  mostrando lo schema proprietario e il nome dell’oggetto.
SQL> select owner, object_name from all_objects ;

--   Elenca tutti gli oggetti del database,  mostrando lo schema proprietario e il nome dell’oggetto.
SQL> select owner, object_name from dba_objects ;

-- Calcola il numero totale di oggetti del database  visibili all’utente corrente.
SQL> select count(object_id) as sum from all_objects ;

--   Mostra quanti oggetti esistono per ciascun tipo  (TABLE, VIEW, INDEX, PACKAGE, ecc.).
SQL> select count(object_id) as sum, object_type from all_objects group by object_type order by object_type asc ;

-- Calcola il numero totale di tabelle  visibili all’utente corrente.
SQL> select count(object_id) as sum, object_type from all_objects where object_type = 'TABLE' group by object_type ;

-- Calcola il numero totale di viste  visibili all’utente corrente.
SQL> select count(object_id) as sum, object_type from all_objects where object_type = 'VIEW' group by object_type ;

-- Mostra quante tabelle sono presenti per ciascun schema visibile all’utente.
SQL> select count(object_id) as sum, owner from all_objects where object_type = 'TABLE' group by owner ;

-- Mostra quante viste sono presenti per ciascun schema visibile all’utente.
SQL> select count(object_id) as sum, owner from all_objects where object_type = 'VIEW' group by owner ;