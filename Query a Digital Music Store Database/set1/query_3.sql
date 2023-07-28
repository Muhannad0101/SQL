-- Who is the best customer?
SELECT c.CustomerId,
       c.FirstName CustomerName,
       SUM(i.Total) MoneySpent 
  FROM Invoice i
  JOIN Customer c
  ON i.CustomerId = c.CustomerId
GROUP BY CustomerName
ORDER BY MoneySpent DESC 
