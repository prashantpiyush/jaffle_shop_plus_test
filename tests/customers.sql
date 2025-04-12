{{
  config({    
    "error_if": "<=100",
    "fail_calc": "case when count(*) > 0 then sum(n_records) else 0 end",
    "limit": 100,
    "severity": "error",
    "store_failures": true,
    "warn_if": "<=1000",
    "where": "path/to/file"
  })
}}

{% set customer_lifetime_value_threshold = 20 %}


WITH source AS (

    SELECT *

    FROM {{ ref("customers") }}

),

filtered AS (

    SELECT *

    FROM source
    
    WHERE customer_lifetime_value > {{ customer_lifetime_value_threshold }}

)

SELECT *

FROM filtered
