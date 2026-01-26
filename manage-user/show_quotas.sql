/* 
 Uso:
   Elenco quote tabelle per utente. 
*/
select username, tablespace_name, bytes, max_bytes from dba_ts_quotas;