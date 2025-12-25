WITH
    stg_staffs AS 
    (
        select *
        from {{ ref('stg_local_bike_operational_database__staffs')}}
    ),
    final AS 
    (
        SELECT *
        FROM stg_staffs
    )
SELECT *
FROM final