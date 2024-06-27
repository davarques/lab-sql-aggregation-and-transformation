USE sakila;

-- Challenge 1: 
-- 1) You need to use SQL built-in functions to gain insights relating to the duration of movies:

-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.

SELECT title, MIN(length) AS min_duration
FROM film
GROUP BY title
ORDER BY min_duration ASC;

SELECT title, MAX(length) AS max_duration
FROM film
GROUP BY title
ORDER BY max_duration DESC;

-- Conclusions(1.1): The shortes films are 46 and longest 185. 

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals.
-- Hint: Look for floor and round functions.

SELECT title, ROUND(AVG(length),0) AS average_length_minutes, ROUND((AVG(length)/60),0) AS average_length_hours
FROM film
GROUP BY title;

-- 2) You need to gain insights related to rental dates:

-- 2.1 Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in 
--       the rental_date column from the latest date.

SELECT MIN(rental_date)
FROM rental;
-- Result: 2005-05-24 22:53:30

SELECT MAX(rental_date)
FROM rental;
-- result: 2006-02-14 15:16:03

SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) AS days_operating
FROM rental;

-- 2.2 Retrieve rental information and add two additional columns to 
-- show the month and weekday of the rental. Return 20 rows of results.

SELECT *, MONTH(rental_date) AS month_rental, DAYOFWEEK(rental_date) AS weekday_rental
FROM rental
LIMIT 20;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
-- Hint: use a conditional expression.

SELECT *, MONTH(rental_date) AS month_rental, DAYOFWEEK(rental_date) AS weekday_rental,
CASE
WHEN DAYOFWEEK(rental_date) BETWEEN 2 AND 6 THEN 'Workday' -- Sunday = 1 
WHEN DAYOFWEEK(rental_date) IN (1,7) THEN 'Weekend'
END AS day_type 
FROM rental
LIMIT 20;

-- 3) You need to ensure that customers can easily access information about the movie collection. 
-- To achieve this, retrieve the film titles and their rental duration. 
-- If any rental duration value is NULL, replace it with the string 'Not Available'. 
-- Sort the results of the film title in ascending order.

-- Please note that even if there are currently no null values in the rental duration column, 
-- the query should still be written to handle such cases in the future.
-- Hint: Look for the IFNULL() function.

-- Checking nulls in 

SELECT SUM(ISNULL(rental_duration))
FROM film; -- Zero nulls in [rental_duration]

-- Querry task 3:
SELECT title, rental_duration, 
CASE 
WHEN rental_duration IS NULL THEN 'Not available'
ELSE rental_duration
END AS rental_duration
FROM film
ORDER BY title ASC;

-- Bonus: The marketing team for the movie rental company now needs to create a personalized email 
-- campaign for customers. To achieve this, you need to retrieve the concatenated first and last names 
-- of customers, along with the first 3 characters of their email address, so that you can address them by 
-- their first name and use their email address to send personalized recommendations. 
-- The results should be ordered by last name in ascending order to make it easier to use the data.

SELECT first_name, last_name, CONCAT(first_name, '  ', last_name) AS full_name, 
SUBSTRING(email, 1, 3) AS email_prefix
FROM customer
ORDER BY last_name ASC;

-- Challenge 2: 
-- Analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.

SELECT COUNT(DISTINCT title)
FROM film;

SELECT SUM(ISNULL(release_year)) FROM film; 
-- No nulls in release_year  

SELECT COUNT(*)
FROM film
WHERE release_year IS NOT NULL;

-- 1.2 The number of films for each rating.

SELECT rating, COUNT(title)
FROM film
GROUP BY rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
-- This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.

SELECT rating, COUNT(title)
FROM film
GROUP BY rating
ORDER BY COUNT(title) DESC;

-- 2) Using the film table, determine:

-- 2.1 The mean film duration for each rating, and sort the results in descending 
-- order of the mean duration. Round off the average lengths to two decimal places. 
-- This will help identify popular movie lengths for each category.

SELECT rating, ROUND(AVG(length),2) AS average_length
FROM film
GROUP BY rating
ORDER BY average_length DESC;

-- 2.2 Identify which ratings have a mean duration of over two hours 
-- in order to help select films for customers who prefer longer movies.

SELECT rating, ROUND(AVG(length),2) AS average_length
FROM film
GROUP BY rating
HAVING average_length > 120
ORDER BY average_length DESC;

-- Bonus: determine which last names are not repeated in the table actor.

SELECT last_name, COUNT(last_name) AS count_last_name
FROM actor
GROUP BY last_name
HAVING count_last_name > 1;

