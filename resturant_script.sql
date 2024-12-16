-- query 1 shows all menu items
SELECT 
    *
FROM
    menu_items;

-- query 2 shows all order details
SELECT 
    *
FROM
    order_details;  

-- query 3 selects orders made on the 1/1/23 
SELECT 
    *
FROM
    menu_items
        JOIN
    order_details ON menu_items.ï»¿menu_item_id = order_details.item_id
WHERE
    order_date = '1/1/23';

-- query 4 all menu order from 1/1/23 till 3/31/23
SELECT 
    *
FROM
    menu_items
        JOIN
    order_details ON menu_items.ï»¿menu_item_id = order_details.item_id
WHERE
    order_date BETWEEN '1/1/23' AND '3/31/23'
ORDER BY item_name;

-- query 5 shows the resturant menu and their category
select distinct item_name, category from menu_items;

-- query 6 shows the total italian menu order
SELECT 
    COUNT(item_id), item_name, category
FROM
    order_details
        JOIN
    menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
WHERE
    category = 'Italian'
GROUP BY item_name;

-- query 7 shows total mexican menu order
SELECT 
    COUNT(item_id), item_name, category
FROM
    order_details
        JOIN
    menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
WHERE
    category = 'Mexican'
GROUP BY item_name;

-- query 8 shows total asian menu order
SELECT 
    COUNT(item_id), item_name, category
FROM
    order_details
        JOIN
    menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
WHERE
    category = 'Asian'
GROUP BY item_name;

-- query 9 shows total american menu order
SELECT 
    COUNT(item_id), item_name, category
FROM
    order_details
        JOIN
    menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
WHERE
    category = 'American'
GROUP BY item_name;

-- query 10 shows total orders across all categories 
SELECT 
    COUNT(item_id), item_name, category
FROM
    order_details
        JOIN
    menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
WHERE
    category IN ('Italian' , 'Mexican', 'Asian', 'American')
GROUP BY item_name , category;

-- query 11 Highest menu category ordered
SELECT 
    MAX(total_order), item_name, category
FROM
    (SELECT 
        COUNT(item_id) AS total_order, item_name, category
    FROM
        order_details
    JOIN menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
    WHERE
        category IN ('Italian' , 'Mexican', 'Asian', 'American')
    GROUP BY item_name , category) AS highest_order
GROUP BY item_name , category
ORDER BY MAX(total_order) DESC
LIMIT 1;

-- query 12 lowest menu item ordered
SELECT 
    MIN(total_order), item_name, category
FROM
    (SELECT 
        COUNT(item_id) AS total_order, item_name, category
    FROM
        order_details
    JOIN menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
    WHERE
        category IN ('Italian' , 'Mexican', 'Asian', 'American')
    GROUP BY item_name , category) AS lowest_order
GROUP BY item_name , category
ORDER BY MIN(total_order)
LIMIT 1;

-- query 13 shows total revenue
SELECT 
    SUM(price)
FROM
    (SELECT 
        order_id, price, item_name, category
    FROM
        menu_items
    JOIN order_details ON menu_items.ï»¿menu_item_id = order_details.item_id) AS total_revenue;

-- query 14 Total revenue by category
SELECT 
    SUM(price), category
FROM
    (SELECT 
        order_id, price, item_name, category
    FROM
        menu_items
    JOIN order_details ON menu_items.ï»¿menu_item_id = order_details.item_id) AS total_revenue
GROUP BY category;

-- query 15 shows the average revenue per menu item
SELECT 
    AVG(price)
FROM
    (SELECT 
        order_id, price, item_name, category
    FROM
        menu_items
    JOIN order_details ON menu_items.ï»¿menu_item_id = order_details.item_id) AS average_revenue;

-- query 16 shows the highest spending order,menu item and total amount spent per menu item
SELECT 
    order_id, item_name, price
FROM
    order_details
        JOIN
    menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
WHERE
    order_id = (SELECT 
            order_id
        FROM
            (SELECT 
                order_id, SUM(price) AS total_spent
            FROM
                order_details
            JOIN menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
            GROUP BY order_id
            ORDER BY total_spent DESC
            LIMIT 1) AS highest_spent);

-- query 17 shows highest order and total cost
SELECT 
    order_id, SUM(price) AS total_cost
FROM
    (SELECT 
        order_id, item_name, price
    FROM
        order_details
    JOIN menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
    WHERE
        order_id = (SELECT 
                order_id
            FROM
                (SELECT 
                order_id, SUM(price) AS total_spent
            FROM
                order_details
            JOIN menu_items ON order_details.item_id = menu_items.ï»¿menu_item_id
            GROUP BY order_id
            ORDER BY total_spent DESC
            LIMIT 1) AS highest_spent)) AS total_spent
GROUP BY order_id;

-- query 18 shows a list of menu including chicken less than 15$
with chicken_list as
   (select * from menu_items
	where item_name like '%chicken%'),
    price15 as
    (select * from menu_items
       where price < 15)
    
select chicken_list.item_name, chicken_list.category,price15.price from chicken_list
join price15
on chicken_list.ï»¿menu_item_id = price15.ï»¿menu_item_id;

-- query 19 shows the category with the lowest order
 with cte as 
 (select category,count(order_id) as total_order
 from menu_items
 join order_details
 on menu_items.ï»¿menu_item_id = order_details.item_id
 group by category)
 select category,total_order from cte
 group by category
 order by total_order 
 limit 1;
 
    -- query 20 selects the date with the highest order
    select sum(price) as total_sales, order_date
    from menu_items
    join order_details
    on menu_items.ï»¿menu_item_id = order_details.item_id
    group by order_date
    order by total_sales desc
    limit 1;
    
    -- query 21 shows date with the lowest order
     select sum(price) as total_sales, order_date
    from menu_items
    join order_details
    on menu_items.ï»¿menu_item_id = order_details.item_id
    group by order_date
    order by total_sales 
    limit 1;
    
    -- query 22 selects menu items ranking across category
    select category, item_name, sum(price) as total_sales ,
    dense_rank () over(partition by category order by sum(price) desc) as ranking
    from menu_items
    join order_details
    on menu_items.ï»¿menu_item_id = order_details.item_id
    group by category, item_name
    
    
    