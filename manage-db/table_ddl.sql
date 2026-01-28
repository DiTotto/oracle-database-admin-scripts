set long 10000
SELECT DBMS_METADATA.GET_DDL(
         'TABLE',
         'TAB_ASSISTITI_CRONICI_TEST',
         'DWHASL'
       )
FROM dual;