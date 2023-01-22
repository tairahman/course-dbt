with stc_promos as (
    select * from {{ source('postgres','promos') }}
)

,   renamed_recast as (
        select
            promo_id as promo_type
            , discount as discount_category_num
            , status as discount_status
        from stc_promos
)

select * from renamed_recast 