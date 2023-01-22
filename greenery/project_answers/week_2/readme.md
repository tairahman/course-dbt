# Q1: What is our user repeat rate? 
# Repeat Rate = Users who purchased 2 or more times / users who purchased
# A1: 79.83%
with
    users_with_two_or_more_orders
as
    (
        select
            user_guid
            ,count(distinct order_guid) as order_count
        from stg_postgres_orders
        where 1=1
        group by 1
    )
select 
    (count_if(order_count>=2)/count(user_guid)) * 100
from users_with_two_or_more_orders;   

# Q2: Which orders changed from week 1 to week 2?
ORDER_IDs: 265f9aae-561a-4232-a78a-7052466e46b7,  e42ba9a9-986a-4f00-8dd2-5cf8462c74ea,  b4eec587-6bca-4b2a-b3d3-ef2db72c4a4f

select listagg(order_id, ',  ') from snapshot_orders where dbt_valid_to is not null
;
