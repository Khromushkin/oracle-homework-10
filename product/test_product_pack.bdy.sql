create or replace package body test_product_pack is

    -- получить несуществующий продукт
    function get_nonexistent_product return product.prd_id%type;

    --****************** процедура create_product

    procedure create_product_with_valid_params is
        v_product_record product_pack.t_product_record := product_pack.t_product_record('name', 10.2);
        v_product_row    product%rowtype;
        v_prd_id         product.prd_id%type;
    begin
        -- дергаем API
        v_prd_id := product_pack.add_product(pi_product => v_product_record);
        -- провеям данные в таблице
        select *
        into v_product_row
        from product t
        where t.prd_id = v_prd_id;

        ut.expect(v_product_row.prd_name).to_equal(v_product_record.prd_name);
        ut.expect(v_product_row.prd_cost).to_equal(v_product_record.prd_cost);
        ut.expect(v_product_row.prd_status).to_equal(1);
    end;

    --****************** процедура delete_product

    procedure delete_existent_product is
        v_status number;
        v_prd_id product.prd_id%type;
    begin
        v_prd_id := create_product();
        product_pack.delete_product(pi_prd_id => v_prd_id);

        -- проверяем, что обновили статус
        select prd_status
        into v_status
        from product t
        where t.prd_id = v_prd_id;

        ut.expect(v_status).to_equal(0);
    end;


    procedure delete_nonexistent_product is
        v_prd_id product.prd_id%type;
    begin
        -- получаем несущетвующий кошель
        v_prd_id := get_nonexistent_product();
        -- вызываем API
        product_pack.delete_product(pi_prd_id => v_prd_id);
    end;

    ----- другой функционал

    procedure change_product_without_api_leads_to_error is
    begin
        insert into product
        (prd_id,
         prd_name,
         prd_cost,
         prd_status)
        values (prd_id_seq.nextval, 'namenamename', 100500.10, 1);
    end;


    --****************** вспомогательные процедуры

    -- создание продукта
    function create_product return product.prd_id%type is
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

        dbms_session.set_context('clientcontext', 'force_dml', 'false');

        return v_prd_id;
    exception
        when others then
            dbms_session.set_context('clientcontext', 'force_dml', 'false');
    end;

    -- получить несуществующий продукт
    function get_nonexistent_product return product.prd_id%type is
        v_prd_id product.prd_id%type;
    begin
        v_prd_id := -dbms_random.value(10000, 2000000);
        return v_prd_id;
    end;

end;
/