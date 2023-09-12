-- How many products have a price greater than 30?
select count(*) from products
where unit_price>30;

-- Lower the name of the products completely and list them in reverse order of price.
select LOWER(product_name) from products
order by unit_price desc;

-- Print the names and surnames of the employees side by side 
select * from employees
order by first_name, last_name;

-- How many suppliers do I have with a NULL Region field?
select count(*) from suppliers
where region is null; 

-- How many suppliers do I have where the Region field is not NULL?
select count(*) from suppliers
where region is not null; 

-- Put TR to the left of all product names and enlarge and print on the screen.
select CONCAT('TR', ' ', product_name) as product_name from products
order by upper(product_name);

-- Add TR to the beginning of the name of products with a price less than 20.
update products
set product_name = CONCAT('TR', ' ', product_name)
where unit_price<20;

--Write a query to get the most expensive product list ( `ProductName` , `UnitPrice`).
select product_name, unit_price from products
where unit_price = (select max(unit_price) from products);

--Write a query to get the Product list ( `ProductName` , `UnitPrice`) of the 10 most expensive products.
select product_name, unit_price from products
order by unit_price desc
limit 10;

--Write a query to get the list of Products ( `ProductName` , `UnitPrice`) above the average price of the products.
select product_name, unit_price from products
WHERE unit_price > (SELECT AVG(unit_price) FROM products);

--How much is the amount obtained when the products in stock are sold.
SELECT SUM(unit_price * units_in_stock) AS TotalRevenue
FROM Products
WHERE units_in_stock > 0;

--Write a query to get the counts of Existing and Discontinued products.
SELECT
  SUM(CASE WHEN discontinued = 1 THEN 1 ELSE 0 END) AS AvailableProducts,
  SUM(CASE WHEN discontinued = 0 THEN 1 ELSE 0 END) AS DiscontinuedProducts
FROM Products;

--Write a query to get the products with their category names.
SELECT products.product_name, categories.category_name
FROM products
JOIN categories ON products.category_id = categories.category_id;

--Write a query to get the price average for products by category.
SELECT categories.category_name, AVG(products.unit_price) AS price_average
FROM products 
JOIN categories ON products.category_id = categories.category_id
GROUP BY categories.category_name;

--What is the name, price and category of my most expensive product?
select products.product_name, products.unit_price, categories.category_name from products
JOIN categories ON products.category_id = categories.category_id
where products.product_id = (
	select product_id from products 
	group by product_id 
	order by products.unit_price desc LIMIT 1
);

--Write a query to get the suppliers name and contact number (`ProductID`, `ProductName`, `CompanyName`, `Phone`) along with the product list of out-of-stock items.
select products.units_in_stock, products.product_id, products.product_name, suppliers.company_name, suppliers.phone from products
join suppliers on products.supplier_id = suppliers.supplier_id
where products.units_in_stock = 0;

--The address of my orders in March 1998, the name of the employee who received the order, the surname of the employee.
select orders.order_date, orders.ship_address, employees.first_name, employees.last_name from orders
join employees on orders.employee_id = employees.employee_id
where (orders.order_date >= '1998-03-01' and orders.order_date<= '1998-03-31');

--How many orders do I have in February 1997?
select count(*) as order_count from orders
where (orders.order_date >= '1997-02-01' and orders.order_date<= '1997-02-28');

--How many orders did I have from London in 1998?
select count(*) as order_count from orders
where (ship_city = 'London' and orders.order_date >= '1998-01-01' and orders.order_date<= '1998-12-31');

--Contactname and phone number of my customers who ordered in 1997
select orders.order_date, customers.contact_name, customers.phone from customers
join orders on orders.customer_id = customers.customer_id
where (orders.order_date >= '1997-01-01' and orders.order_date<= '1997-12-31');

--My orders with shipping fee over 40
select * from orders
where freight > 40;

-- City, customer's name for my orders with a shipping fee of 40 or more
select freight, ship_city, ship_name from orders
where freight >= 40;

--Date, city, employee name and surname (name and surname will be combined and capitalized),
select orders.order_date, orders.ship_city, CONCAT(upper(employees.first_name),' ', upper(employees.last_name)) as Name from orders
join employees on orders.employee_id = employees.employee_id
where (orders.order_date >= '1997-01-01' and orders.order_date<= '1997-12-31');

