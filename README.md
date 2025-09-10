# Netflix Movies and TV Shows Data Analysis using SQL

![]((https://github.com/Eshwarthota2219/NETFLIX_SQL_PROJECT_3/blob/main/logo.webp))

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select type,
       count(*) as  num_of_movies
from netflix_titles
group by type

```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT type, rating
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count,
        RANK() OVER (
            PARTITION BY type 
            ORDER BY COUNT(*) DESC
        ) AS rank_1
    FROM netflix_titles
    GROUP BY type, rating
) AS t1
WHERE rank_1 = 1;

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select * 
from netflix_titles
where release_year=2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SSELECT top 5 LTRIM(RTRIM(value)) AS new_country,count(show_id) as total_content
FROM netflix_titles
CROSS APPLY STRING_SPLIT(country, ',')
group by LTRIM(RTRIM(value))
order by total_content desc;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select * from netflix_titles
where type='movie'
and duration=(select max(duration) from netflix_titles)
;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
 SELECT *
FROM netflix_titles
WHERE TRY_CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());
';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
Sselect * from netflix_titles
where director like  '%Rajiv Chilaka%'
';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *,
    type,
    CAST(PARSENAME(REPLACE(duration, ' ', '.'), 2) AS INT) AS sessions
FROM netflix_titles
WHERE type = 'TV Show'
  AND CAST(PARSENAME(REPLACE(duration, ' ', '.'), 2) AS INT) > 5;;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
 SELECT LTRIM(RTRIM(value)) AS Genre,count(*) as total_content
FROM netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',')
group by LTRIM(RTRIM(value))
;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT 
    YEAR(TRY_CONVERT(date, date_added, 107)) AS year_added,
    COUNT(show_id) AS titles_added,
    ROUND(
        COUNT(show_id) * 100.0 / 
        (SELECT COUNT(show_id) FROM netflix_titles WHERE country LIKE '%India%'),
        2
    ) AS avg_release_percent
FROM netflix_titles
WHERE country LIKE '%India%'
  AND date_added IS NOT NULL
GROUP BY YEAR(TRY_CONVERT(date, date_added, 107))
ORDER BY year_added;
;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
S select * from netflix_titles
select * from netflix_titles
where type='Movie' and listed_in='Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix_titles
WHERE cast LIKE '%Salman Khan%'
  AND release_year > YEAR(GETDATE()) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT top 10 LTRIM(RTRIM(value)) AS actors,count(*)  as num_of_movies
FROM netflix_titles
CROSS APPLY STRING_SPLIT(cast, ',')
where country like 'india'
group by LTRIM(RTRIM(value))
order by num_of_movies desc
;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
with ctc as(SELECT *,
case when description like '%kill%'or description like '%Violence%' then 'good_content' 
else 'bad_content' end as category
from netflix_titles)
select category,count(*) as total_content
from ctc
group by category
;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Thota Eshwar

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!



- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/eshwar-thota-162a08327/)
--**email**:[Connect with me professionally](eshwarthota2211@gmail.com)

Thank you for your support, and I look forward to connecting with you!
