SELECT art.ArtistId,
       art.Name, 
       COUNT(*) songs 
FROM Album alb
JOIN Artist art
ON alb.ArtistId = art.ArtistId
JOIN Track t
ON t.AlbumId = alb.AlbumId
JOIN Genre g
ON t.GenreId = g.GenreId
WHERE g.Name = 'Rock'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;