WITH
    stg_orders AS 
    (
        select *
        from {{ ref('stg_local_bike_operational_database__orders')}}
    ),
    final AS 
    (
        SELECT
            order_id,
            customer_id,
            store_id,
            staff_id,
            order_status,
            cast(format_date('%Y%m%d', order_date) as int64) as order_date_key,
            cast(format_date('%Y%m%d', required_date) as int64) as required_date_key,
            cast(format_date('%Y%m%d', shipped_date) as int64) as shipped_date_key
        FROM stg_orders
    )
SELECT *
FROM final