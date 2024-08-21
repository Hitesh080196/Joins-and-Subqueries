-- 1. **Join Practice:**
--  Write a query to display the customer's first name, last name, email, and city they live in.
select customer.first_name ,customer.last_name ,customer.email,city
      from customer 
                   inner join address on address.address_id = customer.address_id
			       inner join city on city.city_id = address.city_id;


--  2. **Subquery Practice (Single Row):**
--  Retrieve the film title, description, and release year for the film that has the longest duration.
select film.title,film.description,release_year,length from film 
where length = (select max(length) from film);


-- 3. **Join Practice (Multiple Joins):**
-- List the customer name, rental date, and film title for each rental made. Include customers who have never
-- rented a film.
select c.first_name,c.last_name,r.rental_date,f.title
from customer c
           left join rental r on r.customer_id = c.customer_id
           left join inventory i on i.inventory_id = r.inventory_id
           left join film f on f.film_id = i.film_id;


-- 4. **Subquery Practice (Multiple Rows):**
-- Find the number of actors for each film. Display the film title and the number of actors for each film.
select title,count(actor_id) from film 
inner join film_actor on film_actor.film_id=film.film_id
group by title;


-- 5. **Join Practice (Using Aliases):**
-- Display the first name, last name, and email of customers along with the rental date, film title, and rental 
 -- return date.
select first_name,last_name,email,title,rental_date,return_date
from customer 
inner join rental on rental.customer_id = customer.customer_id
inner join inventory on inventory.inventory_id = rental.inventory_id
inner join film on film.film_id = inventory.film_id;



-- 6. **Subquery Practice (Conditional):**
-- Retrieve the film titles that are rented by customers whose email domain ends with '.org'.
select title from film where film_id in (select film_id from inventory 
where store_id in (select store_id from customer where email like "%.org"));


-- 7. **Join Practice (Aggregation):**
-- Show the total number of rentals made by each customer, along with their first and last names.
select c.first_name ,c.last_name, count(rental_id)
from customer c
left join rental on rental.customer_id = c.customer_id
group by c.customer_id;



-- 8. **Subquery Practice (Aggregation):**
-- List the customers who have made more rentals than the average number of rentals made by all customers.
select*from customer;
select first_name 
from customer 
where customer_id in (select customer_id from rental
group by customer_id having count(rental_id) >(
select avg(rental_count) 
from (select count(rental_id) as rental_count from rental group by customer_id) as avg_rentals)
) ;




-- 9. **Join Practice (Self Join):**
-- Display the customer first name, last name, and email along with the names of other customers living in 
-- the same city.
select c.first_name,c.last_name,c.email,city
from customer c
inner join address a on a.address_id = c.address_id
inner join city cy on cy.city_id = a.city_id;



--  10. **Subquery Practice (Correlated Subquery):**
-- Retrieve the film titles with a rental rate higher than the average rental rate of films in the same category.
select title,rental_rate
from film f
inner join film_category fc on fc.film_id=f.film_id
where rental_rate > (
select avg(rental_rate)
from film 
where category_id= fc.category_id);



-- 11. **Subquery Practice (Nested Subquery):**
-- Retrieve the film titles along with their descriptions and lengths that have a rental rate greater than the 
-- average rental rate of films released in the same year.
select title,description,length,rental_rate
from film f 
where rental_rate > (
select avg(rental_rate)
from film
where release_year = f.release_year
);



-- 12. **Subquery Practice (IN Operator):**
-- List the first name, last name, and email of customers who have rented at least one film in the 
-- 'Documentary' category.
select first_name,last_name,email
from customer
where customer_id in(
select distinct c.customer_id
from customer c
inner join rental r on r.customer_id=c.customer_id
inner join inventory i on i.inventory_id=r.inventory_id
inner join film_category fc on fc.film_id=i.film_id
inner join category ca on ca.category_id=fc.category_id
where ca.name = "Documentary"
);



-- 13. **Subquery Practice (Scalar Subquery):**
-- Show the title, rental rate, and difference from the average rental rate for each film.
select title,rental_rate,rental_rate - (select avg(rental_rate) from film) as DIFF from film;


-- 14. **Subquery Practice (Existence Check):**
-- Retrieve the titles of films that have never been rented.
select title from film where film_id not in (select distinct film_id from inventory where film_id is not null);



-- 15. **Subquery Practice (Correlated Subquery - Multiple Conditions):**
-- List the titles of films whose rental rate is higher than the average rental rate of films released in the same 
-- year and belong to the 'Sci-Fi' category.
select title 
from film f
where rental_rate > ( 
select avg(rental_rate) 
from film
where release_year = f.release_year)
and 
film_id in (
select fc.film_id from film_category fc
inner join category c on c.category_id=fc.category_id
where c.name = "Sci-Fi"
);


-- 16. **Subquery Practice (Conditional Aggregation):**
-- Find the number of films rented by each customer, excluding customers who have rented fewer than five films.
select customer_id ,count(rental_id) from rental group by customer_id order by count(rental_id) >= 5;

