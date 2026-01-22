BEGIN
    DBMS_REDACT.ADD_POLICY(
    object_schema           => '<nome_schema',
    object_name             => '<nome_tabella>',
    policy_name             => '<nome_tabella>_overall_<nome_schema>_policy',
    expression              => '1=0');
END;
/