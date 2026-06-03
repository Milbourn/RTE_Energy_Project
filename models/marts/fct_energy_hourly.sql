with generation as (
    select
        period_start,
        production_type,
        value_mw
    from {{ ref('stg_actual_generation') }}
    where production_type != 'TOTAL'
),

consumption as (
    select
        period_start,
        consumption_type,
        value_mw
    from {{ ref('stg_consumption') }}
    where consumption_type = 'REALISED'
),

prices as (
    select
        period_start,
        price_eur_mwh
    from {{ ref('stg_wholesale_prices') }}
    where price_area = 'France'
),

generation_pivoted as (
    select
        period_start,
        sum(case when production_type = 'NUCLEAR'                          then value_mw else 0 end) as nuclear_mw,
        sum(case when production_type = 'FOSSIL_GAS'                       then value_mw else 0 end) as gas_mw,
        sum(case when production_type = 'FOSSIL_HARD_COAL'                 then value_mw else 0 end) as coal_mw,
        sum(case when production_type = 'FOSSIL_OIL'                       then value_mw else 0 end) as oil_mw,
        sum(case when production_type = 'WIND_ONSHORE'                     then value_mw else 0 end) as wind_onshore_mw,
        sum(case when production_type = 'WIND_OFFSHORE'                    then value_mw else 0 end) as wind_offshore_mw,
        sum(case when production_type = 'SOLAR'                            then value_mw else 0 end) as solar_mw,
        sum(case when production_type = 'HYDRO_RUN_OF_RIVER_AND_POUNDAGE'  then value_mw else 0 end) as hydro_run_mw,
        sum(case when production_type = 'HYDRO_WATER_RESERVOIR'            then value_mw else 0 end) as hydro_reservoir_mw,
        sum(case when production_type = 'HYDRO_PUMPED_STORAGE'             then value_mw else 0 end) as hydro_pumped_mw,
        sum(case when production_type = 'BIOMASS'                          then value_mw else 0 end) as biomass_mw,
        sum(case when production_type = 'WASTE'                            then value_mw else 0 end) as waste_mw,
        sum(value_mw)                                                                                 as total_generation_mw
    from generation
    group by period_start
),

final as (
    select
        g.period_start,
        g.nuclear_mw,
        g.gas_mw,
        g.coal_mw,
        g.oil_mw,
        g.wind_onshore_mw,
        g.wind_offshore_mw,
        g.solar_mw,
        g.hydro_run_mw,
        g.hydro_reservoir_mw,
        g.hydro_pumped_mw,
        g.biomass_mw,
        g.waste_mw,
        g.total_generation_mw,
        c.value_mw                                                      as consumption_mw,
        g.total_generation_mw - coalesce(c.value_mw, 0)                as generation_surplus_mw,
        p.price_eur_mwh,
        round(g.nuclear_mw / nullif(g.total_generation_mw, 0) * 100, 2)                              as nuclear_pct,
        round((g.wind_onshore_mw + g.wind_offshore_mw + g.solar_mw)
              / nullif(g.total_generation_mw, 0) * 100, 2)                                           as renewables_pct,
        round((g.nuclear_mw + g.wind_onshore_mw + g.wind_offshore_mw
               + g.solar_mw + g.hydro_run_mw + g.hydro_reservoir_mw + g.biomass_mw)
              / nullif(g.total_generation_mw, 0) * 100, 2)                                           as low_carbon_pct
    from generation_pivoted g
    left join consumption c on g.period_start = c.period_start
    left join prices p      on g.period_start = p.period_start
)

select * from final