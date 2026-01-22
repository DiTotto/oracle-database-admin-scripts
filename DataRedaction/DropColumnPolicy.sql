BEGIN
    DBMS_REDACT.ALTER_POLICY(
        object_schema => 'nome_schema',
        object_name   => 'nome_tabella',
        policy_name   => 'nome_tabella_overall_nome_schema_policy',
        action        => DBMS_REDACT.DROP_COLUMN,
        column_name   => 'nome_colonna'
    );
END;
/