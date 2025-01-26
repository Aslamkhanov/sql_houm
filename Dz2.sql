--Посчитать количество заказов за все время. 
--Смотри таблицу orders. Вывод: количество заказов.
select count(order_id) "number_of_orders"
from orders;

--Посчитать сумму денег по всем заказам за все время (учитывая скидки).
--Смотри таблицу order_details. 
--Вывод: id заказа, итоговый чек (сумма стоимостей всех  продуктов со скидкой)
select order_id, sum(unit_price * quantity * (1 - discount)) AS total_amount
from order_details
group by order_id
order by order_id;

--Показать сколько сотрудников работает в каждом городе. 
--Смотри таблицу employee. Вывод: наименование города и количество сотрудников
select city, count(employee_id)
from employees
group by city;

--Показать фио сотрудника (одна колонка) и сумму всех его заказов
select CONCAT(e.first_name, ' ', e.last_name) as full_name,
    sum(od.unit_price * od.quantity * (1 - od.discount)) as total_orders
from employees e
join orders o on e.employee_id = o.employee_id
join order_details od on o.order_id = od.order_id
group by e.employee_id, e.first_name, e.last_name;

--Показать перечень товаров от самых продаваемых до самых непродаваемых (в штуках).
-- Вывести наименование продукта и количество проданных штук.
select p.product_name, sum(od.quantity) as total_sold
from  products p
join order_details od on p.product_id = od.product_id
join orders o on od.order_id = o.order_id
group by p.product_id, p.product_name
order by total_sold desc;
