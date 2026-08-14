use blinkit_project;

## 1.Calculate total revenue per customer.

SELECT
    customer_id,
    SUM(order_total) AS total_revenue
FROM orders
GROUP BY customer_id;


 ## 2.Find the top 10 customers by revenue.

SELECT
    customer_id,
    SUM(order_total) AS total_revenue
FROM orders
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;


## 3.Find customers with more than 10 total orders.

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 10;

## 4. Calculate average order value per customer segment.

SELECT
    c.customer_segment,
    AVG(customer_aov) AS avg_order_value
FROM (
    SELECT
        customer_id,
        AVG(order_total) AS customer_aov
    FROM orders
    GROUP BY customer_id
) o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_segment;


## 5.Calculate total revenue by customer segment.

SELECT
    c.customer_segment,
    SUM(o.order_total) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_segment;


## 6.Find areas with average order value above 500.

SELECT
    c.area,
    AVG(o.order_total) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.area
HAVING AVG(o.order_total) > 500;

## 7.Identify high-value customers (revenue > overall average).


SELECT
    customer_id,
    SUM(order_total) AS total_revenue
FROM orders
GROUP BY customer_id
HAVING SUM(order_total) >
       (
           SELECT AVG(customer_revenue)
           FROM (
               SELECT
                   customer_id,
                   SUM(order_total) AS customer_revenue
               FROM orders
               GROUP BY customer_id
           ) t
       );



## 8.Find the segment contributing the highest revenue.

SELECT
    c.customer_segment,
    SUM(o.order_total) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_segment
ORDER BY total_revenue DESC
LIMIT 1;


# 9.Count customers in each area.

SELECT
    area,
    COUNT(*) AS customer_count
FROM customers
GROUP BY area;


## 10.Find customers who belong to the Premium segment.

SELECT *
FROM customers
WHERE customer_segment = 'Premium';


##  Q11. Which customer segment places the highest number of orders?

SELECT customer_segment,
       SUM(total_orders) AS total_orders
FROM customers
GROUP BY customer_segment;


## Q12. What percentage of customers are inactive?


SELECT 
  (COUNT(CASE WHEN customer_segment = 'Inactive' THEN 1 END) * 100.0 / COUNT(*)) 
  AS inactive_percentage
FROM customers;


 ## Q13. Which areas generate the highest total revenue?

SELECT area,
       SUM(total_orders * avg_order_value) AS total_revenue
FROM customers
GROUP BY area
ORDER BY total_revenue DESC;

## Q14. Who are the top 10 high-value customers?

SELECT customer_id,
       total_orders,
       avg_order_value,
       (total_orders * avg_order_value) AS lifetime_value
FROM customers
ORDER BY lifetime_value DESC
LIMIT 10;

## Q15. Which areas have the highest inactive customers?

SELECT area,
       COUNT(*) AS inactive_customers
FROM customers
WHERE customer_segment = 'Inactive'
GROUP BY area
ORDER BY inactive_customers DESC;

## Q16. Which customer segment contributes the highest revenue?

SELECT customer_segment,
       SUM(total_orders * avg_order_value) AS total_revenue
FROM customers
GROUP BY customer_segment;


## Q17. Find average delivery delay by area?

  SELECT
    c.area,
    AVG(TIMESTAMPDIFF(MINUTE,
        o.promised_delivery_time,
        o.actual_delivery_time)) AS avg_delay_minutes
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.actual_delivery_time > o.promised_delivery_time
GROUP BY c.area
ORDER BY avg_delay_minutes DESC; 

## Q18. Find percentage of delayed orders?

SELECT
    ROUND(
        COUNT(CASE WHEN actual_delivery_time > promised_delivery_time THEN 1 END)
        * 100.0 / COUNT(*),
        2
    ) AS delayed_order_percentage
FROM orders;

## Q19. Top 10 products by revenue?

SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;


## Q20. Revenue by category?

SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


## Q21. Campaign with highest ROAS?

SELECT
    campaign_name,
    ROAS
FROM marketing
ORDER BY ROAS DESC
LIMIT 1;


## Q22. Channel with highest conversions?

SELECT
    channel,
    SUM(conversions) AS total_conversions
FROM marketing
GROUP BY channel
ORDER BY total_conversions DESC
LIMIT 1;


## Q23. Average rating by feedback category?

SELECT
    feedback_category,
    AVG(rating) AS avg_rating
FROM customer_feedback
GROUP BY feedback_category
ORDER BY avg_rating DESC;


## Q24. Sentiment distribution?

SELECT
    sentiment,
    COUNT(*) AS total_feedback
FROM customer_feedback
GROUP BY sentiment
ORDER BY total_feedback DESC;