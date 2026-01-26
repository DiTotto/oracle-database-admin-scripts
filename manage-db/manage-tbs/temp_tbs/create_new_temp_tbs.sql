create temporary tablespace temp2 tempfile '/disk2/prod1/data/temp02.dbf' size 10m;

create temporary tablespace temp2 tempfile '/disk2/prod1/data/temp03.dbf' size 10m tablespace group te_group;