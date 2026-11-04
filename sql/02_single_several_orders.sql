SELECT date, ROUND(count_with_1_purchase::DECIMAl/total_count*100,2) as single_order_users_share,
        ROUND((1-count_with_1_purchase::DECIMAl/total_count)*100,2) as several_orders_users_share
FROM
(SELECT time::DATE as date, count(distinct user_id) as total_count
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')
GROUP BY time::DATE) as table2
INNER JOIN (SELECT time::DATE as date1, count(distinct user_id) as count_with_1_purchase
FROM (SELECT time::DATE, user_id, count(distinct order_id)
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')
GROUP BY time::DATE, user_id
HAVING count(distinct order_id)=1) as tabletemp
GROUP BY time::DATE) as table3 ON table2.date=table3.date1
ORDER BY date
