WITH 
    final AS 
    (
        SELECT
            p.product_id,
            p.product_name,
            b.brand_name,
            c.category_name,
            p.model_year,
            p.list_price
        FROM {{ ref('stg_local_bike_operational_database__products')}} p
        INNER JOIN {{ ref('stg_local_bike_operational_database__categories' )}} c ON p.category_id = c.category_id
        INNER JOIN {{ ref('stg_local_bike_operational_database__brands' )}} b ON p.brand_id = b.brand_id   
    )
SELECT *
FROM final