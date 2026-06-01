with source as (

    select * from {{ source('generation', 'WHOLESALE_PRICES') }}

),

renamed as (

    select
        price_area,
        start_date                              as period_start,
        end_date                                as period_end,
        price_eur_mwh,
        convert_timezone('UTC', start_date)     as period_start_utc,
        updated_date,
        loaded_at

    from source

)

select * from renamed