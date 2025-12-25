WITH
    orders AS 
    (
        SELECT
            order_id,
            customer_id,
            store_id,
            staff_id,
            order_status,
            {{ as_date_key('order_date') }} as order_date_key,
            {{ as_date_key('required_date') }} as required_date_key,
            {{ as_date_key('shipped_date') }} as shipped_date_key
        FROM {{ ref('stg_local_bike_operational_database__orders')}}
    ),
    orders_items_agg_per_order AS 
    (
        SELECT 
            order_id,
            SUM(quantity) AS total_quantity,
            SUM(gross_amount) AS total_gross_amount,
            SUM(discount_amount) AS total_discount_amount,
            SUM(net_amount) AS total_net_amount
        FROM {{ ref('int_fct_order_item' )}} 
        GROUP BY
            order_id
    ),
    final AS 
    (
        SELECT
            o.order_id,
            o.customer_id,
            o.store_id,
            o.staff_id,
            o.order_status,
            o.order_date_key,
            o.required_date_key,
            o.shipped_date_key,
            oi.total_quantity,
            oi.total_gross_amount,
            oi.total_discount_amount,
            oi.total_net_amount
        FROM orders o
        LEFT JOIN orders_items_agg_per_order oi ON o.order_id = oi.order_id
    )
SELECT *
FROM final