-- 10. Fiyatı 30'dan büyük kaç ürün var?
select count(*) from products
where unit_price>30;

-- 11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
select LOWER(product_name) from products
order by unit_price desc;

-- 12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır 
select * from employees
order by first_name, last_name;

-- 13. Region alanı NULL olan kaç tedarikçim var?
select count(*) from suppliers
where region is null; 

-- 14. a.Null olmayanlar?
select count(*) from suppliers
where region is not null; 

-- 15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
select CONCAT('TR', ' ', product_name) as product_name from products
order by upper(product_name);

-- 16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
update products
set product_name = CONCAT('TR', ' ', product_name)
where unit_price<20;

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products
where unit_price = (select max(unit_price) from products);

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products
order by unit_price desc
limit 10;

--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products
WHERE unit_price > (SELECT AVG(unit_price) FROM products);

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
SELECT SUM(unit_price * units_in_stock) AS TotalRevenue
FROM Products
WHERE units_in_stock > 0;

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
SELECT
  SUM(CASE WHEN discontinued = 1 THEN 1 ELSE 0 END) AS AvailableProducts,
  SUM(CASE WHEN discontinued = 0 THEN 1 ELSE 0 END) AS DiscontinuedProducts
FROM Products;

--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
SELECT products.product_name, categories.category_name
FROM products
JOIN categories ON products.category_id = categories.category_id;

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT categories.category_name, AVG(products.unit_price) AS price_average
FROM products 
JOIN categories ON products.category_id = categories.category_id
GROUP BY categories.category_name;

--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
select products.product_name, products.unit_price, categories.category_name from products
JOIN categories ON products.category_id = categories.category_id
where products.product_id = (
	select product_id from products 
	group by product_id 
	order by count(*) desc LIMIT 1
);

--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select products.units_in_stock, products.product_id, products.product_name, suppliers.company_name, suppliers.phone from products
join suppliers on products.supplier_id = suppliers.supplier_id
where products.units_in_stock = 0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select orders.order_date, orders.ship_address, employees.first_name, employees.last_name from orders
join employees on orders.employee_id = employees.employee_id
where (orders.order_date >= '1998-03-01' and orders.order_date<= '1998-03-31');

--28. 1997 yılı şubat ayında kaç siparişim var?
select count(*) as order_count from orders
where (orders.order_date >= '1997-02-01' and orders.order_date<= '1997-02-28');

--29. London şehrinden 1998 yılında kaç siparişim var?
select count(*) as order_count from orders
where (ship_city = 'London' and orders.order_date >= '1998-01-01' and orders.order_date<= '1998-12-31');

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select orders.order_date, customers.contact_name, customers.phone from customers
join orders on orders.customer_id = customers.customer_id
where (orders.order_date >= '1997-01-01' and orders.order_date<= '1997-12-31');

--31. Taşıma ücreti 40 üzeri olan siparişlerim 
select * from orders
where freight > 40;

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select freight, ship_city, ship_name from orders
where freight >= 40;

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select orders.order_date, orders.ship_city, CONCAT(upper(employees.first_name),' ', upper(employees.last_name)) as Name from orders
join employees on orders.employee_id = employees.employee_id
where (orders.order_date >= '1997-01-01' and orders.order_date<= '1997-12-31');

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select contact_name, phone from customers
join orders on orders.customer_id = customers.customer_id
where (orders.order_date >= '1997-01-01' and orders.order_date<= '1997-12-31');

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select orders.order_date, customers.contact_name, CONCAT(upper(employees.first_name),' ', upper(employees.last_name)) as employee_name
from orders
join employees on orders.employee_id = employees.employee_id
join customers on orders.customer_id = customers.customer_id
order by orders.order_date;

--36. Geciken siparişlerim?
select required_date, shipped_date from orders
order by shipped_date > required_date;

