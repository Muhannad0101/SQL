--First, find which artist has earned the most according to the InvoiceLines? 
--Now use this artist to find which customer spent the most on this artist.

SELECT 
       -- The top artists according to invoice amounts
       art.Name,
       SUM(ROUND(il.UnitPrice)) AmountSpent

FROM InvoiceLine il 
JOIN Invoice i 
ON i.InvoiceId = il.InvoiceId
JOIN Track t
ON il.TrackId = t.TrackId
JOIN Album alb 
ON t.AlbumId = alb.AlbumId
JOIN Artist art 
ON alb.ArtistId = art.ArtistId
GROUP BY art.Name
ORDER BY AmountSpent DESC
LIMIT 5





SELECT     
      -- The customer with the highest total invoice amount is customer 55, Mark Taylor
      art.Name,
      SUM(il.UnitPrice) AmountSpent,
      c.CustomerId,
  	  c.FirstName,
	  c.LastName
FROM Customer c
JOIN Invoice i 
ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il 
ON i.InvoiceId = il.InvoiceId
JOIN Track t 
ON il.TrackId = t.TrackId
JOIN Album alb 
ON t.AlbumId = alb.AlbumId
JOIN Artist art 
ON alb.ArtistId = art.ArtistId
WHERE art.Name = 'Iron Maiden' 
GROUP BY c.FirstName,
		 c.LastName,
		 art.Name
ORDER BY AmountSpent DESC
