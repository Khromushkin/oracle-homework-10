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
prompt >>>>>>> PRODUCT_PACK_SPEC <<<<<<<<<<
@@product_pack.spc.sql
prompt >>>>>>> PRODUCT_PACK_BODY <<<<<<<<<<
@@product_pack.bdy.sql
prompt >>>>>>> TEST_PRODUCT_PACK_SPEC <<<<<<<<<<
@@test_product_pack.spc.sql
prompt >>>>>>> TEST_PRODUCT_PACK_BODY <<<<<<<<<<
@@test_product_pack.bdy.sql
prompt >>>>>>> TRIGGERS <<<<<<<<<<
@@triggers.sql

prompt >>>>>>> TESTS <<<<<<<<<<
select *
  from table(ut.run('admin.test_product_pack'));

select * from product;