--37. Geciken siparişlerimin tarihi, müşterisinin adı
select orders.order_date, customers.company_name from orders
join customers on orders.customer_id = customers.customer_id
order by shipped_date > required_date;

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select products.product_name, categories.category_name, order_details.quantity from products
join categories on categories.category_id = products.category_id
join order_details on order_details.product_id = products.product_id
where order_details.order_id = '10248';

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı 
select products.product_name, suppliers.company_name, order_details.order_id from products
join suppliers on suppliers.supplier_id = products.supplier_id
join order_details on order_details.product_id = products.product_id
where order_details.order_id = '10248';

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select employees.employee_id, products.product_name, order_details.quantity
from employees
join orders on orders.employee_id = employees.employee_id
join order_details on orders.order_id = order_details.order_id
join products on order_details.product_id = products.product_id
where employees.employee_id = '3' and orders.order_date >= '1997-01-01' and orders.order_date<= '1997-12-31';

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT employees.employee_id, employees.first_name, employees.last_name, order_details.quantity
FROM employees 
JOIN orders ON orders.employee_id = employees.employee_id 
JOIN order_details ON orders.order_id = order_details.order_id
where (orders.order_date >= '1997-01-01' and orders.order_date <= '1997-12-31')
order by order_details.quantity desc limit 1;

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad 

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

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select products.product_name, products.unit_price, categories.category_name from products
join categories on products.category_id = categories.category_id
order by products.unit_price desc limit 1;

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select employees.first_name, employees.last_name, orders.order_date, orders.order_id from employees
join  orders on orders.employee_id = employees.employee_id
order by orders.order_date;

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir? 
select avg(order_details.unit_price) as average_price, orders.order_id
from orders
join order_details on orders.order_id = order_details.order_id
where orders.order_id in (
select order_id
from orders order by order_date desc limit 5)
group by orders.order_id;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT products.product_name, categories.category_name, SUM(order_details.quantity) as total_orders
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN categories ON products.category_id = categories.category_id
WHERE EXTRACT(MONTH FROM orders.order_date) = 1 -- January
GROUP BY products.product_name, categories.category_name;

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir? 
SELECT orders.order_id, order_details.quantity, avg(order_details.quantity) as averag_quantity from orders
join order_details on order_details.order_id = orders.order_id
WHERE order_details.quantity > (
  SELECT AVG(order_details.quantity) as average_quantity
  FROM order_details
)
group by orders.order_id,order_details.quantity ;

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı 

SELECT products.product_name, categories.category_name, suppliers.company_name, order_details.quantity
FROM products
JOIN order_details ON products.product_id = order_details.product_id
JOIN categories  ON products.category_id = categories.category_id
JOIN suppliers  ON products.product_id = suppliers.supplier_id
order by order_details.quantity desc limit 1;

--49. Kaç ülkeden müşterim var
select count(distinct country) as conutry_count
from customers;

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select employees.employee_id, sum(order_details.quantity) from order_details
join orders on orders.order_id = order_details.order_id
join employees on employees.employee_id = orders.employee_id
where employees.employee_id = 3 and EXTRACT(MONTH FROM orders.order_date) = 1
group by employees.employee_id, orders.order_date
order by orders.order_date desc limit 1;

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi 
SELECT products.product_name, categories.category_name, order_details.quantity
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN categories  ON products.category_id = categories.category_id
WHERE orders.order_id = 10248;

