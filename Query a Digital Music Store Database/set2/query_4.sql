--Use your query to return the email, first name, last name, and Genre of all Rock Music listeners. Return your list ordered 
--alphabetically by email address starting with A. Can you find a way to deal with duplicate email addresses so no one receives multiple emails?
SELECT c.Email,
       c.FirstName, 
	   c.LastName, 
	   g.Name
FROM Customer c
JOIN Invoice  i
ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il
ON i.InvoiceId = il.InvoiceId
JOIN Track t
ON il.TrackId = t.TrackId
JOIN Genre g
ON t.GenreId = g.GenreId
--WHERE g.Name = 'classical'
WHERE g.Name = 'Rock'
GROUP BY 1,2
ORDER BY 2 