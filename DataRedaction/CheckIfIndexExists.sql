 SELECT index_name, uniqueness
FROM dba_indexes
WHERE owner = 'nome_schema'
  AND table_name = 'nome_tabella';

   SELECT index_name, uniqueness
FROM dba_indexes
WHERE owner = 'DWHASL_DTS'
  AND table_name = 'FACT_CP_1';