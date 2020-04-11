create or replace package test_product_pack is
  --%suite(Test product_pack)
  --%suitepath(product)

  --%test(Создание продукта с валидными параметрами API)
  procedure create_product_with_valid_params;

  --%test(Удаление продукта)
  procedure delete_existent_product;

  --%test(Удаление несуществующего продукта не приводит к ошибке)
  procedure delete_nonexistent_product;

  ----- другой функционал

  --%test(Изменение продукта не через API должно завершаться с ошибкой)
  --%throws(-20101)
  procedure change_product_without_api_leads_to_error;


  ----- вспомогательные процедуры
  function create_product return product.prd_id%type;
end;
/