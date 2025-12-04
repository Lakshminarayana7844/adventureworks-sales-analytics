CREATE DATABASE adventureworks;
USE adventureworks;

SHOW TABLES;

select 'sales data 2020' as tbl, count(*) as total_rows from `sales data 2020`
union all select 'sales data 2021', count(*) from `sales data 2021`
union all select 'sales data 2022', count(*) from `sales data 2022`
union all select 'returns data', count(*) from `returns data`
union all select 'customer lookup', count(*) from `customer lookup`
union all select 'product lookup', count(*) from `product lookup`
union all select 'product subcategories lookup', count(*) from `product subcategories lookup`
union all select 'product categories lookup', count(*) from `product categories lookup`
union all select 'territory lookup', count(*) from `territory lookup`;

show columns from `sales data 2020`;	
show columns from `sales data 2021`;
show columns from `sales data 2022`;
show columns from `product lookup`;
show columns from `customer lookup`;
show columns from `returns data`;
show columns from `territory lookup`;

select * from `sales data 2020` limit 5;
select * from `product lookup` limit 5;
select * from `customer lookup` limit 5;
select * from `returns data` limit 5;
select * from `territory lookup` limit 5;


select count(*) as missing_productkey
from `sales data 2020`
where productkey is null;
select count(*) 
from `sales data 2020`
where orderdate not regexp '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

select count(*) 
from `sales data 2020`
where orderdate < '2000-01-01' or orderdate > '2030-01-01';


select count(*) 
from `sales data 2020`
where stockdate not regexp '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';


create table fact_sales like `sales data 2020`;

select * from fact_sales;



insert into fact_sales
select * from `sales data 2020`;

insert into fact_sales
select * from `sales data 2021`;

insert into fact_sales
select * from `sales data 2022`;

select * from fact_sales;


select count(*) from fact_sales;


create table dim_customer as
select 
    CustomerKey,
    Prefix,
    FirstName,
    LastName,
    BirthDate,
    MaritalStatus,
    Gender,
    EmailAddress,
    AnnualIncome,
    TotalChildren,
    EducationLevel,
    Occupation,
    HomeOwner
from `customer lookup`;
select count(*) from dim_customer;


select count(*) from `customer lookup`;


create table dim_product as
select 
    p.ProductKey,
    p.ProductSKU,
    p.ProductName,
    p.ModelName,
    p.ProductDescription,
    p.ProductColor,
    p.ProductSize,
    p.ProductStyle,
    p.ProductCost,
    p.ProductPrice,
    ps.ProductSubcategoryKey,
    pc.ProductCategoryKey
from `product lookup` p
left join `product subcategories lookup` ps
    on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
left join `product categories lookup` pc
    on ps.ProductCategoryKey = pc.ProductCategoryKey;
    
    select count(*) from dim_product;
    
    create table dim_territory as
select
  `SalesTerritoryKey`        as territory_key,
  `Region`                   as region,
  `Country`                  as country,
  `Continent`                as continent
from `territory lookup`;


select count(*) from dim_territory;

select * from dim_territory limit 10;
alter table fact_sales 
add index idx_orderdate (`OrderDate`(10));
desc fact_sales;


alter table fact_sales 
add index idx_productkey (`ProductKey`);

alter table fact_sales 
add index idx_customerkey (`CustomerKey`);

alter table fact_sales 
add index idx_territorykey (`TerritoryKey`);

create or replace view vw_net_sales as
select
  f.OrderDate as sale_date,
  f.ProductKey as product_key,
  coalesce(sum(f.OrderQuantity),0) as gross_quantity,
  coalesce(sum(r.ReturnQuantity),0) as return_quantity,
  coalesce(sum(f.OrderQuantity),0) - coalesce(sum(r.ReturnQuantity),0) as net_quantity,
  coalesce(sum(f.OrderQuantity * p.ProductPrice),0) as gross_revenue,
  coalesce(sum((f.OrderQuantity - ifnull(r.ReturnQuantity,0)) * p.ProductPrice),0) as net_revenue
from fact_sales f
left join `returns data` r
  on f.ProductKey = r.ProductKey 
  and f.OrderDate = r.ReturnDate
left join `product lookup` p
  on f.ProductKey = p.ProductKey
group by f.OrderDate, f.ProductKey;



create table agg_monthly_sales as
select
  date_format(str_to_date(f.OrderDate, '%Y-%m-%d'), '%Y-%m-01') as month_start,
  f.ProductKey as product_key,
  f.TerritoryKey as territory_key,
  sum(f.OrderQuantity * p.ProductPrice) as revenue,
  sum(f.OrderQuantity) as qty_sold
from fact_sales f
left join `product lookup` p
  on f.ProductKey = p.ProductKey
group by month_start, f.ProductKey, f.TerritoryKey;



alter table agg_monthly_sales 
add index ix_month_product (month_start, product_key);


select count(*) from fact_sales;
select count(*) from agg_monthly_sales;
select count(*) from vw_net_sales;

SHOW INDEXES FROM fact_sales;

SELECT 
    *
FROM
    information_schema.STATISTICS
WHERE
    table_schema = DATABASE()
        AND table_name = 'fact_sales';

select * from vw_net_sales;