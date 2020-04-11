

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
select * from product