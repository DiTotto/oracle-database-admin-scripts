BEGIN
    DBMS_REDACT.DROP_POLICY(
        object_schema => 'nome_schema',
        object_name   => 'nome_tabella',
        policy_name   => 'nome_schema_overall_nome_tabella_policy'
    );
END;
/