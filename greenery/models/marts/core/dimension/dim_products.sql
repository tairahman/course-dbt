{{
    config(
        materialized = 'table'
    )
}}

with 
    product_dims
as
    (
        select
            p.product_guid
            , p.product_name
            , p.product_inventory_ct
            /* show total ordered quantity, discounts and inventory flags */
            , sum(oi.order_quantity) as total_volume_ordered
            , count_if(promo_type is not null) as number_of_discounts
            , case
                when p.product_inventory_ct < total_volume_ordered
                    then true
                else false
                end as needs_more_inventory
        from {{ ref('stg_postgres_products') }} p
        left join {{ ref('stg_postgres_order_items') }} oi
            on oi.product_guid = p.product_guid
        left join {{ ref('stg_postgres_orders') }} o
            on o.order_guid = oi.order_guid        
        group by 1,2,3
    )

select * from product_dims