/*
Scopo:
  Mostra la configurazione e le dimensioni correnti della SGA.
Uso:
  Verifica impostazioni SGA in SQL*Plus o DBeaver.
*/
show sga;


/*
Scopo:
  Mostra la dimensione in MB di ciascun componente della SGA.
Uso:
  Analisi dettagliata utilizzo memoria condivisa.
*/
select name,
       value/1024/1024 "SGA (MB)"
from v$sga;

/*
Scopo:
  Calcola la dimensione totale della SGA in MB.
Uso:
  Verifica memoria allocata complessiva per la SGA.
*/
select sum(value)/1024/1024 "TOTAL SGA (MB)"
from v$sga;
