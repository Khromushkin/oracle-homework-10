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