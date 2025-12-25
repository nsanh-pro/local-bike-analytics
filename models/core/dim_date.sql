with date_spine as (

    {{ dbt_utils.date_spine(
        datepart   = "day",
        start_date = "cast('2000-01-01' as date)",
        end_date   = "cast('2030-12-31' as date)"
    ) }}

),

final as (
    select
        -- PK in YYYYMMDD integer format (adjust for your warehouse)
        {{ as_date_key('date_day') }} as date_key,

        cast(date_day as date)                              as date_day,
        extract(year  from date_day)                        as year,
        extract(quarter from date_day)                      as quarter,
        extract(month from date_day)                        as month,
        format_date('%Y-%m', date_day)                      as year_month,
        extract(day   from date_day)                        as day_of_month,
        extract(dayofweek from date_day)                    as day_of_week,
        format_date('%A', date_day)                         as day_name,
        format_date('%B', date_day)                         as month_name,
        case when extract(dayofweek from date_day) in (1,7)
             then true else false end                       as is_weekend,
        -- add any other flags you like (fiscal, holidays, etc.)

    from date_spine
)

select * from final
