WITH
    stg_staffs AS 
    (
        select *
        from {{ ref('stg_local_bike_operational_database__staffs')}}
    ),
    final AS 
    (
        SELECT
            staff.*,
            staff.first_name || ' ' || staff.last_name AS full_name,
            store.store_name,
            manager.first_name || ' ' || staff.last_name AS manager_full_name
        FROM stg_staffs staff 
        LEFT JOIN {{ ref('stg_local_bike_operational_database__stores')}} store ON staff.store_id = store.store_id
        LEFT JOIN stg_staffs manager ON staff.manager_id = manager.staff_id
    )
SELECT *
FROM final