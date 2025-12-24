with source as (

    select * from {{ source('local_bike_operational_database', 'customers') }}

),

renamed as (

    select
        customer_id,
        first_name,
        last_name,
        phone,
        email,
        street,
        city,
        state,
        zip_code

    from source

)

select * from renamed