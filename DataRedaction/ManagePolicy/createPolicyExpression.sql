BEGIN
   DBMS_REDACT.CREATE_POLICY_EXPRESSION(
     policy_expression_name          => 'oe_redact_pol',
     expression                      => 'SYS_CONTEXT(''USERENV'',''SESSION_USER'') = ''OE'''),
     policy_expression_description   => 'Enables policy for user OE ');
END;

BEGIN
   DBMS_REDACT.CREATE_POLICY_EXPRESSION(
     policy_expression_name          => 'epidemio_str_pol',
     expression                      => 'SYS_CONTEXT(''SYS_SESSION_ROLES'',''AR_OCI_DWH_EPIDEMIO_STR'') = ''TRUE'' or SYS_CONTEXT(''SYS_SESSION_ROLES'',''AR_OCI_DWH_EPIDEMIO_BORS'') = ''TRUE''',
     policy_expression_description   => 'Enables policy for user BORSISTA ');
END;

epidemio_str_pol
SYS_CONTEXT('SYS_SESSION_ROLES','AR_OCI_DWH_EPIDEMIO_STR') = 'TRUE' or SYS_CONTEXT('SYS_SESSION_ROLES','AR_OCI_DWH_EPIDEMIO_BORS') = 'TRUE'