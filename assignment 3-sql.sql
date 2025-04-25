--List all customers with their full name and city.
select 
	first_name ,
	last_name, 
	city
from lux_teaching.customers c;

--Show all books priced above 2000.
select *
from lux_teaching.books b 
where price > 2000;

--List customers who live in 'Nairobi'.
select *
from lux_teaching.customers c 
where city = 'Nairobi';

--Retrieve all book titles that were published in 2023.
select *
from lux_teaching.books b
where published_date between '2023-01-01' and '2023-12-31';

-- Show all orders placed after March 1st, 2025.
select *
from lux_teaching.orders o 
where order_date  >= '2025-03-01'

-- List all books ordered, sorted by price (descending).
select 
	o.book_id,
	order_id,
	title,
	price
from lux_teaching.orders o
left join lux_teaching.books b
on o.book_id = b.book_id
order by price desc;


-- Show all customers whose names start with 'J'.
select *
from lux_teaching.customers c 
where first_name  like 'J%';


-- List books with prices between 1500 and 3000.
select *
from lux_teaching.books b 
where price between 1500 and 3000;


-- Count the number of customers in each city.
select 
	city,
	COUNT(*) as Total_customers
from lux_teaching.customers c 
group by city;

-- Show the total number of orders per customer.
select 
      customer_id,
      COUNT(*) as total_orders
from lux_teaching.orders o 
group by customer_id;

-- Find the average price of books in the store.
select 
	avg(price)
from lux_teaching.books b;


-- List the book title and total quantity ordered for each book.
select 	
	title,
	sum(quantity) as total_quantity
from lux_teaching.books b 
left join lux_teaching.orders o 
on b.book_id = o.book_id
group by b.book_id;

--Subqueries
-- 13. Show customers who have placed more orders than customer with ID = 1.
select 
   customer_id,
   count(order_id) as total_order
from lux_teaching.orders
group by customer_id 
having count(order_id) >
   (select 
	count(order_id)
from lux_teaching.orders
where customer_id = 1);


-- 14. List books that are more expensive than the average book price.
select *
from lux_teaching.books b 
where price > (select avg(price) from lux_teaching.books b)

-- 15. Show each customer and the number of orders they placed using a subquery in SELECT.

select c.customer_id, c.first_name, (
        select count(*) 
        FROM orders o 
        WHERE o.customer_id = c.customer_id
    ) "total_orders"
from customers c;

-- JOINS
-- 16. Show full name of each customer and the titles of books they ordered.
select
 concat(first_name,' ',Last_name) as full_name,
 title
from
	lux_teaching.customers c 
	inner join  orders o  
	on c.customer_id = o.customer_id
	inner  join books b 
	on o.book_id = b.book_id
	
-- 17. List all orders including book title, quantity, and total cost (price × quantity).
	select 
		*, title,
		quantity,
		(price * quantity) as total_cost
	from lux_teaching.orders o 
	left join lux_teaching.books b 
	on o.book_id  = b.book_id
-- 18. Show customers who haven't placed any orders (LEFT JOIN).
select 
	c.customer_id,
	first_name, 
	last_name 	
from lux_teaching.customers c
left join lux_teaching.orders o
on c.customer_id = o.customer_id
where order_id is null;
-- 19. List all books and the names of customers who ordered them, if any (LEFT JOIN).
select 
	title, 
	first_name, 
	Last_name
from lux_teaching.books b 
left join lux_teaching.orders o 
using(book_id)
left join lux_teaching.customers c 
using (customer_id);

-- 20. Show customers who live in the same city (SELF JOIN).
select 
	c.customer_id,
	c.first_name ,
	c2.customer_id, 
	c.city
from lux_teaching.customers c  
join lux_teaching.customers c2 
on c.city = c2.city;

-- Combined Logic
-- 21. Show all customers who placed more than 2 orders for books priced over 2000.
select 
	o.customer_id,
	c.first_name,
	count(order_id) as total_order
from lux_teaching.customers c 
inner join lux_teaching.orders o 
using(customer_id)
inner join lux_teaching.books
using(book_id)
group by o.customer_id, c.first_name,price
having price > 2000 and count(order_id) > 1;

-- 22. List customers who ordered the same book more than once.
select
	distinct b.title,
	o.customer_id,
	c.first_name,
	o.book_id,
	count(o.book_id) as same_book_order
from lux_teaching.customers c 
inner join lux_teaching.orders o 
using(customer_id)
inner join lux_teaching.books b
using(book_id)
group by distinct b.title, o.customer_id, c.first_name,o.book_id
having count(o.book_id) > 1;

-- 23. Show each customer's full name, total quantity of books ordered, and total amount spent.
select 
	concat(c.first_name, ' ', c.last_name) as Names, 
	sum(o.quantity) as total_qantity,
	b.price * o.quantity as Total_amount
from lux_teaching.orders o
join lux_teaching.books b on o.book_id = b.book_id
join lux_teaching.customers c on c.customer_id = o.customer_id
group by c.first_name, c.last_name, b.price, o.quantity;

--24. List books that have never been ordered.
select 
	 b.title	 
from  lux_teaching.books as b
right join orders as o
using (book_id)
group by b.title
having count(*) = 0;
--25. Find the customer who has spent the most in total (JOIN + GROUP BY + ORDER BY + LIMIT).
select 
	concat(c.first_name, ' ', c.last_name) as Names, 
	sum(b.price * o.quantity)as Total_amount
from lux_teaching.orders o
join lux_teaching.books b on o.book_id = b.book_id
join lux_teaching.customers c on c.customer_id = o.customer_id
group by c.first_name, c.last_name
order by total_amount desc
limit 1;

-- 26. Write a query that shows, for each book, the number of different customers who have ordered it.
select 
	b.book_id,
	b.title,
	count(customer_id) as total_customers
from lux_teaching.books b 
left join orders o 
using(book_id)
group by b.book_id, b.title;


-- 27. Using a subquery, list books whose total order quantity is above the average order quantity.
SELECT 
    b.book_id,
    b.title
FROM 
    lux_teaching.books b
JOIN (
    SELECT 
        book_id,
        SUM(quantity) AS total_quantity
    FROM 
        lux_teaching.orders
    GROUP BY 
        book_id
    HAVING SUM(quantity) > (
        SELECT AVG(quantity) FROM lux_teaching.orders
    )
) o ON b.book_id = o.book_id;



-- 28. Show the top 3 customers with the highest number of orders and the total amount they spent. Be sure to format
select concat(c.first_name, ' ', c.last_name) as Names, sum(o.quantity*b.price) as total_amount_spent, count(o.book_id)
from lux_teaching.orders o
join lux_teaching.books b on o.book_id = b.book_id
join lux_teaching.customers c on c.customer_id = o.customer_id
group by c.first_name, c.last_name
order by sum(o.quantity*b.price) desc
limit 3;
