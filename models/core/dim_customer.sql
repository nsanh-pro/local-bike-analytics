WITH
    stg_customers AS 
    (
        select *
        from {{ ref('stg_local_bike_operational_database__customers')}}
    ),
    final AS 
    (
        SELECT
            *,
            first_name || ' ' || last_name AS full_name,
            street || ' ' || city || ' ' || state || ' ' || zip_code AS full_address
        FROM stg_customers
    )
SELECT *
FROM final