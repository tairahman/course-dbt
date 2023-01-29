# Conversion Rate? 62.46%
# find number of orders and divide by total number of sessions
```
with
    sessions_with_orders
as 
    (
        select
            session_guid 
            ,count(distinct o.order_guid) as count_converted_sessions
        from stg_postgres_events e
        left join stg_postgres_orders o 
            on o.order_guid = e.order_guid
        group by 1
    )
select  
    sum(count_converted_sessions)/count(session_guid) as overall_conversion_rate
from sessions_with_orders 
;
```
# What is conversion rate by product
# find number of times a product was bought [1]
# find number of times a product was viewed [2]
# get conversion rate = [1]/[2]
```
with
    orders_with_order_lines
as 
    (
        select
            oi.product_guid
            ,p.product_name
            ,count(distinct o.order_guid) as num_product_buys
        from stg_postgres_orders o
        left join stg_postgres_order_items oi
            on oi.order_guid = o.order_guid
        left join stg_postgres_products p
            on p.product_guid = oi.product_guid
        group by 1,2
    )
--select * from orders_with_order_lines;    
,
    product_views
as
    (
        select
            e.product_guid
            ,p.product_name
            ,count(session_guid) as num_product_views
        from stg_postgres_events e
        left join stg_postgres_products p
            on p.product_guid = e.product_guid
        where 1=1
            and event_type = 'page_view'
        group by 1,2
    )
select
    p.product_name
    ,ol.num_product_buys
    ,pv.num_product_views
    ,sum(ol.num_product_buys)/sum(pv.num_product_views) as product_conversion_rate
from stg_postgres_products p
left join orders_with_order_lines ol
    on ol.product_guid = p.product_guid
left join product_views pv
    on pv.product_guid = p.product_guid
group by 1,2,3
order by 2 desc
;
```
# Which orders changed from week 2 to week 3?
# Orders that changed: 265f9aae-561a-4232-a78a-7052466e46b7, e42ba9a9-986a-4f00-8dd2-5cf8462c74ea, b4eec587-6bca-4b2a-b3d3-ef2db72c4a4f
```
select order_id from snapshot_orders 
where dbt_valid_to < '2023-01-29';
```