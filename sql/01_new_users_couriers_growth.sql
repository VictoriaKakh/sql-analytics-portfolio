SELECT date,
       new_users,
       new_couriers,
       total_users,
       total_couriers,
       round((new_users*100/temp_column_users::decimal - 100), 2) as new_users_change,
       round((new_couriers*100/temp_column_cour::decimal - 100),2) as new_couriers_change,
       round(new_users*100/temp_column_users_total::decimal, 2) as total_users_growth,
       round(new_couriers*100/temp_column_cour_total::decimal,2) as total_couriers_growth
FROM   (SELECT date,
               new_users,
               total_users,
               lag(new_users) OVER() as temp_column_users,
               lag(total_users) OVER() as temp_column_users_total,
               new_couriers,
               total_couriers,
               lag(new_couriers) OVER() as temp_column_cour,
               lag(total_couriers) OVER() as temp_column_cour_total
        FROM   (SELECT day as date,
                       count_us as new_users,
                       count_courier as new_couriers,
                       (sum(count_us) OVER (ORDER BY day))::integer as total_users,
                       (sum(count_courier) OVER(ORDER BY day))::integer as total_couriers
                FROM   (SELECT day,
                               count_courier,
                               count_us
                        FROM   (SELECT day,
                                       count(courier_id) as count_courier
                                FROM   (SELECT day,
                                               courier_id
                                        FROM   (SELECT day,
                                                       courier_id,
                                                       row_number() OVER(PARTITION BY courier_id
                                                                         ORDER BY day) as number
                                                FROM   (SELECT courier_actions.time::date as day,
                                                               courier_id
                                                        FROM   courier_actions
                                                        WHERE  action = 'accept_order'
                                                        ORDER BY courier_id) as table2) as table4
                                        WHERE  number = 1
                                        ORDER BY day, courier_id) as table6
                                GROUP BY day) as table8
                            INNER JOIN (SELECT day1,
                                               count(user_id) as count_us
                                        FROM   (SELECT day1,
                                                       user_id
                                                FROM   (SELECT day1,
                                                               user_id,
                                                               row_number() OVER(PARTITION BY user_id
                                                                                 ORDER BY day1) as number1
                                                        FROM   (SELECT user_actions.time::date as day1,
                                                                       user_id
                                                                FROM   user_actions
                                                                WHERE  action = 'create_order'
                                                                ORDER BY user_id) as table3) as table5
                                                WHERE  number1 = 1
                                                ORDER BY day1, user_id) as table7
                                        GROUP BY day1) as table9
                                ON table8.day = table9.day1) as table89
                ORDER BY day) as table89new) as table89newagain
ORDER BY date

