WITH
    top_100_big_customer_data AS
    (
        SELECT
            f.customer_id,
            ROUND(SUM(f.total_gross_amount), 2) as total_gross_amount,
            ROUND(SUM(f.total_gross_amount), 2) as total_net_amount,
            ROUND(SUM(f.total_quantity), 2) AS total_quantity,
            COUNT(1) AS total_orders,
            MAX(order_date.date_day) AS last_order_date
        FROM {{ ref('fct_order') }} AS f
        INNER JOIN {{ ref('dim_date') }} AS order_date ON f.order_date_key = order_date.date_key
        GROUP BY
            f.customer_id
        ORDER BY total_gross_amount DESC
        LIMIT 100
    )
SELECT
    customer.full_name,
    customer.full_address,
    customer.phone,
    customer.email,
    customer.street,
    customer.city,
    customer.state,
    customer.zip_code,
    top100.*
FROM top_100_big_customer_data AS top100
INNER JOIN {{ ref('dim_customer') }} AS customer ON top100.customer_id = customer.customer_id