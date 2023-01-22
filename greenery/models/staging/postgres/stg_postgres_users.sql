with 
    stc_users 
as (
    select * from {{ source('postgres','users') }}
    )

,   
    renamed_recast 
as  
    (
        select
            user_id as user_guid
            , first_name as user_first_name
            , last_name as user_last_name
            , email as user_email
            , phone_number as user_phone_number
            , created_at::timestampntz as created_at_utc
            , updated_at::timestampntz as updated_at_utc
            , address_id as address_guid
        from stc_users
    )

select * from renamed_recast 