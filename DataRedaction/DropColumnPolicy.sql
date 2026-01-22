BEGIN
    DBMS_REDACT.ALTER_POLICY(
        object_schema => '<nome_schema>',
        object_name   => 'TAB_ASSISTITI_CRONICI',
        policy_name   => '<nome_tabella>_overall_<nome_schema>_policy',
        action        => DBMS_REDACT.DROP_COLUMN,
        column_name   => '<nome_colonna>'
    );
END;
/