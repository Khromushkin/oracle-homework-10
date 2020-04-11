create table product
(
    prd_id     number              not null,
    prd_name   varchar2(2000 char) not null,
    prd_cost   number(10, 2)       not null,
    prd_status number(1)           not null
);
alter table product
    add constraint prd_id_pk primary key (prd_id);

create sequence prd_id_seq;

comment on table product is 'Список продуктов предложенных в магазине';
comment on column product.prd_id is 'id';
comment on column product.prd_name is 'Наименование';
comment on column product.prd_cost is 'Цена';
comment on column product.prd_status is 'Статус: 1 - актуален, 0 - удалён';