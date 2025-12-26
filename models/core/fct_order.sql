WITH
    orders AS 
    (
        SELECT
            order_id,
            customer_id,
            store_id,
            staff_id,
            order_status,
            CASE 
                WHEN COALESCE(shipped_date, DATE(CURRENT_DATE())) <= required_date THEN FALSE
                ELSE TRUE
            END AS is_shipped_late,
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
            SUM(gross_sales_amount) AS total_gross_sales_amount,
            SUM(discount_amount) AS total_discount_amount,
            SUM(net_sales_amount) AS total_net_sales_amount
        FROM {{ ref('fct_order_item' )}} 
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
            o.is_shipped_late,
            CASE 
                WHEN o.is_shipped_late THEN o.shipped_date_key - o.required_date_key
            END AS number_of_days_late_shipping,
            oi.total_quantity,
            ROUND(oi.total_gross_sales_amount, 2) AS total_gross_sales_amount,
            ROUND(oi.total_discount_amount, 2) AS total_discount_amount,
            ROUND(oi.total_net_sales_amount, 2) AS total_net_sales_amount
        FROM orders o
        LEFT JOIN orders_items_agg_per_order oi ON o.order_id = oi.order_id
    )
SELECT *
FROM final