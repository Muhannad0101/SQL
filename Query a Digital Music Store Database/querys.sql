-- 1 Which employee made the most sales?
SELECT e.EmployeeId,
       e.FirstName ||' '||e.LastName EmployeeName,
	SUM(ROUND(i.Total)) TotalSalesAmount,
	e.Title
FROM Invoice i
JOIN Customer c
ON i.CustomerId = c.CustomerId
JOIN Employee e
ON c.SupportRepId = e.EmployeeId
GROUP BY 1
ORDER BY 2;



-- 2 Which is the most popular media type?
SELECT m.Name MediaTypeName,
       SUM(il.Quantity) SumMediaType
FROM MediaType m
JOIN Track t
ON m.MediaTypeId = t.MediaTypeId
JOIN InvoiceLine il
ON t.TrackId = il.TrackId
GROUP BY 1
ORDER BY 2 DESC;




-- 3 Which customer from the USA purchased the most?
SELECT c.FirstName || ' '|| c.LastName CustomerName, 
       c.Country, 
       SUM(i.Total) purchased
FROM Invoice i 
JOIN Customer c
ON i.CustomerId = c.CustomerId
WHERE c.Country = 'USA'
GROUP BY CustomerName,c.Country
ORDER BY purchased DESC 
LIMIT 5;



-- 4 Which artist made the most sales?
SELECT art.Name ArtistName,
       SUM(ROUND(il.Quantity * il.UnitPrice)) TotalSalesAmount
FROM InvoiceLine il
JOIN Track t
ON il.TrackId = t.TrackId
JOIN Album alb 
ON alb.AlbumId = t.AlbumId
JOIN Artist art
ON art.ArtistId = alb.ArtistId
GROUP BY ArtistName
ORDER BY TotalSalesAmount DESC
LIMIT 10;



-- 5 Which artist has the most albums?
SELECT art.ArtistId,
       art.Name, 
       COUNT(*) songs 
FROM Album alb
JOIN Artist art
ON alb.ArtistId = art.ArtistId
JOIN Track t
ON t.AlbumId = alb.AlbumId
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;




-- 6 Which country made the most sales in Rock music?
WITH p1 AS (
SELECT i.BillingCountry Country,
	g.Name GenraName,
	SUM(ROUND(il.Quantity * il.UnitPrice)) TotalSales
FROM Invoice i
JOIN Track t 
ON t.TrackId = il.TrackId
JOIN Genre g 
ON g.GenreId = g.GenreId
JOIN InvoiceLine il 
ON il.InvoiceId = i.InvoiceId
WHERE GenraName = 'Rock'
GROUP BY 1,2
ORDER BY 3 DESC), 
p2 AS (
   SELECT Country,
          GenraName,
          MAX(TotalSales) TotalSales
   FROM p1
   GROUP BY 1, 2
   ORDER BY 3)
SELECT p1.Country, 
	   p1.GenraName,
	   p1.TotalSales
FROM p1
JOIN p2
ON p1.TotalSales = p2.TotalSales 
AND p1.Country = p2.Country 
AND p1.GenraName = p2.GenraName 

