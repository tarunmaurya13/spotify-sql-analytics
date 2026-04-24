# 🎧 Spotify Data Analytics using SQL

> A portfolio-grade SQL project that analyzes Spotify’s music catalog using real-world business scenarios — covering everything from basic aggregates to advanced window functions.

---

## ⚡ Quick Insights (Sample Findings)

* 🎤 Top artists consistently dominate across multiple album types
* 📈 Modern-era artists (post-2020) show higher average popularity growth
* 🔥 Popular tracks are not always from the most-followed artists
* 🎧 Album-level performance varies significantly within the same artist

> Explore full logic inside `/sql/` directory

---

## 📌 Project Overview

This project analyzes a cleaned Spotify dataset using structured SQL queries designed as **real-world business problems**.

Instead of solving isolated questions, each query simulates decisions made by:

* 🎼 A&R teams (artist evaluation)
* 📊 Data analysts (trend insights)
* 🚀 Growth strategists (performance tracking)

The goal is to demonstrate not just SQL syntax, but **analytical thinking and storytelling with data**.

---

## 🗂️ Project Structure

```
spotify-sql-analytics/
│
├── data/
│   └── spotify_data_clean.csv
│
├── sql/
│   ├── 01_aggregates.sql
│   ├── 02_joins.sql
│   ├── 03_subqueries.sql
│   ├── 04_window_functions.sql
│
├── images/ (optional)
│   └── query_outputs/
│
└── README.md
```

---

## 🗄️ Dataset Summary

* 🎵 Tracks, artists, albums
* 📊 Popularity scores (0–100)
* 👥 Artist followers & genres
* 📅 Album release timelines
* ⏱️ Track duration

**Table Name:** `spotify`
**Database:** MySQL 8.x

---

## 📚 SQL Concepts Covered

### 🟢 1. Aggregate Functions (Beginner → Intermediate)

* COUNT, AVG, SUM, MAX, MIN
* GROUP BY (multi-column)
* HAVING vs WHERE
* CASE WHEN inside aggregates
* Nested subqueries

📌 Example:

* Unique artist count
* Avg popularity by genre
* Tracks per release year

---

### 🟡 2. JOINs (Intermediate)

* INNER JOIN
* LEFT JOIN with filtering
* SELF JOIN
* CROSS JOIN
* Multi-table derived joins

📌 Example:

* Artists with albums + singles
* Albums with low-performing tracks
* Genre comparison across eras

---

### 🟡 3. Subqueries (Intermediate → Advanced)

* Scalar subqueries
* Correlated subqueries
* IN / NOT IN
* EXISTS / NOT EXISTS
* CTE (WITH clause)

📌 Example:

* Above-average tracks
* Artist’s most popular song
* Explicit content analysis

---

### 🔴 4. Window Functions (Advanced)

* ROW_NUMBER(), RANK(), DENSE_RANK()
* PARTITION BY
* LAG() / LEAD()
* Running totals (SUM OVER)
* Moving averages
* NTILE(), PERCENT_RANK()

📌 Example:

* Top tracks per category
* Artist ranking leaderboard
* Career growth trends

---

## 🔑 Key SQL Patterns

```sql
-- HAVING with subquery
HAVING AVG(artist_popularity) > (SELECT AVG(artist_popularity) FROM spotify)

-- Running total
SUM(track_popularity) OVER (
  PARTITION BY artist_name
  ORDER BY album_release_date
)

-- Ranking
DENSE_RANK() OVER (
  PARTITION BY album_type
  ORDER BY track_popularity DESC
)
```

---

## 📊 Sample Output (Recommended Add-on)

> Add screenshots in `/images/` folder for better presentation

* Top 3 tracks per album type
* Artist ranking leaderboard
* Running popularity trends

---

## 🧠 Interview-Level Concepts Demonstrated

* Difference between RANK vs DENSE_RANK
* Window functions vs GROUP BY
* Performance of correlated subqueries
* Handling NULLs and edge cases
* Analytical query design

---

## 🚀 How to Run

1. Import dataset:

```sql
LOAD DATA INFILE 'spotify_data_clean.csv'
INTO TABLE spotify;
```

2. Rename table (if needed):

```sql
ALTER TABLE `spotify_data clean` RENAME TO spotify;
```

3. Run SQL files in order:

* Aggregates → Joins → Subqueries → Window Functions

---

## 💡 Project Highlights

* Real-world **business storytelling approach**
* Progressive learning (basic → advanced SQL)
* Clean, readable + optimized queries
* Edge case handling (NULLs, duplicates, filtering)
* Advanced analytics using window functions

---

## 🔮 Future Improvements

* 📊 Power BI / Tableau dashboard
* 🐍 Python (Pandas) version of analysis
* 🌐 API-based real-time Spotify data
* 📈 Advanced KPI dashboards

---

## 🛠️ Tools Used

| Tool            | Purpose         |
| --------------- | --------------- |
| MySQL 8.x       | Database        |
| MySQL Workbench | Query execution |
| CSV Dataset     | Data source     |

---

## 👤 Author

**Tarun Maurya**
BCA Student | Aspiring Data Analyst

* 💻 SQL | Data Analytics
* 📊 Interested in real-world data storytelling
* 🚀 Building portfolio projects for data roles

---

## ⭐ Final Note

This project is not just about SQL queries — it’s about:

> **Turning raw data into meaningful insights using structured thinking.**

If you found this useful, consider giving it a ⭐ on GitHub!