--Contactname and phone numbers of customers who ordered in 1997 (phone format should be like 2223322)
select contact_name, SUBSTRING(phone, 1, 3) || '-' || SUBSTRING(phone, 4, 4) AS formatted_phone from customers
join orders on orders.customer_id = customers.customer_id
where (orders.order_date >= '1997-01-01' and orders.order_date<= '1997-12-31');

-- Order date, customer contact name, employee name, employee surname.
select orders.order_date, customers.contact_name, CONCAT(upper(employees.first_name),' ', upper(employees.last_name)) as employee_name
from orders
join employees on orders.employee_id = employees.employee_id
join customers on orders.customer_id = customers.customer_id
order by orders.order_date;

--My delayed orders?
select required_date, shipped_date from orders
order by shipped_date > required_date;

--The date of my delayed orders, the name of the customer
select orders.order_date, customers.company_name from orders
join customers on orders.customer_id = customers.customer_id
order by shipped_date > required_date;

--The name of the products sold in the order number 10248, the name of the category, the number
select products.product_name, categories.category_name, order_details.quantity from products
join categories on categories.category_id = products.category_id
join order_details on order_details.product_id = products.product_id
where order_details.order_id = '10248';

--Name of products of order 10248, name of supplier
select products.product_name, suppliers.company_name, order_details.order_id from products
join suppliers on suppliers.supplier_id = products.supplier_id
join order_details on order_details.product_id = products.product_id
where order_details.order_id = '10248';

--Name and number of products sold by the employee with ID number 3 in 1997
select employees.employee_id, products.product_name, order_details.quantity
from employees
join orders on orders.employee_id = employees.employee_id
join order_details on orders.order_id = order_details.order_id
join products on order_details.product_id = products.product_id
where employees.employee_id = '3' and orders.order_date >= '1997-01-01' and orders.order_date<= '1997-12-31';

--ID, Name and Surname of my top sales employee once in 1997
SELECT employees.employee_id, employees.first_name, employees.last_name, order_details.quantity
FROM employees 
JOIN orders ON orders.employee_id = employees.employee_id 
JOIN order_details ON orders.order_id = order_details.order_id
where (orders.order_date >= '1997-01-01' and orders.order_date <= '1997-12-31')
order by order_details.quantity desc limit 1;

--ID, Name and Surname of my employee with the highest sales in 1997 

SELECT employees.employee_id, employees.first_name, employees.last_name
FROM employees 
JOIN orders ON orders.employee_id = employees.employee_id 
JOIN (select employee_id, sum(order_details.quantity) as total_quantity
	 from orders
	 join order_details on orders.order_id = order_details.order_id
	 where (orders.order_date >= '1997-01-01' and orders.order_date <= '1997-12-31')
	 group by employee_id 
	 ) t on employees.employee_id = t.employee_id  

where t.total_quantity = (
 select max(total_quantity)
	from (
	select orders.employee_id, sum(order_details.quantity) as total_quantity from orders
		join order_details on orders.order_id = order_details.order_id
		where (orders.order_date >= '1997-01-01' and orders.order_date <= '1997-12-31')
	    group by employee_id
	) as max_quantity
) limit 1; 

--What is the name, price and category of my most expensive product?
select products.product_name, products.unit_price, categories.category_name from products
join categories on products.category_id = categories.category_id
order by products.unit_price desc limit 1;

--Name, surname, order date, order ID. Sort by order date
select employees.first_name, employees.last_name, orders.order_date, orders.order_id from employees
join  orders on orders.employee_id = employees.employee_id
order by orders.order_date;

--What is the average price and orderid of my LAST 5 orders?
select avg(order_details.unit_price) as average_price, orders.order_id
from orders
join order_details on orders.order_id = order_details.order_id
where orders.order_id in (
select order_id
from orders order by order_date desc limit 5)
group by orders.order_id;

--What is the name and category of my products sold in January, and the total amount of sales?
SELECT products.product_name, categories.category_name, SUM(order_details.quantity) as total_orders
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN categories ON products.category_id = categories.category_id
WHERE EXTRACT(MONTH FROM orders.order_date) = 1 -- January
GROUP BY products.product_name, categories.category_name;

