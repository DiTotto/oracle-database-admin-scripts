select * from database_properties where property_name like '%TABLESPACE%';

alter database default temporary tablespace temp1;