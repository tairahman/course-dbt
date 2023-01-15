with src_addresses as (
    select * from {{ source('postgres','addresses') }}
)

,   renamed_recast as (
        select
            address_id as address_guid
            , address as address_street
            , zipcode as address_zip
            , state as address_state
            , country as address_country
        from src_addresses
)   

select * from renamed_recast 