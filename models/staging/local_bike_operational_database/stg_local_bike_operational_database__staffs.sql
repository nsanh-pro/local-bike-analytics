with source as (

    select * from {{ source('local_bike_operational_database', 'staffs') }}

),

renamed as (

    select
        staff_id,
        first_name,
        last_name,
        email,
        phone,
        active,
        store_id,
        SAFE_CAST(
            NULLIF(manager_id, 'NULL') AS INTEGER
        ) AS manager_id

    from source

)

select * from renamed