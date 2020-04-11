create or replace package product_pack is
    type t_product_record is record (
        prd_name product.prd_name%type,
        prd_cost product.prd_cost%type
        );

    -- Добавление продукта
    function add_product(pi_product t_product_record)
        return product.prd_id%type;

    -- Получение информации о продукте по идентификатору продукта
    function get_product(pi_prd_id product.prd_id%type)
        return product%rowtype;

    -- Обновление продукта
    function update_product(pi_prd_id product.prd_id%type, pi_product t_product_record)
        return product%rowtype;

    -- Удаление продукта
    procedure delete_product(pi_prd_id product.prd_id%type);

    -- Триггер запрещающий менять без API
    procedure product_tr_body_restrict;

end product_pack;
/
create or replace package body product_pack is

    g_is_api boolean := false; -- Происходит ли изменение через API

    -- Создание продукта
    function add_product(pi_product t_product_record)
        return product.prd_id%type is
        v_prd_id product.prd_id%type;
    begin
        savepoint before_create_product;

        g_is_api := true;

        -- вставляем запись продукта
        insert into product
        (prd_id,
         prd_name,
         prd_cost,
         prd_status)
        values (prd_id_seq.nextval, pi_product.prd_name, pi_product.prd_cost, 1) returning prd_id into v_prd_id;

        g_is_api := false;

        return v_prd_id;
    exception
        when others then
            rollback to before_create_product;
            g_is_api := false;
            raise_application_error(
                    sqlcode, sqlerrm);
    end;

    function get_product(pi_prd_id product.prd_id%type)
        return product%rowtype
        is
        v_product product%rowtype;
    begin
        select prd_id,
               prd_name,
               prd_cost,
               prd_status
        into v_product
        from product
        where prd_id = pi_prd_id and prd_status = 1;

        g_is_api := false;

        return v_product;
    end;


    -- Обновление продукта
    function update_product(pi_prd_id product.prd_id%type, pi_product t_product_record)
        return product%rowtype is
        v_product product%rowtype;
    begin
        savepoint before_update_product;

        g_is_api := true;

        -- обновляем запись продукта
        update product
        set prd_name = pi_product.prd_name,
            prd_cost = pi_product.prd_cost
        where prd_id = pi_prd_id returning
            prd_id,
            prd_name,
            prd_cost,
            prd_status
            into v_product;

        g_is_api := false;

        return v_product;
    exception
        when others then
            rollback to before_create_product;
            g_is_api := false;
            raise_application_error(
                    sqlcode, sqlerrm);
    end;

    -- удаление продукта
    procedure delete_product(pi_prd_id product.prd_id%type) is
    begin
        savepoint before_delete_product;

        g_is_api := true;

        -- обновляем запись продукта, проставляя статус "удалён"
        update product
        set prd_status = 0
        where prd_id = pi_prd_id;

        g_is_api := false;

    exception
        when others then
            rollback to before_create_product;
            g_is_api := false;
            raise_application_error(
                    sqlcode, sqlerrm);
    end;

-- Триггер запрещающий менять без API
    procedure
        product_tr_body_restrict is
    begin
        if g_is_api or
        nvl(sys_context('clientcontext', 'force_dml'), 'false') = 'true' then
            return;
        else
            raise_application_error(-20101, 'Use API, Luke');
        end if;
    end;

end;
/