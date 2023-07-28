--Which city has the best customers?
SELECT BillingCity, 
       SUM(i.Total) Invoice_total
FROM Invoice i
GROUP BY BillingCity
ORDER BY Invoice_total DESC
LIMIT 5