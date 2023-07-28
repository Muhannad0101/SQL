-- Which countries have the most Invoices?
SELECT BillingCountry,
       COUNT(*) Invoice_count
FROM Invoice
GROUP BY BillingCountry
ORDER BY Invoice_count DESC
LIMIT 24;