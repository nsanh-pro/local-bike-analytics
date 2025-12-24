with source as (

    select * from {{ source('local_bike_operational_database', 'categories') }}

),

renamed as (

    select
        category_id,
        category_name

    from source

)

select * from renamed