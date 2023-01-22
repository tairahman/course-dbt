{{
    config(
        materialized = 'table'
    )
}}

with
    order_facts
as
    (
        select
            o.order_guid
            , u.user_guid
            , u.user_full_name
            , u.user_email
            , u.user_market
            , p.discount_status
            , case
                when p.promo_type is null
                    then 'no_discounts'
                else p.promo_type
                end as order_discount_type  
            , number_of_unique_products   
            , product_names
            , order_quantity                                                 
            , o.order_cost
            , o.shipping_cost
            , o.order_total       
            , created_at_utc
            , estimated_delivery_at_utc
            , delivered_at_utc  
            , a.address_street
            , a.address_state
            , a.address_zip
            , a.address_country         
        from {{ ref('stg_postgres_orders') }} o
        left join {{ ref('dim_users') }} u
            on u.user_guid = o.user_guid
        left join {{ ref('stg_postgres_promos') }} p
            on p.promo_type = o.promo_type 
        left join {{ ref('stg_postgres_addresses') }} a
            on a.address_guid = o.address_guid  
        left join {{ ref('int_order_items') }} i
            on i.order_guid = o.order_guid           
    )

select * from order_facts
