SELECT tablespace_name,
       ROUND(SUM(bytes) / 1024 / 1024 / 1024, 2) AS size_gb
FROM dba_data_files
GROUP BY tablespace_name
ORDER BY size_gb DESC;
