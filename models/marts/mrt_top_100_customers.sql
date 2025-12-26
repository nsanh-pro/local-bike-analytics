WITH
    top_100_big_customer_data AS
    (
        SELECT
            f.customer_id,
            ROUND(SUM(f.total_gross_sales_amount), 2) as total_gross_sales_amount,
            ROUND(SUM(f.total_net_sales_amount), 2) as total_net_sales_amount,
            ROUND(SUM(f.total_quantity), 2) AS total_quantity,
            COUNT(1) AS total_orders,
            MAX(order_date.date_day) AS last_order_date,
            COUNT(DISTINCT f.store_id) AS total_stores_ordered
        FROM {{ ref('fct_order') }} AS f
        INNER JOIN {{ ref('dim_date') }} AS order_date ON f.order_date_key = order_date.date_key
        GROUP BY
            f.customer_id
        ORDER BY total_gross_sales_amount DESC
        LIMIT 100
    ),
    preferred_store_per_customer AS 
    (
        SELECT
            customer.customer_id,
            store.store_name AS preferred_store
        FROM top_100_big_customer_data customer 
        LEFT JOIN {{ ref('fct_order') }} AS orders ON customer.customer_id = orders.order_id
        LEFT JOIN {{ ref('dim_store') }} AS store ON orders.store_id = store.store_id
        GROUP BY
            customer.customer_id,
            store.store_name
        QUALIFY ROW_NUMBER() OVER (PARTITION BY customer.customer_id, store.store_name ORDER BY SUM(orders.total_net_sales_amount) DESC) = 1
    ),
    final AS 
    (
        SELECT
            customer.full_name,
            customer.full_address,
            customer.phone,
            customer.email,
            customer.street,
            customer.city,
            customer.state,
            customer.zip_code,
            top100.*,
            preferred_store.preferred_store
        FROM top_100_big_customer_data AS top100
        INNER JOIN {{ ref('dim_customer') }} AS customer ON top100.customer_id = customer.customer_id
        INNER JOIN preferred_store_per_customer AS preferred_store ON top100.customer_id = preferred_store.customer_id
    )
SELECT *
FROM final