WITH
    stg_stores AS 
    (
        select *
        from {{ ref('stg_local_bike_operational_database__stores')}}
    ),
    final AS 
    (
        SELECT *
        FROM stg_stores
    )
SELECT *
FROM final