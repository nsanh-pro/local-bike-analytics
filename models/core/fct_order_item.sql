WITH
    order_items AS 
    (
        SELECT 
            order_item_id,
            order_id,
            item_id,
            product_id,
            quantity,
            list_price,
            discount,
            ROUND(quantity * list_price, 2) AS gross_sales_amount,
            ROUND((quantity * list_price) * discount, 2) AS discount_amount,
            ROUND((quantity * list_price) * (1-discount), 2) AS net_sales_amount
        FROM {{ ref('stg_local_bike_operational_database__order_items' )}} 
    ),
    final AS 
    (
        SELECT
            *
        FROM order_items
    )
SELECT *
FROM final