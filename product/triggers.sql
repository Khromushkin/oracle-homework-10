create or replace trigger change_product_b_iud_strict
    before insert or update or delete
    on product
begin
    product_pack.product_tr_body_restrict();
end change_product_b_iud_strict;
/