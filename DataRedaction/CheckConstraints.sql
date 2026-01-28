SELECT
    c.constraint_name,
    c.constraint_type,
    cc.column_name,
    c.status
FROM dba_constraints c
JOIN dba_cons_columns cc
  ON c.owner = cc.owner
 AND c.constraint_name = cc.constraint_name
WHERE c.owner = 'DWHASL'
  AND c.table_name = 'TAB_ASSISTITI_CRONICI'
ORDER BY c.constraint_type, cc.position;