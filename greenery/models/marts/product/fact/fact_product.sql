{{
    config(
        materialized = 'table'
    )
}}

with
    product_facts
as
    (
        select
            p.product_guid
            , p.product_name
            , date_trunc(month,o.created_at_utc) as order_month
            , a.address_state as order_state
            , sum(order_quantity) as total_volume_ordered
            , sum(order_quantity * p.product_price) as total_product_spend_without_discounts
            , count_if(promo_type is not null) as number_of_discounts
        from {{ ref('stg_postgres_products') }} p
        left join {{ ref('stg_postgres_order_items') }} oi
            on oi.product_guid = p.product_guid
        left join {{ ref('stg_postgres_orders') }} o
            on o.order_guid = oi.order_guid  
        left join {{ ref('stg_postgres_addresses') }} a
            on a.address_guid = o.address_guid     
        group by 1,2,3,4               
    )

select * from product_facts