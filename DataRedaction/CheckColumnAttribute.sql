col owner for a20
col column_name for a30
col data_type for A10
col data_length for 9999
col nullable for a5
col hidden_column for a5
col virtual_column for a5
col data_default for a40
SELECT 
    owner,
	column_name,
    data_type,
    data_length,
    nullable,
    hidden_column,
    virtual_column,
    data_default
FROM dba_tab_cols
WHERE table_name = '<nome_tabella>'
AND column_name IN ('<nome_colonna>');