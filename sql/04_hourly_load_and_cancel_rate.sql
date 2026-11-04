SELECT hour1::INTEGER as hour, successful_orders, canceled_orders, ROUND(canceled_orders::DECIMAL/ total_orders,3) as cancel_rate
FROM (SELECT EXTRACT(hour FROM creation_time) as hour1, count(distinct order_id) as successful_orders
FROM orders
WHERE order_id IN (SELECT order_id FROM courier_actions WHERE action='deliver_order')
GROUP BY EXTRACT(hour FROM creation_time)
ORDER BY hour1) as table2
INNER JOIN
(SELECT EXTRACT(hour FROM creation_time) as hour2,count(distinct order_id) as canceled_orders
FROM orders
WHERE order_id IN (SELECT order_id FROM user_actions WHERE action='cancel_order')
GROUP BY  EXTRACT(hour FROM creation_time)
ORDER BY hour2) as table3 ON table2.hour1=table3.hour2
INNER JOIN (SELECT EXTRACT(hour FROM creation_time) as hour3, count(distinct order_id) as total_orders
FROM orders GROUP BY EXTRACT(hour FROM creation_time) ORDER BY hour3) as table_prom ON table_prom.hour3=table2.hour1
ORDER BY hour1
