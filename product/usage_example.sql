

declare
    v_product_id product.prd_id%type;
    v_product_record product_pack.t_product_record := product_pack.t_product_record('name', 10.2);
    v_product product%rowtype;
begin
    v_product_id := product_pack.add_product(v_product_record);
    dbms_output.put_line(v_product_id);
    v_product := product_pack.get_product(v_product_id);
    dbms_output.put_line(v_product.prd_name);
    v_product_record.prd_name := 'name2';
    v_product := product_pack.update_product(v_product_id, v_product_record);
    v_product := product_pack.get_product(v_product_id);
    dbms_output.put_line(v_product.prd_name);
    product_pack.delete_product(v_product_id);
    commit;
end;
select * from product;

declare
    v_product_id product.prd_id%type;
    v_product_record product_pack.t_product_record := product_pack.t_product_record('name', 10.2);
    v_product product%rowtype;
begin
    v_product_id := create_product();
    dbms_output.put_line(v_product_id);
end;
select * from product;



create or replace function create_product return product.prd_id%type is
        v_prd_id product.prd_id%type;
    begin
        dbms_session.set_context('clientcontext', 'force_dml', 'true');

        v_prd_id := prd_id_seq.nextval;

        insert into product
        (prd_id,
         prd_name,
         prd_cost,
         prd_status)
        values (v_prd_id, 'namenamename', 100500.10, 1);

--         dbms_session.set_context('clientcontext', 'force_dml', 'false');

        return v_prd_id;
    exception
        when others then
            dbms_session.set_context('clientcontext', 'force_dml', 'false');
    end;