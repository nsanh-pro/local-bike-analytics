with source as (

    select * from {{ source('local_bike_operational_database', 'orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        order_status,
        DATE(order_date) AS order_date,
        DATE(required_date) AS required_date,
        SAFE_CAST(NULLIF(shipped_date, 'NULL') AS DATE) AS shipped_date,
        store_id,
        staff_id

    from source

)

select * from renamed