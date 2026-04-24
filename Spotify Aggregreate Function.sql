USE tarun;

-----------------------------------
-- SPOTIFY DATASET TABLE
-----------------------------------


ALTER TABLE `spotify_data clean`
RENAME TO spotify;


SELECT * FROM `spotify_data clean`;

-- How many unique artists are in the dataset 

SELECT COUNT(DISTINCT artist_name ) 
FROM `spotify_data clean`;

-- What is the average track popularity across all
-- tracks

SELECT AVG(track_popularity) AS Popular 
FROM `spotify_data clean` ;

-- What is the longest and shortest track duration 
-- in the dataset

SELECT MAX(track_duration_min) AS Longest,
MIN(track_duration_min) AS Shortest
FROM spotify;

-- Artist with  Maximum Follewer

SELECT  artist_name ,SUM(artist_followers) AS MAX_Follower
FROM spotify
GROUP BY artist_name
ORDER BY MAX_Follower DESC
LIMIT 10;

-- Which album type(single , album,compilation) has
-- the highest average track popularity

SELECT album_type , AVG(track_popularity) AS Pop
FROM spotify 
GROUP BY album_type;

-- Artist with more album

SELECT artist_name , COUNT(album_type) AS Abl
FROM spotify
GROUP BY artist_name
ORDER BY Abl DESC ;

-- Artist with more than 5 tracks 

SELECT artist_name , COUNT(track_number) AS Cnt
FROM spotify 
GROUP BY artist_name 
HAVING Cnt > 5 
ORDER BY Cnt DESC;

-- Atrist name with how many genre

SELECT artist_name , COUNT(artist_genres) AS Gn
FROM spotify
GROUP BY artist_name
ORDER BY Gn DESC;

-- Write the SQL query for: Find genres where the average artist popularity is above 
-- 70, ordered by average popularity descending.

SELECT artist_name , AVG(artist_popularity) AS P
FROM spotify
GROUP BY artist_name
HAVING AVG(artist_popularity) > 70
ORDER BY P DESC;

-- Write the SQL query for: For each release year,
-- count how many tracks were released and
--  find the average track popularity. 
-- Only show years with more than 10 tracks.

SELECT YEAR(album_release_date) AS Ry , 
COUNT(*),
AVG(track_popularity) 
FROM spotify
GROUP BY album_release_date
HAVING COUNT(*) >= 10
ORDER BY Ry DESC ;


 

