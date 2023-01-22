{{
    config(
        materialized = 'table'
    )
}}

with
    product_page_views
as
    (
        select
            p.product_guid
            , p.product_name
            , to_date(created_at_utc) as date_viewed
            , date_trunc(month,created_at_utc) as month_viewed
            , count(page_url) as number_of_views
        from stg_postgres_events e
        left join stg_postgres_products p on p.product_guid = e.product_guid
        where 1=1 
            and event_type = 'page_view'
        group by 1,2,3,4
    )

select * from product_page_views