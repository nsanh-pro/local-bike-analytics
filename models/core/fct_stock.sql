WITH
    stocks AS 
    (
        SELECT
            *
        FROM {{ ref('stg_local_bike_operational_database__stocks')}}
    ),
    final AS 
    (
        SELECT
            s.store_id,
            s.product_id,
            s.quantity,
            ROUND(s.quantity * p.list_price, 2) AS stock_value
        FROM stocks s
        LEFT JOIN {{ ref('stg_local_bike_operational_database__products') }} p ON s.product_id = p.product_id
    )
SELECT *
FROM final