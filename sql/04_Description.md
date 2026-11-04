# **Цель: оценить почасовую нагрузку на сервер: число успешных заказов, отмен и долю отмен**  
<ins>Входные данные таблицы:</ins>  orders (creation_time, order_id, product_ids),user_actions user_actions (user_id, time, action, order_id)
Логика расчёта: 
1.	Определяем статус заказа: выделяем для каждого действия час, отдельно для отменённых заказов (table3) и для успешных заказов (поэтому соединяем с таблицей orders, table2).
2.	Отдельно считаем общее число заказов (table_prom) по часам.
3.	Считаем долю отмен canceled_orders / total_orders
     
*Примечание:* исключаем заказы со статусом cancel. Успешными считаются доставленные заказы  
<ins>Выходные поля:</ins> hour, successful_orders, canceled_orders, cancel_rate
