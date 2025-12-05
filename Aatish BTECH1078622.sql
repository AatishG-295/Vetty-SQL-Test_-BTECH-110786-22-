Note: All the following SQL queries have been solved using MySQL, following MySQL-specific syntax and functions.


Questions:


1. What is the count of purchases per month (excluding refunded purchases)?

SELECT
     DATE_FORMAT(purchase_time, '%Y-%m') as month_start_date,    -- convert timestamp to YYYY-MM
    COUNT(*) AS purchase_count                                   -- count valid purchases
FROM transactions
WHERE refund_item IS NULL                                        -- excluded the refunded purchases
GROUP BY DATE_FORMAT(purchase_time, '%Y-%m')
ORDER BY month_start_date;

Approach - firstly remove all refunded transactions so only valid purchases remain. 
Then convert the purchase date into a month format and count how many purchases happened in each month.




2. How many stores receive at least 5 orders/transactions in October 2020?

-- Count orders per store for October 2020
WITH store_orders AS (
    SELECT
        store_id,
        COUNT(*) AS order_count
    FROM transactions
    WHERE purchase_time >= '2020-10-01'
      AND purchase_time <  '2020-11-01'                         -- full month of October
    GROUP BY store_id
)
-- Count how many of these stores have at least 5 orders

SELECT
    COUNT(*) AS num_stores_with_5plus_orders
FROM store_orders
WHERE order_count >= 5;

Approach - filtered the data to include only October 2020 purchases. After that count how many orders each store received during that month. 
Finally pick only those stores that received five or more orders.





3. For each store, what is the shortest interval (in min) from purchase to refund time?

SELECT
    store_id,
    MIN(
        TIMESTAMPDIFF(MINUTE, purchase_time, refund_item)
    ) AS min_refund_interval_minutes                  -- shortest interval
FROM transactions
WHERE refund_item IS NOT NULL                         -- only refunded orders
GROUP BY store_id;

Approach - consider the transactions that actually got refunded. For each of these calculate how many minutes passed 
between the purchase and the refund. Then find the shortest refund time for every store




4. What is the gross_transaction_value of every store’s first order?

SELECT t1.store_id,
       t1.buyer_id,
       t1.purchase_time AS first_order_time,
       t1.gross_transaction_value AS first_order_gross_value
FROM transactions t1
JOIN (
    SELECT store_id, MIN(purchase_time) AS first_purchase_time
    FROM transactions
    GROUP BY store_id
) t2
ON t1.store_id = t2.store_id
AND t1.purchase_time = t2.first_purchase_time
ORDER BY t1.store_id;

Approach - For every buyer arrange their orders in chronological order. Then measure how many days passed between one order 
and the next. Once have all these gaps calculate the average to understand how frequently buyers place follow-up orders.




5. What is the most popular item name that buyers order on their first purchase?

SELECT i.item_name, COUNT(*) AS times_ordered_as_first_purchase
FROM (
    SELECT buyer_id, store_id, item_id
    FROM (
        SELECT t.*, ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS r
        FROM transactions t
    ) x
    WHERE r = 1
) fp
JOIN items i
  ON i.store_id = fp.store_id AND i.item_id = fp.item_id
GROUP BY i.item_name
ORDER BY times_ordered_as_first_purchase DESC, i.item_name
LIMIT 1;

Approach - started by identifying the very first purchase made by each buyer. Then checked which item they bought in that first 
transaction. After collecting all first-purchase items count which item appears most often, that becomes the most popular first-purchase item.




6. Create a flag in the transaction items table indicating whether the refund can be processed or
not. The condition for a refund to be processed is that it has to happen within 72 of Purchasetime.

SELECT
    t.*,
    CASE
        WHEN t.refund_item IS NOT NULL
             AND TIMESTAMPDIFF(HOUR, t.purchase_time, t.refund_item) <= 72
        THEN 'True'        -- refund can be processed
        ELSE 'False'    -- too late or missing
    END AS refund_processable
FROM transactions t;

Apporach - For every refunded transaction check how many hours passed between the purchase and the refund. If the refund happened 
within 72 hours mark it as “True.” Otherwise, it is marked as “False.”




7. Create a rank by buyer_id column in the transaction items table and filter for only the second
purchase per buyer. (Ignore refunds here)

SELECT *
FROM (
    SELECT t.*, ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS r
    FROM transactions t
) x
WHERE r = 2
ORDER BY buyer_id, purchase_time;

Approach - ignore all refunded purchases because they shouldn’t be counted. Then sorted each buyer’s valid purchases by date and number them as 
first, second, third, etc. Finally, I pick only the purchase that is labeled as the second one for each buyer.




8. How will you find the second transaction time per buyer (don’t use min/max; assume there
were more transactions per buyer in the table)

SELECT buyer_id, purchase_time AS second_purchase_time
FROM (
    SELECT buyer_id, purchase_time,
           ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS r
    FROM transactions
) x
WHERE r = 2
ORDER BY buyer_id;

Approach - sorted every buyer’s transactions by date and assign them row numbers in that order. The transaction that gets row number 2 is the 
buyer’s second transaction. This gives the exact timestamp of the second order without using MIN or MAX.
























