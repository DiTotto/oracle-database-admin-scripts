alter tablespace tbs2 offline;

/* 1. At the OS level, rename the datafile */
mv data01.dbf data99.dbf
/* 2. In Oracle, rename the datafile */
alter database rename file '/disk2/prod1/data/data01.dbf' to '/disk2/prod1/data/data99.dbf';

alter tablespace tbs2 online;