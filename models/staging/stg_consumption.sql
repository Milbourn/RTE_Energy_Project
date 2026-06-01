with source as (

    select * from {{ source('generation', 'CONSUMPTION') }}

),

renamed as (

    select
        consumption_type,
        start_date                              as period_start,
        end_date                                as period_end,
        value_mw,
        convert_timezone('UTC', start_date)     as period_start_utc,
        updated_date,
        loaded_at

    from source

)

select * from renamed