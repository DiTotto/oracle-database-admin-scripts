/*
Scopo:
  Mostra la dimensione totale allocata del database
  (somma di tutti i datafile).
Uso:
  Verifica spazio complessivo su disco.
*/
select sum(bytes)/1024/1024 size_in_mb
from dba_data_files;

/*
Scopo:
  Mostra lo spazio effettivamente usato dagli oggetti
  (tabelle, indici, segmenti).
Uso:
  Confronto tra spazio allocato e spazio utilizzato.
*/
select sum(bytes)/1024/1024 size_in_mb
from dba_segments;


/*
Scopo:
  Mostra lo spazio occupato dagli oggetti per ciascun schema.
Uso:
  Analisi consumo spazio per owner.
*/
select owner,
       sum(bytes)/1024/1024 size_mb
from dba_segments
group by owner;
