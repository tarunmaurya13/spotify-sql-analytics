USE tarun;



--  Find Every track whose popularity beats the 
-- dataset average , and show the track name , 
-- artist,how far above it is.

SELECT 
    track_name,
    artist_name,
    track_popularity,
    (track_popularity - (
        SELECT AVG(track_popularity)
        FROM spotify
    )) AS above_avg
FROM spotify
WHERE track_popularity > (
    SELECT AVG(track_popularity)
    FROM spotify
)
ORDER BY above_avg DESC;

--  Find artists whose avg track popularity beats 
-- the dataset average but whose followers are 
-- below average - the underdogs.

SELECT artist_name,
AVG(track_popularity) AS Track_pop
FROM spotify 
GROUP BY artist_name
HAVING AVG(track_popularity) >
( SELECT AVG(artist_popularity) AS a_pop FROM spotify)

AND AVG(artist_followers) <
(    SELECT AVG(artist_followers) 
FROM spotify)

ORDER BY Track_pop DESC;

--  Find all tracks that belong to album 
-- larger than the average album size.

SELECT 
track_name,
artist_name,
album_name,
album_total_tracks
FROM spotify
WHERE album_name IN (
                SELECT album_name 
                FROM spotify
                GROUP BY album_name 
                HAVING COUNT(*) >(
                   SELECT AVG(album_size)
                   FROM( 
                        SELECT COUNT(*) AS album_size
                        FROM spotify 
                        GROUP BY album_name
                        ) AS album_count
                   )
)

ORDER BY album_total_tracks DESC, album_name;

--  Find each artist most popular track by 
-- comparing each rows to its own artist's max 
-- popularity

SELECT artist_name,
track_name,
album_name ,
track_popularity
FROM spotify s1 
WHERE track_popularity = (
         SELECT MAX(track_popularity) 
         FROM spotify s2
         WHERE s1.artist_name = s2.artist_name
         )
ORDER BY track_popularity DESC; 

--  Flag every track whose popularity falls below
-- the average of its own album.

SELECT s1.track_name,
s1.album_name ,
s1.artist_name,
s1.track_popularity,
(
       SELECT AVG(s2.track_popularity) 
       FROM spotify s2
       WHERE s2.album_name = s1.album_name
       ) AS album_avg_pop
FROM spotify s1
WHERE s1.track_popularity < (
        SELECT AVG(s2.track_popularity)
        FROM spotify s2
        WHERE s2.album_name = s1.album_name
)
ORDER BY s1.track_popularity ASC;        

--   Subquery in From calculates avg popularity ,
-- outer query assign tier labels using CASE WHEN 

SELECT 
artist_name ,
avg_popularity ,
CASE 
    WHEN avg_popularity > 70 THEN 'Platinum'
    WHEN avg_popularity BETWEEN 50 AND 70 THEN 'Gold'
    WHEN avg_popularity BETWEEN 30 AND 50 THEN 'Sil ver'
	ELSE 'Bronze'
END AS tier
FROM (
      SELECT 
      artist_name,
      AVG(track_popularity) AS avg_popularity
      FROM spotify 
      GROUP BY artist_name
  ) AS artist_stats
ORDER BY avg_popularity DESC;  
     
--  Show each artist's avg popularity next to the 
-- overall dataset average and the gap between them.

SELECT artist_name,
AVG(track_popularity) AS avg_t_pop,
(SELECT AVG(track_popularity) 
FROM spotify ) AS overall_avg,
AVG(track_popularity) - 
( SELECT AVG(track_popularity) FROM spotify ) 
AS difference
FROM spotify
GROUP BY artist_name
ORDER BY difference DESC;
