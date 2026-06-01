with flows as (
    select * from {{ ref('stg_physical_flows') }}
),

daily as (
    select
        date_trunc('day', period_start)     as date_day,
        sender_country,
        receiver_country,
        sum(value_mw)                       as total_mw,
        avg(value_mw)                       as avg_mw,
        count(*)                            as hour_count
    from flows
    group by
        date_trunc('day', period_start),
        sender_country,
        receiver_country
),

final as (
    select
        date_day,
        sender_country,
        receiver_country,
        total_mw,
        avg_mw,
        hour_count,
        case
            when sender_country = 'France' then receiver_country
            when receiver_country = 'France' then sender_country
        end                                 as partner_country,
        case
            when sender_country = 'France' then 'EXPORT'
            when receiver_country = 'France' then 'IMPORT'
        end                                 as flow_direction
    from daily
    where sender_country = 'France'
       or receiver_country = 'France'
)

select * from final
order by date_day, partner_country