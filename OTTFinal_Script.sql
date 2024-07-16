-- create database OTTCaseStudy_db;
-- use OTTCaseStudy_db;
-- Importing the data
create table TVShow_Data(
ID int,
Title varchar(50),
Year int,
Age varchar(50),
IMDb double,
Rotten_Tomatoes int,
Netflix int,
Hulu int,
Prime_video int,
Disney int,
Type int
);

create table Movie_Data(
ID int,
Title varchar(50),
Year int,
Age varchar(50),
IMDb double,
Rotten_Tomatoes double,
Netflix int,
Hulu int,
Prime_video int,
Disney int,
Type int,
Directors varchar(100),
Genres varchar(100),
country varchar(50),
Language varchar(100),
Runtime int
);
-- knowing the dataset
describe Movie_Data; -- movie dataset has few extra columns
describe TVShow_Data;

-- counting how many distinct values are there in the dataset
-- for movie database
select count(distinct ID) as total_count-- for movie dataset
from Movie_Data
where ID is not null ; -- 16744 not null and unique values
-- for tv show database
select count(distinct ID) as total_count-- for TVShow dataset
from TVShow_Data
where ID is not null; -- 5368 not null and unique values

-- reviewing the dataset
select * from Movie_Data limit 10;
select * from TVShow_Data limit 10;

-- 1. IDENTIFY QUANTITY OF THE CONTENT OFFERED BY EACH PLATFORM
-- total number of TV shows released on each platform
select sum(if(netflix=1,1,0)) as netflix_count, -- Netflix has most no of show releases
sum(if(Prime_video=1,1,0)) as Prime_count,
sum(if(Disney=1,1,0)) as Disney_count,
sum(if(Hulu=1,1,0)) as Hulu_count
from TVShow_Data;
-- total number of Movies released on each platform
select sum(if(netflix=1,1,0)) as netflix_count, -- Prime has most no of movie releases
sum(if(Prime_video=1,1,0)) as Prime_count,
sum(if(Disney=1,1,0)) as Disney_count,
sum(if(Hulu=1,1,0)) as Hulu_count
from Movie_Data;

-- 2. PLATFORM WISE EXCLUSIVE CONTENT
-- FOR MOVIES
with cte1 as(select count(*) as Netflix_count -- movies only released on Netflix
from Movie_Data
where Netflix=1 and 
title not in(select title
from Movie_Data
where Prime_video=1 or Disney=1 or Hulu=1)),
cte2 as(select count(*) as prime_count -- movies only released on Prime
from Movie_Data
where Prime_video=1  and 
title not in(select title
from Movie_Data
where Netflix=1 or Disney=1 or Hulu=1)),-- movies only released on Disney+
cte3 as(select count(*) as Disney_count
from Movie_Data
where Disney=1  and 
title not in(select title
from Movie_Data
where Netflix=1 or Prime_video=1 or Hulu=1)),
cte4 as(select count(*) as Hulu_count -- Movies only released on hulu
from Movie_Data
where Hulu=1  and 
title not in(select title
from Movie_Data
where Netflix=1 or Prime_video=1 or Disney=1))
select * from cte1 join cte2 join cte3 join cte4;

-- FOR TV shows
with cte1 as(select count(*) as Netflix_count -- movies only released on Netflix
from TVShow_Data
where Netflix=1 and 
title not in(select title
from TVShow_Data
where Prime_video=1 or Disney=1 or Hulu=1)),
cte2 as(select count(*) as prime_count -- movies only released on Prime
from TVShow_Data
where Prime_video=1  and 
title not in(select title
from TVShow_Data
where Netflix=1 or Disney=1 or Hulu=1)),-- movies only released on Disney+
cte3 as(select count(*) as Disney_count
from TVShow_Data
where Disney=1  and 
title not in(select title
from TVShow_Data
where Netflix=1 or Prime_video=1 or Hulu=1)),
cte4 as(select count(*) as Hulu_count -- Movies only released on hulu
from TVShow_Data
where Hulu=1  and 
title not in(select title
from TVShow_Data
where Netflix=1 or Prime_video=1 or Disney=1))
select * from cte1 join cte2 join cte3 join cte4;

