with source as (

    select * from {{ source('generation', 'ACTUAL_GENERATION') }}

),

renamed as (

    select
        production_type,
        start_date                              as period_start,
        end_date                                as period_end,
        value_mw,
        convert_timezone('UTC', start_date)     as period_start_utc,
        inserted_at

    from source

)

select * from renamed