BEGIN

    DBMS_REDACT.ALTER_POLICY (
    object_schema   => '<nome_schema>',
    object_name       => '<nome_tabella>',
    policy_name       => '<nome_tabella>_overall_<nome_schema>_policy',
    function_type     => DBMS_REDACT.FULL,
    action            => DBMS_REDACT.ADD_COLUMN,
    column_name       => '<nome_colonna>');

END;

/