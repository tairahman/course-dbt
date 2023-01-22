{{
    config(
        materialized = 'table'
    )
}}

with
    fact_users
as 
    (
        select
            u.user_guid
            , a.address_state as user_state
            , iu.is_customer
            , iu.is_repeat_customer
            , iu.number_of_orders
            , iu.total_spend_minus_shipping
            , iu.total_shipping_spend
            , iu.number_of_orders_with_discounts
            , ie.add_to_carts
            , ie.checkout
            , ie.package_shipped
            , ie.page_view
            , avg(ie.session_length_in_minutes)
            , min(o.created_at_utc) as first_order_created_at_utc
            , max(o.created_at_utc) as latest_order_created_at_utc
        from {{ ref('stg_postgres_users') }} u
        left join {{ ref('stg_postgres_addresses') }} a
            on a.address_guid = u.address_guid
        left join {{ ref('int_users') }} iu
            on iu.user_guid = u.user_guid 
        left join {{ ref('int_events') }} ie
            on ie.user_guid = u.user_guid 
        left join {{ ref('stg_postgres_orders') }} o
            on o.user_guid = u.user_guid    
        group by 1,2,3,4,5,6,7,8,9,10,11,12                      
    )

select * from fact_users    