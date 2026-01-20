
/*
Scopo:
  Mostra lo stato ARCHIVELOG del database e
  le informazioni sugli archivelog correnti.
Uso:
  Verifica backup, RMAN, Data Guard.
*/

SQL> archive log list

/*
Scopo:
  Mostra il percorso della Fast Recovery Area (FRA).
Uso:
  Controllo spazio archivelog e configurazione RMAN.
*/
SQL> show parameter db_recovery_file_dest

/*
Scopo:
  Elenca le destinazioni configurate per gli archivelog
  e il loro stato (locali o remote).
Uso:
  Troubleshooting archivelog e Data Guard.
*/
SQL> select dest_name, status, destination from v$archive_dest ;