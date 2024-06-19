-- Lab | Aggregation Revisited - Subqueries
-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.
USE sakila;
SELECT DISTINCT first_name, last_name, email
FROM customer 
JOIN rental
USING (customer_id);

-- con natural join: 
SELECT *
FROM customer 
NATURAL JOIN rental;

-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT customer.customer_id, CONCAT (customer.first_name, "_", customer.last_name), AVG(payment.amount)
FROM customer
JOIN payment
ON payment.customer_id=customer.customer_id
GROUP BY customer_id;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements
SELECT DISTINCT customer.first_name, customer.email, category.name -- Añadiendo distinct obtengo el mismo resultado que con subqueries porque un mismo cliente alquila action films mas de una vez
FROM customer
JOIN rental
ON customer.customer_id=rental.customer_id
JOIN inventory
ON rental.inventory_id=inventory.inventory_id
JOIN film 
ON inventory.film_id=film.film_id
JOIN film_category
ON film.film_id=film_category.film_id
JOIN category
ON category.category_id=film_category.category_id
AND category.name = "Action";

-- Write the query using sub queries with multiple WHERE clause and IN condition
USE sakila;

SELECT customer.first_name, customer.email
FROM customer
WHERE customer.customer_id IN (
    SELECT rental.customer_id
    FROM rental
    WHERE rental.inventory_id IN (
        SELECT inventory.inventory_id
        FROM inventory
        WHERE inventory.film_id IN (
            SELECT film.film_id
            FROM film
            WHERE film.film_id IN (
                SELECT film_category.film_id
                FROM film_category
                WHERE film_category.category_id = (
                    SELECT category.category_id
                    FROM category
                    WHERE category.name = 'Action'
                )
            )
        )
    )
);

-- Verify if the above two queries produce the same results or not --> con el distinc si

-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
USE sakila;

SELECT 
    customer.first_name, 
    customer.email, 
    payment.amount,
    CASE 
        WHEN payment.amount BETWEEN 0 AND 2 THEN 'low'
        WHEN payment.amount BETWEEN 2 AND 4 THEN 'medium'
        WHEN payment.amount > 4 THEN 'high'
        ELSE 'unknown' -- Optional: to handle any unexpected cases
    END AS transaction_value
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id;




