# Q1: How many users do we have? 
# A1: 130
select 
    count (distinct user_id) 
from stg_postgress_users;

# Q2: On average, how many orders do we receive per hour? 
# A2: 7.5 (1DP) ~ 8 (0DP)
```
-- calculate number of orders created by the hour
with 
    number_of_orders_per_hour
as
    (
        select 
            date_trunc(hour,created_at_utc) as hr_order_created
            , count(order_guid) as order_count
        from stg_postgress_orders
        group by 1
    )
-- take the total number of orders and divide by hours to get the average    
select
    sum(order_count)/count(hr_order_created) as avg_number_of_orders_per_hour
from number_of_orders_per_hour
;    
```

# Q3: on average, how long does an order take from being placed to being delivered? 
# A3: 3.89 calendar days
-- i.find out how long it takes from order creation till delivery (I picked days below)
-- ii. get the number of days it takes to deliver an order
with
    time_to_deliver
as
    (
        select 
            order_guid
            , datediff(day, created_at_utc, delivered_at_utc) as days_to_deliver
        from stg_postgress_orders 
        where 1=1
            and status = 'delivered'
    )
-- iii. get the average by dividing total number of days by total order count
select
    sum(days_to_deliver)/count(order_guid) 
    as avg_days_to_deliver 
from time_to_deliver
;
# Q4: How many users have only made one purchase? Two purchases? Three+ purchases?
# A4: 1 Purchase = 25 | 2 Purchases = 28 | 3 or More Purchase = 71
-- start by categorizing each buyer according to their purchase counts
with
    buyer_counts
as
    (
    select
        user_guid        
        , case
            when count(order_guid) = 1 then 'One purchase'
            when count(order_guid) = 2 then 'Two purchases'
            when count(order_guid) >= 3 then 'Three and more purchases'
            else 'Other'
            end as purchase_count_category
    from stg_postgress_orders
    group by 1
    order by 2 desc
    )
-- group number of buyers according to their puchase group: 1, 2 and 3+    
select
    purchase_count_category
    , count(user_guid) as number_of_buyers
from buyer_counts
group by 1
order by 2 desc    
;

# Q5: On average, how many unique sessions do we have per hour? 
# A5: 16
with
    sessions_to_hour
as
    (
        select
            date_trunc(hour, created_at_utc) as session_hour
            , count (distinct session_guid) as number_of_sessions
        from stg_postgress_events
        group by 1
        order by 2 desc
    )
select 
    sum(number_of_sessions)/count(session_hour) as sessions_per_hour
from sessions_to_hour
;
