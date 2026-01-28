BEGIN
    DBMS_REDACT.ADD_POLICY(
    object_schema           => 'nome_schema',
    object_name             => 'nome_tabella',
    policy_name             => 'nome_tabella_overall_nome_schema_policy',
    expression              => '1=0');
END;
/

BEGIN

    DBMS_REDACT.ALTER_POLICY (
    object_schema   => 'DWHASL',
    object_name       => 'TAB_ASSISTITI_CRONICI',
    policy_name       => 'tab_ass_cronici_overall_dwhasl_policy',
    function_type     => DBMS_REDACT.FULL,
    action            => DBMS_REDACT.ADD_COLUMN,
    column_name       => 'COD_PAZIENTE');

END;