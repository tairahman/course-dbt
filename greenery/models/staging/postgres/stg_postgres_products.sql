with stc_products as (  
    select * from {{ source('postgres','products') }}
)

,   renamed_recast as ( 
        select
            product_id as product_guid
            , name as product_name
            , price as product_price
            , inventory as product_inventory_ct
        from stc_products
)

select * from renamed_recast