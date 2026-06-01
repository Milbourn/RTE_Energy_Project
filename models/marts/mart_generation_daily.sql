with hourly as (
    select * from {{ ref('fct_energy_hourly') }}
),

final as (
    select
        date_trunc('day', period_start)     as date_day,
        avg(nuclear_mw)                     as avg_nuclear_mw,
        avg(gas_mw)                         as avg_gas_mw,
        avg(wind_onshore_mw)                as avg_wind_onshore_mw,
        avg(wind_offshore_mw)               as avg_wind_offshore_mw,
        avg(solar_mw)                       as avg_solar_mw,
        avg(hydro_run_mw)                   as avg_hydro_run_mw,
        avg(hydro_reservoir_mw)             as avg_hydro_reservoir_mw,
        avg(biomass_mw)                     as avg_biomass_mw,
        avg(total_generation_mw)            as avg_total_generation_mw,
        avg(consumption_mw)                 as avg_consumption_mw,
        avg(price_eur_mwh)                  as avg_price_eur_mwh,
        min(price_eur_mwh)                  as min_price_eur_mwh,
        max(price_eur_mwh)                  as max_price_eur_mwh,
        avg(nuclear_pct)                    as avg_nuclear_pct,
        avg(renewables_pct)                 as avg_renewables_pct,
        count(*)                            as hour_count
    from hourly
    group by date_trunc('day', period_start)
)

select * from final
order by date_day