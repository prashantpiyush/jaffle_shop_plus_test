{% snapshot customer_with_subgraph_snapshot %}
{{
  config({    
    "strategy": "timestamp",
    "target_schema": "default",
    "unique_key": "customer_id",
    "updated_at": "most_recent_order"
  })
}}

WITH orders AS (

  SELECT *
  
  FROM {{ ref('stg_orders')}}

),

customers AS (

  SELECT *
  
  FROM {{ ref('stg_customers')}}

),

Subgraph_1 AS (

  WITH Subgraph_2 AS (
  
    WITH Reformat_1 AS (
    
      SELECT *
      
      FROM customers AS in0
    
    )
    
    SELECT *
    
    FROM Reformat_1
  
  )
  
  SELECT *
  
  FROM Subgraph_2

),

payments AS (

  SELECT *
  
  FROM {{ ref('stg_payments')}}

),

customer_payments AS (

  SELECT 
    orders.customer_id AS customer_id,
    amount
  
  FROM payments
  LEFT JOIN orders
     ON payments.order_id = orders.order_id

),

amount_per_customer AS (

  SELECT 
    customer_id,
    sum(amount) AS total_amount
  
  FROM customer_payments
  
  GROUP BY customer_id

),

customer_orders AS (

  SELECT 
    customer_id,
    min(order_date) AS first_order,
    max(order_date) AS most_recent_order,
    count(order_id) AS number_of_orders
  
  FROM orders
  
  GROUP BY customer_id

),

Subgraph_3 AS (

  WITH customer_report_1 AS (
  
    SELECT 
      customers.customer_id,
      customers.first_name,
      customers.last_name,
      customer_orders.first_order,
      customer_orders.most_recent_order,
      customer_orders.number_of_orders AS total_orders,
      amount_per_customer.total_amount AS customer_lifetime_value
    
    FROM Subgraph_1 AS customers
    LEFT JOIN customer_orders
       ON customers.customer_id = customer_orders.customer_id
    LEFT JOIN amount_per_customer
       ON customers.customer_id = amount_per_customer.customer_id
  
  )
  
  SELECT *
  
  FROM customer_report_1

),

final_with_order AS (

  SELECT *
  
  FROM Subgraph_3 AS customer_report
  
  ORDER BY total_orders DESC

)

SELECT *

FROM final_with_order

{% endsnapshot %}
