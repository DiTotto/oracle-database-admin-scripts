SELECT
    column_name,
    data_default
FROM dba_tab_columns
WHERE owner = 'nome_schema'
  AND table_name = 'nome_tabella' and( COLUMN_NAME='nome_colonna' or column_name='nome_colonna');