--What are my sales above my average sales amount?
SELECT orders.order_id, order_details.quantity, avg(order_details.quantity) as averag_quantity from orders
join order_details on order_details.order_id = orders.order_id
WHERE order_details.quantity > (
  SELECT AVG(order_details.quantity) as average_quantity
  FROM order_details
)
group by orders.order_id,order_details.quantity ;

--The name of my best-selling product (on the basis of units), the name of its category and the name of its supplier

SELECT products.product_name, categories.category_name, suppliers.company_name, order_details.quantity
FROM products
JOIN order_details ON products.product_id = order_details.product_id
JOIN categories  ON products.category_id = categories.category_id
JOIN suppliers  ON products.product_id = suppliers.supplier_id
order by order_details.quantity desc limit 1;

--How many countries do I have customers from?
select count(distinct country) as conutry_count
from customers;

--How many products has the employee (employee) with ID #3 sold in total since last January to TODAY?
select employees.employee_id, sum(order_details.quantity) from order_details
join orders on orders.order_id = order_details.order_id
join employees on employees.employee_id = orders.employee_id
where employees.employee_id = 3 and EXTRACT(MONTH FROM orders.order_date) = 1
group by employees.employee_id, orders.order_date
order by orders.order_date desc limit 1;

--The name of the products sold in the order number 10248, the name of the category, the number
SELECT products.product_name, categories.category_name, order_details.quantity
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN categories  ON products.category_id = categories.category_id
WHERE orders.order_id = 10248;

--Name of products of order 10248, name of supplier
SELECT products.product_name, suppliers.company_name
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN suppliers  ON suppliers.supplier_id = products.supplier_id
WHERE orders.order_id = 10248;

--Name and number of products sold by the employee with ID number 3 in 1997
SELECT orders.employee_id, products.product_name, order_details.quantity
FROM orders
JOIN employees ON employees.employee_id = orders.employee_id 
JOIN order_details  ON order_details.order_id = orders.order_id
JOIN products ON order_details.product_id = products.product_id
WHERE employees.employee_id = 3 and EXTRACT(YEAR FROM orders.order_date) = 1997;

--ID, Name and Surname of my top sales employee once in 1997
SELECT employees.employee_id, employees.first_name, employees.last_name, order_details.quantity
FROM employees 
JOIN orders ON orders.employee_id = employees.employee_id 
JOIN order_details ON orders.order_id = order_details.order_id
where (orders.order_date >= '1997-01-01' and orders.order_date <= '1997-12-31')
order by order_details.quantity desc limit 1;

--ID, Name and Surname of my employee with the highest sales in 1997
SELECT employees.employee_id, employees.first_name, employees.last_name
FROM employees 
JOIN orders ON orders.employee_id = employees.employee_id 
JOIN (select employee_id, sum(order_details.quantity) as total_quantity
	 from orders
	 join order_details on orders.order_id = order_details.order_id
	 where (orders.order_date >= '1997-01-01' and orders.order_date <= '1997-12-31')
	 group by employee_id 
	 ) t on employees.employee_id = t.employee_id  

where t.total_quantity = (
 select max(total_quantity)
	from (
	select orders.employee_id, sum(order_details.quantity) as total_quantity from orders
		join order_details on orders.order_id = order_details.order_id
		where (orders.order_date >= '1997-01-01' and orders.order_date <= '1997-12-31')
	    group by employee_id
	) as max_quantity
) limit 1; 

--What is the name, price and category of my most expensive product?
SELECT products.product_name, products.unit_price, categories.category_name
FROM products
JOIN categories ON products.category_id = categories.category_id
WHERE products.unit_price = (
  SELECT MAX(unit_price)
  FROM products
);

--Name, surname, order date, order ID. Sort by order date
SELECT employees.first_name, employees.last_name, orders.order_date, orders.order_id
FROM orders
JOIN employees ON orders.employee_id = employees.employee_id
ORDER BY orders.order_date;