-- 2. platformwise average ratings
-- platform wise average ratings for Movies
select "NETFLIX" as Platform, ROUND(AVG(IMDb*10)) as IMDbavg_rating,
ROUND(AVG(Rotten_Tomatoes*100)) as RTAvg_Rating
from Movie_Data
where Netflix=1
union
select "PRIME" as Platform, ROUND(AVG(IMDb*10)) as IMDbavg_rating,
ROUND(AVG(Rotten_Tomatoes*100)) as RTAvg_Rating
from Movie_Data
where Prime_video=1
union
select "DISNEY+" as Platform, ROUND(AVG(IMDb*10)) as IMDbavg_rating,
ROUND(AVG(Rotten_Tomatoes*100)) as RTAvg_Rating
from Movie_Data
where Disney=1
union
select "HULU" as Platform, ROUND(AVG(IMDb*10)) as IMDbavg_rating,
ROUND(AVG(Rotten_Tomatoes*100)) as RTAvg_Rating
from Movie_Data
where Hulu=1;

-- Platform_wise AVG rating for TV shows
select "NETFLIX" as Platform, ROUND(AVG(IMDb*10)) as IMDbavg_rating,
ROUND(AVG(Rotten_Tomatoes)) as RTAvg_Rating
from TVShow_Data
where Netflix=1
union
select "PRIME" as Platform, ROUND(AVG(IMDb*10)) as IMDbavg_rating,
ROUND(AVG(Rotten_Tomatoes)) as RTAvg_Rating
from TVShow_Data
where Prime_video=1
union
select "DISNEY+" as Platform, ROUND(AVG(IMDb*10)) as IMDbavg_rating,
ROUND(AVG(Rotten_Tomatoes)) as RTAvg_Rating
from TVShow_Data
where Disney=1
union
select "HULU" as Platform, ROUND(AVG(IMDb*10)) as IMDbavg_rating,
ROUND(AVG(Rotten_Tomatoes)) as RTAvg_Rating
from TVShow_Data
where Hulu=1;

-- 3. IDENTIFY QUANTITY OF THE TOP RATED CONTENT OFFERED BY EACH PLATFORM
-- patforms with high IMDB rated movies
select sum(if(netflix=1,1,0)) as netflix_count, -- Prime has most High Rated movies
sum(if(Prime_video=1,1,0)) as Prime_count,
sum(if(Disney=1,1,0)) as Disney_count,
sum(if(Hulu=1,1,0)) as Hulu_count
from Movie_Data
where IMDb>=8.0;
-- patforms with high IMDB rated TV shows
select sum(if(netflix=1,1,0)) as netflix_count, -- Netflix has most High rated shows
sum(if(Prime_video=1,1,0)) as Prime_count,
sum(if(Disney=1,1,0)) as Disney_count,
sum(if(Hulu=1,1,0)) as Hulu_count
from TVShow_Data
where IMDb>=8.0;

-- merging two tables for further analysis
-- by creating view
create view OTT_DATA as
with cte as(select ID,Title,Year,Age,IMDb,Rotten_Tomatoes*100 as Rotten_Tomatoes,Netflix,Prime_video, Disney, Hulu, Type
from Movie_Data
union
select ID+16744 as ID,Title,Year,Age,IMDb,Rotten_Tomatoes,Netflix,Prime_video, Disney, Hulu, Type
from TVShow_Data)
select * from cte;


-- 4. IDENTIFY TOP 100 CONTENT
-- top 100 movies
-- ACCORDING TO IMDb
with cte as(select ID, IMDb,Netflix, Prime_video, Disney, Hulu
from Movie_Data
order by IMDb Desc
limit 100)
select sum(if(netflix=1,1,0)) as netflix_total,
sum(if(Prime_video=1,1,0)) as Prime_total,
sum(if(Disney=1,1,0)) as Disney_total,
sum(if(Hulu=1,1,0)) as Hulu_total
from cte;
-- TOP 100 TV SHOWS
-- ACCORDING TO IMDb
with cte as(select ID, IMDb,Netflix, Prime_video, Disney, Hulu
from TVShow_Data
order by IMDb Desc
limit 100)
select sum(if(netflix=1,1,0)) as netflix_total,
sum(if(Prime_video=1,1,0)) as Prime_total,
sum(if(Disney=1,1,0)) as Disney_total,
sum(if(Hulu=1,1,0)) as Hulu_total
from cte;

-- 5. ANALYSING YEARLY TREND
select year, sum(if(netflix=1,1,0)) as netflix_count, -- Prime has most no of content
sum(if(Prime_video=1,1,0)) as Prime_count,
sum(if(Disney=1,1,0)) as Disney_count,
sum(if(Hulu=1,1,0)) as Hulu_count
from ott_data
group by year
order by 1 desc
limit 10;

