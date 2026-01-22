col index_name for a30
col column_name for a30
SELECT index_name, column_name, column_position
FROM dba_ind_columns
WHERE table_owner = 'nome_schema'
  AND table_name = 'nome_tabella'
ORDER BY index_name, column_position;