select
    line_item.order_item_key,
    line_item.part_key,
    line_item.line_number,
    orders.order_key,
    line_item.extended_price,
    orders.order_date,
    orders.cust_key,
    {{discounted_amount('line_item.extended_price', 'line_item.discounted_percentage')}} as item_discounted_amount
from 
    {{ref('stg_tpch_orders') }} as orders
join 
    {{ ref('stg_tpch_line_items') }} as line_item 
        on orders.order_key = line_item.order_key
order by 
    orders.order_date