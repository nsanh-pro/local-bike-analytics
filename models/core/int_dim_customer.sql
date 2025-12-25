WITH
    stg_customers AS 
    (
        select *
        from {{ ref('stg_local_bike_operational_database__customers')}}
    ),
    final AS 
    (
        SELECT *
        FROM stg_customers
    )
SELECT *
FROM final