with source as (

    select * from {{ source('generation', 'PHYSICAL_FLOWS') }}

),

renamed as ( 

    select
        sender_country,
        receiver_country,
        start_date                              as period_start,
        end_date                                as period_end,
        value_mw,
        convert_timezone('UTC', start_date)     as period_start_utc,
        updated_date,
        loaded_at

    from source

)

select * from renamed