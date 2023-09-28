**MERGING DATASET** --MERGE THE SPLIT DATASET INTO ONE

CREATE TABLE appleStore_description_combined As

SELECT * FROM appleStore_description1

union ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

Union ALL

SELECT * FROM appleStore_description4


**EXPLORATORY DATA ANALYSIS**

--CHECK FOR THE NUMBER OF UNIQUE APPS

SELECT COUNT(DISTINCT id) AS uniqueAppids
FROM AppleStore

SELECT COUNT(DISTINCT id) AS uniqueAppids
FROM appleStore_description_combined

--Check for missing values in key fields

SELECT count(*)
FROM AppleStore
WHERE track_name is NULL OR user_rating is NULL or prime_genre is null

SELECT count(*)
FROM appleStore_description_combined
WHERE app_desc is NULL

--find out number of apps per genre

SELECT prime_genre, count(*) as numApps
from AppleStore
group by prime_genre
order by numApps Desc

--Get an overview of Apps ratings

Select min(user_rating) as MinUserRating, 
       max(user_rating) as MaxUserRating, 
       avg(user_rating) as AvgUserRating
FROM AppleStore

--Get the Distribution of app prices

select (price / 2) *2 AS PriceminStart,
       ((price / 2) *2) +2 AS PriceminEnd,
       count(*) as NumApps
FROM AppleStore

Group by PriceminStart
order by PriceminStart

**Data Analysis**

--Determine whether paid apps have higher ratings than free apps

SELECT CASE
             when price > 0 THEN "paid"
             ELSE "free"
             End as App_type,
             avg(user_rating) as AvgUserRating
FROM AppleStore
GROUP by App_type

--Check if apps with more supported languages have higher ratings

SELECT CASE
             when lang_num < 10 THEN "<10 languages"
             when lang_num BETWEEN 10 and 30 THEN "10-30 languages"
             ELSE "<30 languages"
             End as language_bucket,
             avg(user_rating) as AvgRating
FROM AppleStore
GROUP by language_bucket
order by AvgRating Desc

--find genres with low ratings

SELECT prime_genre, avg(user_rating) as AvgRating
from AppleStore
group by prime_genre
order by AvgRating asc
LIMIT 10

--Correlation between user rating and length of app description

SELECT CASE
             when length(b.app_desc) <500 THEN "short"
             when length(b.app_desc) BETWEEN 500 AND 1000 THEN "medium"
             Else "long"
       end as descriptionLengthBucket,
       avg(a.user_rating) as AvgRating

from AppleStore as a
join appleStore_description_combined as b
on a.id = b.id
GROUP by descriptionLengthBucket
order by AvgRating desc

--Check top rated apps for each genre

Select 
		prime_genre, 
        track_name, 
        user_rating
from ( SELECT 
      prime_genre, 
      track_name, 
      user_rating, 
      RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating dESC, rating_count_tot desc) 
      As rank
      FROM AppleStore
      ) AS a 
WHERE a.rank = 1

**Insights & Recommendations**

--1. paid apps have better ratings than free apps. paid apps seem to add more value.
--2. apps supporting between 10 and 30 languages have better ratings. longer languages 
--   are not really relevant.
--3. finance and books app have lower ratings and maybe need higher concentration. users will 
--   appreciate better apps in this category.
--4. apps with longer a description have better ratings. users appreciate having a clear
--   understanding of the app capabilities and features.
--5. a new app should aim for an average rating of 3.5 or higher to stand out from the crowd
--6. games and entertainment apps have high user ratings suggesting the market might be saturated
---  entering this spaces might be challenging due to higher competition and suggests also a high 
--   user demand