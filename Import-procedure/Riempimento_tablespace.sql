SELECT
  df.tablespace_name,
  ROUND(df.total_bytes/1024/1024/1024,2) AS allocated_gb,
  ROUND(fs.free_bytes/1024/1024/1024,2)  AS free_gb,
  ROUND((df.total_bytes - fs.free_bytes)/1024/1024/1024,2) AS used_gb
FROM (
  SELECT tablespace_name, SUM(bytes) AS total_bytes
  FROM dba_data_files
  GROUP BY tablespace_name
) df
JOIN (
  SELECT tablespace_name, SUM(bytes) AS free_bytes
  FROM dba_free_space
  GROUP BY tablespace_name
) fs
ON df.tablespace_name = fs.tablespace_name
WHERE df.tablespace_name LIKE '%TSH_OSF_ARPA%'
ORDER BY df.tablespace_name;
