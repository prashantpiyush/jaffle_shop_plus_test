{% snapshot orders_snapshot %}
{{
  config({    
    "strategy": "timestamp",
    "target_database": "JAFFLE_SHOP",
    "target_schema": "SNAPSHOT",
    "unique_key": "order_id",
    "updated_at": "order_date"
  })
}}

WITH orders_model AS (

    SELECT *

    FROM {{ ref('orders')}}

),
    
order_details AS (
    SELECT
        status,
        order_id,
        order_date
    
    FROM orders_model
)

SELECT *

FROM order_details

{% endsnapshot %}
