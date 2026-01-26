/* Check archive log mode */
archive log list;

/* Enable archive log mode */
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;

/* Disable archive log mode */
shutdown immediate;
startup mount;
alter database noarchivelog;
alter database open;

