with
    user_aggs
as
    (
        select
            u.user_guid
            , count(order_guid) as number_of_orders
            , sum(order_cost) as total_spend_minus_shipping
            , sum(shipping_cost) as total_shipping_spend
            , count_if(promo_type is not null) as number_of_orders_with_discounts
            , case 
                when count(order_guid) > 0
                    then true
                else false
                end as is_customer
            , case
                when count(order_guid) >= 2
                    then true
                else false
                end as is_repeat_customer
        from {{ ref('stg_postgres_users') }} u
        left join {{ ref('stg_postgres_orders') }} o
            on o.user_guid = u.user_guid
        group by 1                      
    )

select * from user_aggs     