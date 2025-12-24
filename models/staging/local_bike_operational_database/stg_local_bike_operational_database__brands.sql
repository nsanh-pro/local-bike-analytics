WITH
    source AS 
    (
        SELECT *
        FROM {{ source('local_bike_operational_database', 'brands' )}}
    ),
    final AS 
    (
        SELECT
            CAST(brand_id AS INTEGER) AS brand_id,
            CAST(brand_name AS STRING) AS brand_name
        FROM source
    )
SELECT *
FROM final