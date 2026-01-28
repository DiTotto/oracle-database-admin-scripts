col OBJECT_OWNER for a20
col OBJECT_NAME for a20
col COLUMN_NAME for a30
col FUNCTION_TYPE for a20
SELECT 
    OBJECT_OWNER,
    OBJECT_NAME,
    COLUMN_NAME,
    FUNCTION_TYPE  
FROM 
    REDACTION_COLUMNS 
WHERE 
    object_owner = 'nome_schema' 
    AND object_name = 'nome_tabella';


    col OBJECT_OWNER for a20
col OBJECT_NAME for a20
col COLUMN_NAME for a30
col FUNCTION_TYPE for a20
SELECT 
    OBJECT_OWNER,
    OBJECT_NAME,
    COLUMN_NAME,
    FUNCTION_TYPE  
FROM 
    REDACTION_COLUMNS 
WHERE 
    object_owner = 'DWHASL' 
    AND object_name = 'TAB_ASSISTITI_CRONICI';

