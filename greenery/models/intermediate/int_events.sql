{{
  config(
    materialized='table'
  )
}}

{%- set event_types = dbt_utils.get_column_values(
    table=ref('stg_postgres_events'),
    column='event_type'
) -%}

with int_events as 
    (
        select 
            user_guid
            , session_guid
            ,{%- for event_type in event_types %}
            sum(case when event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}_count
            {%- if not loop.last %},{% endif -%}
            {% endfor %}
            , min(created_at_utc) AS first_session_event_at_utc
            , max(created_at_utc) AS last_session_event_at_utc
            , datediff(minutes, first_session_event_at_utc, last_session_event_at_utc) as session_length_in_minutes
        from {{ ref('stg_postgres_events') }}
        group by 1,2 
    )

select * from int_events