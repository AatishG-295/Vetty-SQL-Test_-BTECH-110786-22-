# Vetty-SQL-Test_-BTECH-10786-22-

Questions:

1. What is the count of purchases per month (excluding refunded purchases)?
   
Approach - firstly remove all refunded transactions so only valid purchases remain. 
Then convert the purchase date into a month format and count how many purchases happened in each month.


2. How many stores receive at least 5 orders/transactions in October 2020?

Approach - filtered the data to include only October 2020 purchases. After that count how many orders each store received during that month. 
Finally pick only those stores that received five or more orders.


3. For each store, what is the shortest interval (in min) from purchase to refund time?

Approach - consider the transactions that actually got refunded. For each of these calculate how many minutes passed 
between the purchase and the refund. Then find the shortest refund time for every store


4. What is the gross_transaction_value of every store’s first order?

Approach - For every buyer arrange their orders in chronological order. Then measure how many days passed between one order 
and the next. Once have all these gaps calculate the average to understand how frequently buyers place follow-up orders.


5. What is the most popular item name that buyers order on their first purchase?

Approach - started by identifying the very first purchase made by each buyer. Then checked which item they bought in that first 
transaction. After collecting all first-purchase items count which item appears most often, that becomes the most popular first-purchase item.


6. Create a flag in the transaction items table indicating whether the refund can be processed or
not. The condition for a refund to be processed is that it has to happen within 72 of Purchasetime.

Apporach - For every refunded transaction check how many hours passed between the purchase and the refund. If the refund happened 
within 72 hours mark it as “True.” Otherwise, it is marked as “False.”


7. Create a rank by buyer_id column in the transaction items table and filter for only the second
purchase per buyer. (Ignore refunds here)

Approach - ignore all refunded purchases because they shouldn’t be counted. Then sorted each buyer’s valid purchases by date and number them as 
first, second, third, etc. Finally, I pick only the purchase that is labeled as the second one for each buyer.


8. How will you find the second transaction time per buyer (don’t use min/max; assume there
were more transactions per buyer in the table)
Approach - sorted every buyer’s transactions by date and assign them row numbers in that order. The transaction that gets row number 2 is the 
buyer’s second transaction. This gives the exact timestamp of the second order without using MIN or MAX.





   
