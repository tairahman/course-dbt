{{
    config(
        materialized = 'table'
    )
}}

with
    user_dims
as 
    (
        select
            u.user_guid
            , concat(user_first_name, ' ', user_last_name) as user_full_name
            , u.user_email
            , u.user_phone_number
            , concat (a.address_street, ', ', a.address_state, ', #', a.address_zip) as user_address
            , case 
                when a.address_country = 'United States'
                    then 'US'
                else 'International'
                end as user_market
            , count(distinct o.order_guid) as unique_orders_placed
            , to_date(max(delivered_at_utc)) as latest_order_delivery_date_utc
        from {{ ref('stg_postgres_users') }} u
        left join {{ ref('stg_postgres_addresses') }} a
            on u.address_guid = a.address_guid
        left join {{ ref('stg_postgres_orders') }} o
            on o.user_guid = u.user_guid
        group by 1,2,3,4,5,6
    )

select * from user_dims   
    