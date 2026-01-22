col index_name for a30
col column_position for 999
col column_name for a30


SELECT
    i.index_name,
    i.uniqueness,
    ic.column_position,
    ic.column_name,
    ic.descend
FROM dba_indexes i
JOIN dba_ind_columns ic
  ON i.owner = ic.index_owner
 AND i.index_name = ic.index_name
WHERE i.owner = 'nome_schema'
  AND i.table_name = 'nome_tabella'
ORDER BY i.index_name, ic.column_position;
