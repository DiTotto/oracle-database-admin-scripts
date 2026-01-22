BEGIN
    DBMS_REDACT.ADD_POLICY(
    object_schema           => 'nome_schema',
    object_name             => 'nome_tabella',
    policy_name             => 'nome_tabella_overall_nome_schema_policy',
    expression              => '1=0');
END;
/