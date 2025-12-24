with source as (

    select * from {{ source('local_bike_operational_database', 'order_items') }}

),

renamed as (

    select
        CONCAT(order_id, '_', product_id) AS order_item_id,
        order_id,
        item_id,
        product_id,
        quantity,
        list_price,
        discount
        
    from source

)

select * from renamed