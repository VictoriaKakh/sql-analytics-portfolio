SELECT time1 as date, orders, first_orders,new_users_orders, ROUND(first_orders::DECIMAl/orders*100,2) as first_orders_share, 
ROUND(new_users_orders::DECIMAL/orders*100,2) as new_users_orders_share
FROM (SELECT time1, orders, first_orders,new_users_orders
FROM
(SELECT creation_time::DATE AS time1, count(distinct order_id) as orders
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')
GROUP BY creation_time::DATE) as table3
INNER JOIN
(SELECT time::DATE as time2, count(user_id) as first_orders
FROM (SELECT user_id, min(time) as time
FROM (SELECT user_id, order_id, time
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')
ORDER BY user_id, time) as table2
GROUP BY user_id) as table2_1
GROUP BY time::DATE
ORDER BY time::DATE) as table4 ON table4.time2=table3.time1
INNER JOIN
(SELECT time11, sum(orderss)::INTEGER as new_users_orders
FROM (SELECT time11, table_for_3_part.user_id, orderss
FROM
(SELECT min(time::DATE) as time11, user_id
FROM user_actions
GROUP BY user_id
ORDER BY user_id) as table_for_3_part
INNER JOIN 
(SELECT time::DATE as time22, user_id, count(distinct order_id) as orderss
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')
GROUP BY time::DATE, user_id
ORDER BY time::DATE) as table100 ON table_for_3_part.time11=table100.time22 AND table_for_3_part.user_id = table100.user_id
ORDER BY time11, user_id) as table_for_3_part 100
GROUP BY time11) as tableNew ON tableNew.time11=table4.time2) as tablefinal
ORDER BY time1

