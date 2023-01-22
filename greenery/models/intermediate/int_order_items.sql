{{
  config(
    materialized='table'
  )
}}

with
    order_items
as 
    (
        select
            oi.order_guid
            , oi.order_quantity
            , count(distinct oi.product_guid) as number_of_unique_products
            , listagg(product_name, ', ' ) as product_names
        from {{ ref('stg_postgres_order_items') }} oi
        left join {{ ref('stg_postgres_products') }} p
            on p.product_guid = oi.product_guid
        group by 1,2            
    )
    
select * from order_items   