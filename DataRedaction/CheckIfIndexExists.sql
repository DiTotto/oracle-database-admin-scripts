 SELECT index_name, uniqueness
FROM dba_indexes
WHERE owner = 'nome_schema'
  AND table_name = 'nome_tabella';