-- 6. ANALYSING TARGET AUDIENCE FOR EACH PLATFORM
select age, sum(if(Netflix=1,1,0))as Netflix_cnt, -- for Netflix 18+ content is dominant
sum(if(Prime_video=1,1,0))as Prime_cnt,
sum(if(Disney=1,1,0))as Disney_cnt,
sum(if(Hulu=1,1,0))as Hulu_cnt
from ott_data
where age <> ''
group by age;

-- 7. EXPLORE RATINGS BY GROUP
select age, ROUND(AVG(IMDb)) as IMDb,ROUND(AVG(Rotten_Tomatoes)) as RT
from ott_data
where age<>''
group by age; -- 16+ content is highly rated

-- 8. EXPLORE GENRE PREFFERENCES
with cte as(
with recursive
  unwound as (
    select id,genres,IMDb,Rotten_Tomatoes
      from Movie_Data
    union all
    select id, regexp_replace(Genres, '^[^,]*,', '') as Genres,IMDb,Rotten_Tomatoes
      from unwound
      where Genres like '%,%'
  )
  select id, regexp_replace(Genres, ',.*', '') as Genres,IMDb,Rotten_Tomatoes
    from unwound
    order by id)
select genres, count(*) as total_counts,ROUND(AVG(IMDb)) as IMDb_avg-- ,ROUND(AVG(Rotten_Tomatoes*100)) as RT_avg
from cte
where genres<>''
group by genres
order by 2 desc
LIMIT 5; -- finding genres with higher rating(biography is the highest rated genre)

-- patformwise top 5 most common genres
with cte as(
with recursive
  unwound as (
    select id,genres,netflix,Prime_video,Disney, Hulu
      from Movie_Data
    union all
    select id, regexp_replace(Genres, '^[^,]*,', '') as Genres,netflix, Prime_video,Disney, Hulu
      from unwound
      where Genres like '%,%'
  )
  select id, regexp_replace(Genres, ',.*', '') as Genres,netflix, Prime_video,Disney, Hulu
    from unwound
    order by id)    
select genres,
sum(if(netflix=1,1,0)) as Netflix_counts -- drama is leading
-- sum(if(Prime_video=1,1,0)) as prime_counts -- drama is leading
-- sum(if(Disney=1,1,0)) as Disney_counts -- Family is leading
-- sum(if(Hulu=1,1,0)) as Hulu_counts -- Drama is leading
from cte
where genres<>''
group by genres
order by 2 desc
limit 5 ;

-- 9. REGIONAL INFLUENCE ON RATING
-- EXAMINE LANGUAGE AND COUNTRY PREFFERENCES
-- Platform wise top 10 most popular laguages
with cte as(
with recursive
  unwound as (
    select id,Language,IMDb,netflix, Prime_video,Disney, Hulu
      from Movie_Data
    union all
    select id, regexp_replace(Language, '^[^,]*,', '') as Language,IMDb,netflix, Prime_video,Disney, Hulu
      from unwound
      where Language like '%,%'
  )
  select id, regexp_replace(Language, ',.*', '') as Language,IMDb,netflix, Prime_video,Disney, Hulu
    from unwound
    order by id)    
select Language ,count(*) as total_cnt, ROUND(AVG(IMDb))
-- sum(if(netflix=1,1,0)) as Netflix_counts -- drama is leading
-- sum(if(Prime_video=1,1,0)) as prime_counts -- drama is leading
-- sum(if(Disney=1,1,0)) as Disney_counts -- Family is leading
-- sum(if(Hulu=1,1,0)) as Hulu_counts -- Drama is leading
from cte
where Language<>'' -- and language='english'
group by Language
order by 3 DESC ,2 desc
limit 10;				-- movies releised in regional languages have high IMDb ratings

-- COUNTRY WISE ANALYSIS
-- country influence on rating
with cte as(
with recursive
  unwound as (
    select id,country,IMDb,netflix, Prime_video,Disney, Hulu
      from Movie_Data
    union all
    select id, regexp_replace(country, '^[^,]*,', '') as country,IMDb,netflix, Prime_video,Disney, Hulu
      from unwound
      where country like '%,%'
  )
  select id, regexp_replace(country, ',.*', '') as country,IMDb,netflix, Prime_video,Disney, Hulu
    from unwound
    order by id)    
select distinct country, count(*),ROUND(AVG(IMDb))
-- sum(if(netflix=1,1,0)) as Netflix_counts -- drama is leading
-- sum(if(Prime_video=1,1,0)) as prime_counts -- drama is leading
-- sum(if(Disney=1,1,0)) as Disney_counts -- Family is leading
-- sum(if(Hulu=1,1,0)) as Hulu_counts -- Drama is leading
from cte
where country<>''
group by country
order by 3 desc ,2 DESC
limit 10;