--    52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı 
SELECT products.product_name, suppliers.company_name
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN suppliers  ON suppliers.supplier_id = products.supplier_id
WHERE orders.order_id = 10248;

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT orders.employee_id, products.product_name, order_details.quantity
FROM orders
JOIN employees ON employees.employee_id = orders.employee_id 
JOIN order_details  ON order_details.order_id = orders.order_id
JOIN products ON order_details.product_id = products.product_id
WHERE employees.employee_id = 3 and EXTRACT(YEAR FROM orders.order_date) = 1997;

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT employees.employee_id, employees.first_name, employees.last_name, order_details.quantity
FROM employees 
JOIN orders ON orders.employee_id = employees.employee_id 
JOIN order_details ON orders.order_id = order_details.order_id
where (orders.order_date >= '1997-01-01' and orders.order_date <= '1997-12-31')
order by order_details.quantity desc limit 1;

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
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

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT products.product_name, products.unit_price, categories.category_name
FROM products
JOIN categories ON products.category_id = categories.category_id
WHERE products.unit_price = (
  SELECT MAX(unit_price)
  FROM products
);

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT employees.first_name, employees.last_name, orders.order_date, orders.order_id
FROM orders
JOIN employees ON orders.employee_id = employees.employee_id
ORDER BY orders.order_date;

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir? 
SELECT AVG(order_details.unit_price) AS average_price, orders.order_id
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
group by orders.order_id
ORDER BY orders.order_date DESC
LIMIT 5;

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT products.product_name, categories.category_name, SUM(order_details.quantity) AS total_order_quantity
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN categories ON products.category_id = categories.category_id
WHERE EXTRACT(MONTH FROM orders.order_date) = 1
GROUP BY products.product_name, categories.category_name;

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir? 
SELECT orders.order_id, SUM(order_details.quantity) AS total_order_quantity
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY orders.order_id
HAVING SUM(order_details.quantity) > (
  SELECT AVG(quantity)
  FROM order_details
);

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT products.product_name, categories.category_name, suppliers.company_name, order_details.quantity
FROM products
JOIN order_details ON products.product_id = order_details.product_id
JOIN categories  ON products.category_id = categories.category_id
JOIN suppliers  ON products.product_id = suppliers.supplier_id
order by order_details.quantity desc limit 1;

--62. Kaç ülkeden müşterim var
select count(distinct country) as conutry_count
from customers;

--63. Hangi ülkeden kaç müşterimiz var
SELECT country, COUNT(*) as customer_count
FROM customers
GROUP BY country;

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select employees.employee_id, sum(order_details.quantity) from order_details
join orders on orders.order_id = order_details.order_id
join employees on employees.employee_id = orders.employee_id
where employees.employee_id = 3 and EXTRACT(MONTH FROM orders.order_date) = 1
group by employees.employee_id, orders.order_date
order by orders.order_date desc limit 1;

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT orders.order_date, SUM(order_details.quantity * products.unit_price) AS toplam_ciro
FROM order_details
JOIN products ON order_details.product_id = products.product_id
JOIN orders ON orders.order_id = order_details.order_id
WHERE order_details.product_id = 10
group by orders.order_date;

--66. Hangi çalışan şimdiye kadar  toplam kaç sipariş almış..?
SELECT employees.employee_id, CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name, COUNT(*) AS total_orders
FROM employees
JOIN orders ON employees.employee_id = orders.employee_id
GROUP BY employees.employee_id, employee_name
ORDER BY total_orders DESC;

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT customer_id, contact_name
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri

SELECT company_name, contact_name, address, city, country
FROM customers
WHERE country = 'Brazil';

--69. Brezilya’da olmayan müşteriler
SELECT *
FROM customers
WHERE country <> 'Brazil';

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

--71. Faks numarasını bilmediğim müşteriler
SELECT *
FROM customers
WHERE fax IS NULL;

--72. Londra’da ya da Paris’de bulunan müşterilerim
SELECT *
FROM customers
WHERE city IN ('London', 'Paris');

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
SELECT *
FROM customers
WHERE city = 'Mexico D.F' AND contact_title = 'owner';

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name, unit_price
FROM products
WHERE product_name LIKE 'C%';

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name, last_name, birth_date
FROM employees
WHERE first_name LIKE 'A%';

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name
FROM customers
WHERE company_name LIKE '%RESTAURANT%';

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name, unit_price
FROM products
WHERE unit_price BETWEEN 50 AND 100;

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id, order_date
FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31';

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

--80. Faks numarasını bilmediğim müşteriler
SELECT *
FROM customers
WHERE fax IS NULL;
