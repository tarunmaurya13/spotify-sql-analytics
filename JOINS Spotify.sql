-- -------------------------------------------------
-- JOINS 

-- -------------------------------------------------------------

USE tarun;

--   Tracks from artists who 
-- have BOTH albums AND singles

-- t1 = 'Full tracklist'
-- t2 = 'Artist album'
-- t3 = 'Artist with single'

SELECT t1.track_name,
t1.artist_name,
t1.album_type,
t1.track_popularity AS total_pop
FROM spotify t1
INNER JOIN (
SELECT DISTINCT artist_name
FROM spotify
WHERE album_type = 'album'
) t2 ON t1.artist_name = t2.artist_name
INNER JOIN (
SELECT DISTINCT artist_name
FROM spotify
WHERE album_type = 'single'
)t3 ON t1.artist_name = t3.artist_name
ORDER BY total_pop DESC;

--   Dominant artists: consistently popular AND well-followed

SELECT 
    artist_name,
    COUNT(DISTINCT track_name) AS total_tracks,
    ROUND(AVG(track_popularity), 2) AS avg_track_pop,
    MAX(artist_popularity) AS artist_pop,
    MAX(artist_followers) AS followers,
    -- "Hit rate": what % of tracks are above median?
    ROUND(100.0 * SUM(CASE WHEN track_popularity > 
        (SELECT AVG(track_popularity) FROM spotify) 
        THEN 1 ELSE 0 END) / COUNT(*), 2) AS hit_rate_pct
FROM spotify
GROUP BY artist_name
HAVING AVG(track_popularity) > (SELECT AVG(track_popularity) FROM spotify)
AND MAX(artist_followers) > (SELECT AVG(artist_followers) FROM spotify)
ORDER BY avg_track_pop DESC, followers DESC; 

-- Show album where one track has zero popularity

SELECT
t1.album_name,
t1.album_type,
t1.artist_name,
COUNT(*) AS total_track,
SUM(CASE WHEN t1.track_popularity = 0
    THEN 1 ELSE 0 END) AS zero_pop
FROM spotify t1
LEFT JOIN (
SELECT DISTINCT album_name
FROM spotify
WHERE track_popularity  = 0 
)t2 ON t1.album_name = t2.album_name
WHERE t2.album_name IS NOT NULL
GROUP BY 
t1.album_name,
t1.album_type,
t1.artist_name
HAVING SUM(CASE WHEN t1.track_popularity = 0
            THEN 1 ELSE 0 END)>= 1
ORDER BY zero_pop DESC;  

--    

SELECT 
    t1.album_type                         AS album_type_1,
    t2.album_type                         AS album_type_2,
    ROUND(t1.avg_popularity, 2)           AS avg_popularity_1,
    ROUND(t2.avg_popularity, 2)           AS avg_popularity_2,
    ROUND(ABS(t1.avg_popularity - 
              t2.avg_popularity), 2)      AS popularity_difference
FROM (
    SELECT 
        album_type,
        AVG(track_popularity)             AS avg_popularity
    FROM spotify
    GROUP BY album_type
) t1
CROSS JOIN (
    SELECT 
        album_type,
        AVG(track_popularity)             AS avg_popularity
    FROM spotify
    GROUP BY album_type
) t2

-- Remove mirror pairs (album vs album)
-- and duplicate pairs (A vs B = B vs A)
WHERE t1.album_type < t2.album_type
ORDER BY popularity_difference DESC;  

    

