SELECT 
    object_name, 
    POLICY_NAME 
FROM 
    redaction_policies 
WHERE 
    object_owner = '<nome_schema>' 
    AND object_name = '<nome_tabella>';