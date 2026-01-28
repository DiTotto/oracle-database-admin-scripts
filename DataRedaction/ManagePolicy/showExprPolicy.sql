SELECT 
    POLICY_EXPRESSION_NAME,
    EXPRESSION,
    OBJECT_OWNER,
    OBJECT_NAME,
    COLUMN_NAME
FROM REDACTION_EXPRESSIONS;


SELECT policy_expression_name,  expression,policy_expression_description,object_owner, object_name, column_name
FROM   REDACTION_EXPRESSIONS
WHERE  policy_expression_name = 'epidemio_str_pol';