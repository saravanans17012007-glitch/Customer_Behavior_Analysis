use customer;

select*from customer_shopping_cleaned;


select gender,sum(purchase_amount) as revenue from customer_shopping_cleaned
group by gender;


select customer_id, purchase_amount from customer_shopping_cleaned
where discount_applied="Yes" and purchase_amount >= (select avg(purchase_amount) from customer_shopping_cleaned);



select item_purchased,avg(review_rating) as "average product rating" from customer_shopping_cleaned
group by item_purchased
order by avg(review_rating) desc
limit 5;


select shipping_type,avg(purchase_amount) from customer_shopping_cleaned
where shipping_type in ("Standard","Express")
group by shipping_type;


select subscription_status,COUNT(customer_id) as total_customers,ROUND(AVG(purchase_amount), 2) as avg_spend,ROUND(SUM(purchase_amount), 2) as total_revenue from customer_shopping_cleaned
group by subscription_status
order by total_revenue, avg_spend desc;


select item_purchased,ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*) * 100, 2) as discount_rate
from customer_shopping_cleaned
group by item_purchased
order by discount_rate desc
limit 5;

WITH customer_type AS (
    SELECT 
        customer_id, 
        previous_purchases,
        CASE 
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer_shopping_cleaned
)
SELECT 
    customer_segment, 
    COUNT(*) AS "Number of Customers"
FROM customer_type
GROUP BY customer_segment;


with item_counts as (
    select category,
    item_purchased,
    COUNT(customer_id) as total_orders,
    ROW_NUMBER() over(partition by category order by count(customer_id) DESC) as item_rank
    from customer_shopping_cleaned
    group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank<=3;


SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer_shopping_cleaned
WHERE previous_purchases > 5
GROUP BY subscription_status;


select age_group,
    SUM(purchase_amount) AS total_revenue from customer_shopping_cleaned
group by age_group
order by total_revenue DESC;