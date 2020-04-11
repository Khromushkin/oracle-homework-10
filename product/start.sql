set serveroutput on;

CREATE USER admin IDENTIFIED BY admin;
GRANT RESOURCE TO admin;
GRANT UNLIMITED TABLESPACE TO admin;

alter session set current_schema = admin;

spool qiwi.log

prompt >>>>>>> ROLLBACK <<<<<<<<<<

@@rollback.sql

prompt >>>>>>> PRODUCT <<<<<<<<<<
@@product.tbl.sql
prompt >>>>>>> PRODUCT_PACK <<<<<<<<<<
@@product_pack.pkg.sql
prompt >>>>>>> TRIGGERS <<<<<<<<<<
@@triggers.sql
