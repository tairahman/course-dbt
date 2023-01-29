# Note: After installing the dbt utils package we will not need to use this custom macro
# Dynamically retrieve all event types from source query
{% macro get_event_types() %}

{% set get_event_types_query %}
select distinct
event_type
from {{ ref('stg_postgres_events') }}
order by 1
{% endset %}

{% set results = run_query(get_event_types_query) %}

{% if execute %}
# Return the first column 
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}