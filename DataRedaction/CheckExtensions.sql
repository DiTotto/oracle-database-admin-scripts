SELECT extension_name, extension, creator
FROM dba_stat_extensions
WHERE table_name = 'nome_tabella'
AND (extension LIKE '%nome_colonna%');