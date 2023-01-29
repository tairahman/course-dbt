{%- macro sum_counts(field, val) -%}

sum(case when {{field}} = '{{val}}' then 1 else 0 end)

{%- endmacro -%}