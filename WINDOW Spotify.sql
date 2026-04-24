Use tarun;


--  Find the top 3 tracks within each album
-- type .Ties get the same rank - no one is unfairy
-- skipped.

SELECT  artist_name ,
track_name ,
album_type , 
track_popularity , 
dense_rank_position
FROM (
       SELECT 
            track_name,
            artist_name,
            album_type,
            track_popularity,
            DENSE_RANK() OVER(
               PARTITION BY album_type
               ORDER BY track_popularity DESC
	) AS dense_rank_position
    FROM spotify
) AS ranked_tracks
WHERE dense_rank_position <=3
ORDER BY album_type , dense_rank_position;


--  Artist Ordered popularity filter to each artist's
-- top 2 tracks only 

SELECT artist_name,
track_name,
track_popularity,
row_num
FROM (
       SELECT artist_name ,
       track_name,
       track_popularity,
       ROW_NUMBER() OVER(
            PARTITION BY artist_name 
            ORDER BY track_popularity DESC 
		) AS row_num
       FROM spotify
       ) AS numbered_tracks
       WHERE row_num <= 2
       ORDER BY artist_name , row_num;

--  Fetch each artist previous track popularity -
-- Then compute the change between consecutive 
-- releases 

SELECT artist_name ,
track_name,
album_release_date,
track_popularity,
previous_track_popularity,
popularity_change
FROM (
      SELECT artist_name ,
      track_name,
      album_release_date,
      track_popularity,
      
      LAG(track_popularity) OVER(
        PARTITION BY artist_name
        ORDER BY album_release_date
        ) AS previous_track_popularity,
        
        track_popularity - 
        LAG(track_popularity) OVER (
        PARTITION BY artist_name 
        ORDER BY album_release_date
        ) AS popularity_change
FROM spotify
) AS lag_tracks
WHERE popularity_change IS NOT NULL
ORDER BY artist_name , album_release_date;


--  Peak at the next track in each album - label
-- each transition as Rising , Falling , Or Final
-- Track.

SELECT track_name,
track_number ,
track_popularity,
next_track_popularity,
momentum
FROM (
     SELECT 
     track_name,
     track_number,
     album_name,
     track_popularity,
     
     LEAD(track_name) OVER(
        PARTITION BY album_name
        ORDER BY track_number
        ) AS next_track_name,
        
        LEAD(track_popularity) OVER(
        PARTITION BY album_name
        ORDER BY track_number
        ) AS next_track_popularity,
        
        CASE 
          WHEN LEAD(track_popularity) OVER(
          PARTITION BY album_name 
          ORDER BY track_number 
          ) > track_popularity
          THEN 'Rising'
          WHEN LEAD(track_popularity) OVER(
                PARTITION BY album_name
                ORDER BY track_number
		 ) IS NULL
         THEN 'Final Track'
         ELSE 'Flat'
	END              AS momentum
    FROM spotify
    ) AS lead_tracks
ORDER BY album_name , track_number;  
        
        
--  Running total of tracks popularity per
-- artist ordered by release date.

SELECT artist_name ,
track_name ,
album_release_date,
track_popularity,
SUM(track_popularity) OVER(
     PARTITION BY artist_name
     ORDER BY album_release_date
     ROWS BETWEEN UNBOUNDED PRECEDING 
     AND CURRENT ROW 
     ) AS  cumulative_popularity
FROM spotify
WHERE artist_name IN (
      SELECT artist_name 
      FROM spotify 
      GROUP BY artist_name
      ORDER BY COUNT(*) DESC
      LIMIT 5
)
ORDER BY artist_name , album_release_date;


--  Compare each track to its own album average
-- without GROUP BY collapsing rowws.

SELECT 
    track_name,
    artist_name,
    album_name,
    track_popularity,
    ROUND(AVG(track_popularity) OVER (
        PARTITION BY album_name
    ), 2)                               AS album_avg_popularity,
    ROUND(track_popularity - AVG(track_popularity) OVER (
        PARTITION BY album_name
    ), 2)                               AS difference,
    CASE 
        WHEN track_popularity > AVG(track_popularity) OVER (
            PARTITION BY album_name
        ) THEN 'Above Album Average'
        WHEN track_popularity < AVG(track_popularity) OVER (
            PARTITION BY album_name
        ) THEN 'Below Album Average'
        ELSE 'Exactly Average'
    END                                 AS performance_label
FROM spotify
ORDER BY album_name, track_popularity DESC;


--  Global rank , category rank and follower share
-- all at once

SELECT 
    artist_name,
    album_type,
    ROUND(AVG(track_popularity), 2)     AS avg_popularity,
    RANK() OVER (
        ORDER BY AVG(track_popularity) 
        DESC
    )                                   AS global_rank,
    RANK() OVER (
        PARTITION BY album_type
        ORDER BY AVG(track_popularity) 
        DESC
    )                                   AS rank_in_album_type,
    ROUND(MAX(artist_followers) * 100.0 /
          SUM(MAX(artist_followers)) OVER()
    , 2)                                AS follower_share_pct
FROM spotify
GROUP BY artist_name, album_type
ORDER BY global_rank;
        




