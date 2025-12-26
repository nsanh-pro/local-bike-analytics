WITH
    staff AS
    (
        SELECT
            staff_id,
            full_name AS staff_full_name,
            store_name,
            manager_full_name
        FROM {{ ref('dim_staff') }}
    ),
    monthly_orders_per_staff AS 
    (
        SELECT 
            staff_id,
            order_date.year,
            order_date.month,
            order_date.month_name,
            COUNT(1) AS total_orders,
            SUM(CASE WHEN orders.is_shipped_late THEN 1 END) AS total_late_shippings,
            SUM(orders.total_quantity) AS total_quantity,
            ROUND(SUM(orders.total_gross_sales_amount), 2) AS total_gross_sales_amount,
            ROUND(SUM(orders.total_discount_amount), 2) AS total_discount_amount,
            ROUND(SUM(orders.total_net_sales_amount), 2) AS total_net_sales_amount,
        FROM {{ ref('fct_order') }} AS orders
        LEFT JOIN {{ ref('dim_date') }} AS order_date ON orders.order_date_key = order_date.date_key
        GROUP BY 
            staff_id,
            order_date.year,
            order_date.month,
            order_date.month_name
    ),
    final AS
    (
        SELECT
            staff.staff_full_name,
            staff.store_name,
            staff.manager_full_name,
            orders.year,
            orders.month,
            orders.month_name,
            orders.total_orders,
            orders.total_late_shippings,
            orders.total_quantity,
            orders.total_gross_amount,
            orders.total_discount_amount,
            orders.total_net_amount
        FROM staff
        LEFT JOIN monthly_orders_per_staff orders ON staff.staff_id = orders.staff_id
    )
SELECT *
FROM final