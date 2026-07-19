# RTE Energy Project

End-to-end data pipeline mapping France's electricity mix: four RTE France APIs, loaded into Snowflake, transformed with dbt, and visualised in Power BI.

## What's here

This repo holds the dbt project (transformation layer) and the portfolio write-up.

- `models/staging/` — one staging model per RTE API (generation, consumption, physical flows, wholesale prices)
- `models/marts/` — hourly and daily marts joining the staging models into analysis-ready tables
- `index.html` — the portfolio page for this project
- `dbt_project.yml` — dbt project config

The Python ETL that loads the raw RTE data into Snowflake lives outside this repo.

## Links

- Live dashboard: [Power BI](https://app.powerbi.com/view?r=eyJrIjoiMzIyOWRhMGEtNGI1MC00YmRlLWE4NjEtNjU4ZDc4MWFmNTdmIiwidCI6ImRhNmUzMDY4LWZlMzEtNDIyYS1iMDZmLWM0YjlmZGUwOTI0MSJ9)
- Portfolio page: [milbourn.github.io/RTE_Energy_Project](https://milbourn.github.io/RTE_Energy_Project/)
