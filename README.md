# spotify-query-lab
A hands-on SQL case study dissecting Spotify's music catalog — from basic aggregates to advanced window functions



# 🎵 spotify-sql-analytics

> A structured SQL project analyzing Spotify track, artist, and album data using aggregate functions, JOINs, subqueries, and window functions — built as a progressive learning portfolio.

---

## 📌 Project Description

This project uses a cleaned Spotify dataset (`spotify_data_clean.csv`) to explore real-world SQL concepts through a storytelling approach. Every query is framed as a business problem — solved by a Spotify analyst, A&R team, data scientist, or growth strategist — making the SQL feel purposeful rather than academic.

The project is organized into four progressive layers of SQL complexity, from basic aggregation all the way to advanced window functions with CTEs and multi-partition analysis.




## 🗄️ Dataset Overview

| Column | Type | Description |
|---|---|---|
| `track_id` | text | Unique track identifier |
| `track_name` | text | Name of the track |
| `track_number` | int | Track position in the album |
| `track_popularity` | int | Spotify popularity score (0–100) |
| `explicit` | text | Whether the track is explicit (TRUE/FALSE) |
| `artist_name` | text | Name of the artist |
| `artist_popularity` | int | Spotify artist popularity score |
| `artist_followers` | int | Total followers of the artist |
| `artist_genres` | text | Genre tags associated with the artist |
| `album_id` | text | Unique album identifier |
| `album_name` | text | Name of the album |
| `album_release_date` | text | Release date (YYYY-MM-DD format) |
| `album_total_tracks` | int | Total number of tracks in the album |
| `album_type` | text | Type: album / single / compilation |
| `track_duration_min` | double | Track length in minutes |

> **Table name used throughout:** `spotify`
> **Database:** MySQL (MySQL Workbench 8.x)

---

## 📚 SQL Concepts Covered

### 1. Aggregate Functions
- `COUNT`, `COUNT(DISTINCT ...)`, `AVG`, `SUM`, `MAX`, `MIN`
- `GROUP BY` with multiple columns
- `HAVING` vs `WHERE` — filtering before and after aggregation
- `ROUND()` for clean numeric output
- `CASE WHEN` inside aggregates for conditional counting
- Nested subqueries inside `HAVING`

**Sample questions:**
- How many unique artists are in the dataset?
- Which genres have an average artist popularity above 70?
- For each release year, how many tracks were released and what was the average popularity?

---

### 2. JOINs
- `INNER JOIN` with derived tables as filter gates
- `LEFT JOIN` with `IS NOT NULL` pattern for existence checks
- `SELF JOIN` to compare rows within the same table
- `CROSS JOIN` for all-vs-all comparisons
- Multi-era analysis using two derived tables joined on genre

**Sample questions:**
- Find artists who have released both albums and singles (INNER JOIN)
- Identify albums with at least one zero-popularity track (LEFT JOIN)
- Compare every album type against every other album type (CROSS JOIN)
- Classic artists (pre-2000) vs modern artists (post-2020) by genre (era JOIN)

---

### 3. Subqueries
- Scalar subqueries in `WHERE`, `HAVING`, and `SELECT`
- `IN` and `NOT IN` with subquery lists
- Correlated subqueries (reference outer query row)
- `EXISTS` and `NOT EXISTS` for presence/absence checks
- Subqueries in `FROM` as derived tables
- CTE (`WITH`) as a readable alternative to nested subqueries

**Sample questions:**
- Find tracks above the dataset average popularity (scalar subquery)
- Artists who have never released an explicit track (NOT IN)
- Each artist's crown jewel — most popular track (correlated subquery)
- Tier artists into Platinum / Gold / Silver / Bronze (subquery in FROM + CASE WHEN)

---

### 4. Window Functions
- `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` with and without `PARTITION BY`
- `LAG()` and `LEAD()` for previous/next row access
- `SUM() OVER` for running totals
- `AVG() OVER` for moving averages with `ROWS BETWEEN`
- `NTILE(N)` for equal bucket distribution
- `PERCENT_RANK()` for percentile scoring
- Multiple window functions combined in a single CTE pipeline

**Sample questions:**
- Hall of Fame leaderboard — top 3 tracks per album type (DENSE_RANK)
- Each artist's top 2 tracks (ROW_NUMBER + filter)
- Track-by-track popularity change over an artist's career (LAG)
- Album sneak peek — what plays next and is momentum rising? (LEAD)
- Cumulative career popularity meter (SUM OVER running total)
- Track vs its own album average — without GROUP BY collapsing rows (AVG OVER)
- Ultimate artist scorecard — global rank + category rank + follower share (combined windows)

---

## 🔑 Key SQL Patterns Demonstrated

```sql
-- Pattern 1: HAVING with nested subquery
HAVING AVG(artist_popularity) > (SELECT AVG(artist_popularity) FROM spotify)

-- Pattern 2: LEFT JOIN + IS NOT NULL (existence filter)
LEFT JOIN (...) t2 ON t1.album_name = t2.album_name
WHERE t2.album_name IS NOT NULL

-- Pattern 3: Window function on grouped data
GROUP BY artist_name
...RANK() OVER (ORDER BY AVG(track_popularity) DESC)

-- Pattern 4: Running total with explicit frame
SUM(track_popularity) OVER (
    PARTITION BY artist_name
    ORDER BY album_release_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)

-- Pattern 5: Three benchmarks in one query
AVG(track_popularity) OVER (PARTITION BY album_name)   -- album avg
AVG(track_popularity) OVER (PARTITION BY artist_name)  -- artist avg
AVG(track_popularity) OVER ()                          -- dataset avg
```

---

## 🚀 How to Run

1. Import `data/spotify_data_clean.csv` into your MySQL database
2. Rename the table if needed:
```sql
ALTER TABLE `spotify_data clean` RENAME TO spotify;
```
3. Run queries from the `sql/` folder in order — each file builds on the previous concepts
4. All queries are written for **MySQL 8.x** and tested in **MySQL Workbench**

---

## 💡 Project Highlights

- Every query is framed as a real-world **business story** — not just syntax practice
- Queries progressively build from single aggregates to multi-CTE window function pipelines
- Each concept includes a **basic version** (readable) and an **extended version** (production-grade)
- Special attention to **edge cases**: `NULLIF` for divide-by-zero, `IS NOT NULL` filters, `DISTINCT` for de-duplication, and `SUBSTRING` for text-stored dates

---

## 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| MySQL 8.x | Database engine |
| MySQL Workbench | Query editor and schema viewer |
| CSV (cleaned) | Source data |

---

## 👤 Author

**Tarun**
SQL Analytics Project — Spotify Dataset
