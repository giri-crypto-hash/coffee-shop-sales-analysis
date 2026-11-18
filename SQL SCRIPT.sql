use coffee_sales;

-- Total records
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_products FROM products;

-- Check missing values
SELECT *
FROM orders
WHERE `Order ID` IS NULL
   OR `Order Date` IS NULL
   OR `Customer ID` IS NULL
   OR `Product ID` IS NULL
   OR Quantity IS NULL;
   
   -- Check duplicate order IDs
SELECT `Order ID`, COUNT(*) AS record_count
FROM orders
GROUP BY `Order ID`
HAVING COUNT(*) > 1;

-- Orders without a matching customer
SELECT o.*
FROM orders o
LEFT JOIN customers c
    ON o.`Customer ID` = c.`Customer ID`
WHERE c.`Customer ID` IS NULL;

##-- Orders without a matching product
SELECT o.*
FROM orders o
LEFT JOIN products p
    ON o.`Product ID` = p.`Product ID`
WHERE p.`Product ID` IS NULL;


---JOINS

SELECT
    o.`Order ID`,
    o.`Order Date`,
    o.`Customer ID`,
    c.Country,
    c.City,
    c.`Loyalty Card`,
    o.`Product ID`,
    p.`Coffee Type`,
    p.`Roast Type`,
    p.Size,
    o.Quantity,
    p.`Unit Price`,
    p.Profit
FROM orders o
INNER JOIN customers c
    ON o.`Customer ID` = c.`Customer ID`
INNER JOIN products p
    ON o.`Product ID` = p.`Product ID`;
    
    -- Total sales revenue



-- Sales by country
SELECT
    c.Country,
    SUM(o.Quantity * p.`Unit Price`) AS total_sales
FROM orders o
JOIN customers c
    ON o.`Customer ID` = c.`Customer ID`
JOIN products p
    ON o.`Product ID` = p.`Product ID`
GROUP BY c.Country
ORDER BY total_sales DESC;   

-- Average order quantity per order ID
SELECT
    AVG(order_quantity) AS avg_quantity_per_order
FROM (
    SELECT
        `Order ID`,
        SUM(Quantity) AS order_quantity
    FROM orders
    GROUP BY `Order ID`
) AS order_summary;



-- Sales by coffee type
SELECT
    p.`Coffee Type`,
    SUM(o.Quantity * p.`Unit Price`) AS total_sales,
    SUM(o.Quantity) AS quantity_sold
FROM orders o
JOIN products p
    ON o.`Product ID` = p.`Product ID`
GROUP BY p.`Coffee Type`
ORDER BY total_sales DESC;

-- Sales by roast type
SELECT
    p.`Roast Type`,
    SUM(o.Quantity * p.`Unit Price`) AS total_sales
FROM orders o
JOIN products p
    ON o.`Product ID` = p.`Product ID`
GROUP BY p.`Roast Type`
ORDER BY total_sales DESC;

-- Top 10 products by revenue


-- Top 10 customers by sales


SELECT
    c.`Loyalty Card`,
    COUNT(DISTINCT c.`Customer ID`) AS total_customers,
    SUM(o.Quantity * p.`Unit Price`) AS total_sales,
    SUM(o.Quantity) AS quantity_sold
FROM orders o
JOIN customers c
    ON o.`Customer ID` = c.`Customer ID`
JOIN products p
    ON o.`Product ID` = p.`Product ID`
GROUP BY c.`Loyalty Card`;


  -- Customers with more than 5 distinct orders
SELECT
    `Customer ID`,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM orders
GROUP BY `Customer ID`
HAVING COUNT(DISTINCT `Order ID`) > 4
ORDER BY total_orders DESC;