--What is the average price and orderid of my LAST 5 orders?
SELECT AVG(order_details.unit_price) AS average_price, orders.order_id
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
group by orders.order_id
ORDER BY orders.order_date DESC
LIMIT 5;

--What is the name and category of my products sold in January, and the total amount of sales?
SELECT products.product_name, categories.category_name, SUM(order_details.quantity) AS total_order_quantity
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN categories ON products.category_id = categories.category_id
WHERE EXTRACT(MONTH FROM orders.order_date) = 1
GROUP BY products.product_name, categories.category_name;

--What are my sales above my average sales amount?
SELECT orders.order_id, SUM(order_details.quantity) AS total_order_quantity
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY orders.order_id
HAVING SUM(order_details.quantity) > (
  SELECT AVG(quantity)
  FROM order_details
);

--The name of my best-selling product (on the basis of units), the name of its category and the name of its supplier
SELECT products.product_name, categories.category_name, suppliers.company_name, order_details.quantity
FROM products
JOIN order_details ON products.product_id = order_details.product_id
JOIN categories  ON products.category_id = categories.category_id
JOIN suppliers  ON products.product_id = suppliers.supplier_id
order by order_details.quantity desc limit 1;

--How many countries do I have customers from?
select count(distinct country) as conutry_count
from customers;

--How many customers from which country we have
SELECT country, COUNT(*) as customer_count
FROM customers
GROUP BY country;

--How many products has the employee (employee) with ID #3 sold in total since last January to TODAY?
select employees.employee_id, sum(order_details.quantity) from order_details
join orders on orders.order_id = order_details.order_id
join employees on employees.employee_id = orders.employee_id
where employees.employee_id = 3 and EXTRACT(MONTH FROM orders.order_date) = 1
group by employees.employee_id, orders.order_date
order by orders.order_date desc limit 1;

--How much endorsement did I get from my product with ID number 10 in the last 3 months?
SELECT orders.order_date, SUM(order_details.quantity * products.unit_price) AS total_endorsement
FROM order_details
JOIN products ON order_details.product_id = products.product_id
JOIN orders ON orders.order_id = order_details.order_id
WHERE order_details.product_id = 10
group by orders.order_date;

--Which employee has received a total of how many orders so far..?
SELECT employees.employee_id, CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name, COUNT(*) AS total_orders
FROM employees
JOIN orders ON employees.employee_id = orders.employee_id
GROUP BY employees.employee_id, employee_name
ORDER BY total_orders DESC;

--I have 91 clients. Only 89 ordered. Find 2 people who didn't order
SELECT customer_id, contact_name
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

--Company Name, Representative Name, Address, City, Country information of customers located in Brazil

SELECT company_name, contact_name, address, city, country
FROM customers
WHERE country = 'Brazil';

--Customers not in Brazil
SELECT *
FROM customers
WHERE country <> 'Brazil';

--Customers whose country is or Spain, France, or Germany
SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

--Customers whose fax number I do not know
SELECT *
FROM customers
WHERE fax IS NULL;

--My clients in London or Paris
SELECT *
FROM customers
WHERE city IN ('London', 'Paris');

--Customers both residing in Mexico D.F AND having 'owner' ContactTitle information
SELECT *
FROM customers
WHERE city = 'Mexico D.F' AND contact_title = 'owner';

--Names and prices of my products starting with C
SELECT product_name, unit_price
FROM products
WHERE product_name LIKE 'C%';

--Employees (Employees) whose name (FirstName) starts with the letter 'A'; Name, Surname and Dates of Birth
SELECT first_name, last_name, birth_date
FROM employees
WHERE first_name LIKE 'A%';

--Company names of my customers with 'RESTAURANT' in their name
SELECT company_name
FROM customers
WHERE company_name LIKE '%RESTAURANT%';

--Names and prices of all products between $50 and $100
SELECT product_name, unit_price
FROM products
WHERE unit_price BETWEEN 50 AND 100;

--Orders (Orders), OrderID (OrderID) and OrderDate (OrderDate) information between 1 July 1996 and 31 December 1996
SELECT order_id, order_date
FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31';

--Customers whose country is OR Spain, France, or Germany
SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

--Customers whose fax number I do not know
SELECT *
FROM customers
WHERE fax IS NULL;
