--Advanced Netflix Project

select * from netflix_titles

--Business Problems and Solutions

--1. Count the Number of Movies vs TV Shows
select type,
       count(*) as  num_of_movies
from netflix_titles
group by type

-- 2 Find the Most Common Rating for Movies and TV Shows

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

-- List All Movies Released in a Specific Year (e.g., 2020)
select * 
from netflix_titles
where release_year=2020

-- Find the Top 5 Countries with the Most Content on Netflix

SELECT top 5 LTRIM(RTRIM(value)) AS new_country,count(show_id) as total_content
FROM netflix_titles
CROSS APPLY STRING_SPLIT(country, ',')
group by LTRIM(RTRIM(value))
order by total_content desc;

--Identify the Longest Movie
select * from netflix_titles
where type='movie'
and duration=(select max(duration) from netflix_titles)

 --Find Content Added in the Last 5 Years
 SELECT *
FROM netflix_titles
WHERE TRY_CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());

--Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select * from netflix_titles
where director like  '%Rajiv Chilaka%'

--List All TV Shows with More Than 5 Seasons

SELECT *,
    type,
    CAST(PARSENAME(REPLACE(duration, ' ', '.'), 2) AS INT) AS sessions
FROM netflix_titles
WHERE type = 'TV Show'
  AND CAST(PARSENAME(REPLACE(duration, ' ', '.'), 2) AS INT) > 5;

  --Count the Number of Content Items in Each Genre 
 SELECT LTRIM(RTRIM(value)) AS Genre,count(*) as total_content
FROM netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',')
group by LTRIM(RTRIM(value))

--.Find each year and the average numbers of content release in India on netflix.
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

 --List All Movies that are Documentaries

 select * from netflix_titles
select * from netflix_titles
where type='Movie' and listed_in='Documentaries'

--12. Find All Content Without a Director
select * from netflix_titles
where director is null;

-- Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix_titles
WHERE cast LIKE '%Salman Khan%'
  AND release_year > YEAR(GETDATE()) - 10;

  --14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT top 10 LTRIM(RTRIM(value)) AS actors,count(*)  as num_of_movies
FROM netflix_titles
CROSS APPLY STRING_SPLIT(cast, ',')
where country like 'india'
group by LTRIM(RTRIM(value))
order by num_of_movies desc

--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.Create a column category with f=good_content and bad_content
with ctc as(SELECT *,
case when description like '%kill%'or description like '%Violence%' then 'good_content' 
else 'bad_content' end as category
from netflix_titles)
select category,count(*) as total_content
from ctc
group by category
