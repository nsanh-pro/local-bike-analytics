{% macro as_date_key(date_expr) %}
    cast(format_date('%Y%m%d', {{ date_expr }}) as int64)
{% endmacro %}