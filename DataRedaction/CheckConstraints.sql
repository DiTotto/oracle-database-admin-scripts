SELECT
    c.constraint_name,
    c.constraint_type,
    cc.column_name,
    c.status
FROM dba_constraints c
JOIN dba_cons_columns cc
  ON c.owner = cc.owner
 AND c.constraint_name = cc.constraint_name
WHERE c.owner = 'nome_schema'
  AND c.table_name = 'nome_tabella'
ORDER BY c.constraint_type, cc.position;