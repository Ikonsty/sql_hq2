-- 1. From the Terminal, create a database called encyclopedia and connect to it via the the psql console.
-- createdb -U postgres -w encyclopedia
-- psql -U postgres -w -d encyclopedia

	$ createdb encyclopedia
	$ psql -d encyclopedia

-- 2. Create a table called countries. It should have the following columns:
--     An id column of type serial
--     A name column of type varchar(50)
--     A capital column of type varchar(50)
--     A population column of type integer
--
-- The name column should have a UNIQUE constraint.
-- The name and capital columns should both have NOT NULL constraints.

	CREATE TABLE countries (
	    id SERIAL,
	    name VARCHAR(50) UNIQUE NOT NULL,
	    capital VARCHAR(50) NOT NULL,
	    population INT
	);

-- 3.  Create a table called famous_people. It should have the following columns:
--     An id column that contains auto-incrementing values
--     A name column. This should contain a string up to 100 characters in length
--     An occupation column. This should contain a string up to 150 characters in length
--     A date_of_birth column that should contain each person's date of birth in a string of up to 50 characters
--     A deceased column that contains either true or false
--
-- The table should prevent NULL values being added to the name column.
-- If the value of the deceased column is unknown then false should be used.

	CREATE TABLE famous_people (
		id SERIAL UNIQUE
		name VARCHAR(100) NOT NULL,
		occupation VARCHAR(150),
		date_of_birth VARCHAR(50),
		deceased BOOLEAN DEFAULT false
	);
-- 4. Create a table called animals that could contain the sample data below:
-- |name 	        |binomial_name 	    |max_weight_kg 	    |max_age_years 	    |conservation_status
-- ------------------------------------------------------------------------------------------------
-- |Lion 	        |Pantera leo 	    |250 	            |20 	            |VU
-- |Killer Whale 	|Orcinus orca 	    |6,000 	            |60 	            |DD
-- |Golden Eagle 	|Aquila chrysaetos  |6.35 	            |24 	            |LC
--
--     The database table should also contain an auto-incrementing id column.
--     Each animal should always have a name and a binomial name.
--     Names and binomial names vary in length but never exceed 100 characters.
--     The max weight column should be able to hold data in the range 0.001kg to 40,000kg
--     Conservation Status is denoted by a combination of two letters (CR, EN, VU, etc).
--
-- Note:
--     Thousands are separated by a comma, so one thousand is displayed as 1,000.
--     Decimals are separated by a period, so one and a half is displayed as 1.5.
--
--     You could also use varchar for the conservaton_status column.
--     It is quite common to see char used when the length of the string in the column will always be the same.
--     This convention is due to the fact that in some RDBMSes the use of char confers performance advantages,
--     though this is not the case in PostgreSQL.
--
--     For max_weight_kg we need to set two values;
--     the 'precision', which is the total number of digits on both sides of the decimal point,
--     and the 'scale', which is the number of digits to the right of the decimal point.

	CREATE TABLE animals (
		id SERIAL UNIQUE,
		name VARCHAR(100) NOT NULL,
		binomial_name VARCHAR(100) NOT NULL,
		max_weight_kg DECIMAL(8,3),
		max_age_years INT(),
		conservation_status CHAR(2)
	);
-- 5. List all of the tables in the encyclopedia database.

	$ encyclopedia=# \dt

-- 6. Display the schema for the animals table.

	$ encyclopedia=# \d animals

-- 7. Rename the famous_people table to celebrities.

	ALTER TABLE famous_people
	RENAME TO celebrities;

-- 8. Change the name of the name column in the celebrities table to first_name, and change its data type to varchar(80).
-- The order in which you execute the statements isn't important.
	
	ALTER TABLE celebreties
	RENAME COLUMN name TO first_name;
	
	ALTER TABLE celebreties
	MODIFY COLUMN first_name VARCHAR(80);

-- 9. Create a new column in the celebrities table called last_name.
-- It should be able to hold strings of lengths up to 100 characters.
-- This column should always hold a value.
	
	ALTER TABLE celebreties
	ADD last_name VARCHAR(100) NOT NULL;

-- 10. Change the celebrities table so that the date_of_birth column uses a data type that holds
-- an actual date value rather than a string. Also ensure that this column must hold a value.
--
-- Note:
--      When converting data types, if there is no implicit conversion from the old type to the new
--      type you need to add a USING clause to the statement, with an expression that specifies how to compute the
--      new column value from the old. Sometimes these expressions can be quite complex,
--      but a simple form would be something like:
-- Hint:
--      ALTER COLUMN column_name
--          TYPE new_data_type
--          USING column_name::new_data_type
	
	ALTER TABLE celebreties
	ALTER COLUMN date_of_birth
		TYPE DATE
		USING date_of_birth::DATE;

-- 11. Change the animals table so that the binomial_name column cannot contain duplicate values.
-- You will need to use the table constraint form and specify a particular column as part of the constraint clause:
-- Hint:
--      ALTER TABLE table_name
--      ADD CONSTRAINT constraint_name CONSTRAINT_TYPE (column_name);

	ALTER TABLE animals
	ADD CONSTRAINT UC_name UNIQUE (binomial_name);

-- 12. Add the following data to the countries table:
--      |name 	    |capital 	|population
-------------------------------------------
--      |France 	|Paris 	    |67,158,000

	INSERT INTO countries (name, capital, population)
	VALUES ('France', 'Paris', 67158000);

-- 13. Now add the following additional data to the countries table:
--      |name 	    |capital 	        |population
----------------------------------------------------
--      |USA 	    |Washington D.C. 	|325,365,189
--      |Germany    |Berlin 	        |82,349,400
--      |Japan 	    |Tokyo 	        |126,672,000

	INSERT INTO countries (name, capital, population)
	VALUES ('USA', 'Washington D.C.', 325365189);
	
	INSERT INTO countries (name, capital, population)
	VALUES ('Germany', 'Berlin', 382349400);
	
	INSERT INTO countries (name, capital, population)
	VALUES ('Japan', 'Tokyo', 126672000);

-- 14. Add an entry to the celebrities table for the singer and songwriter
-- Bruce Springsteen, who was born on September 23rd 1949 and is still alive.

	INSERT INTO celebreties (first_name, last_name, occupation, date_of_birth)
	VALUES ('Bruce', 'Springsteen', 'singer and songwriter', '1949-09-23');

-- 15.  Add an entry for the actress
-- Scarlett Johansson, who was born on November 22nd 1984.
-- Use the default value for the deceased column.

	INSERT INTO celebreties (first_name, last_name, occupation, date_of_birth)
	VALUES ('Scarlett', 'Johansson', 'actress', '1984-11-22');

-- 16. Add the following two entries to the celebrities table with a single INSERT statement.
--      For Frank Sinatra set true as the value for the deceased column.
--      For Tom Cruise, don't set an explicit value for the deceased column, but use the default value.
--
-- |first_name 	|last_name 	|occupation 	|date_of_birth
--------------------------------------------------------------
-- |Frank 	    |Sinatra 	|Singer, Actor 	|December 12, 1915
-- |Tom 	    |Cruise 	|Actor 	        |July 03, 1962

	INSERT INTO celebreties (first_name, last_name, occupation, date_of_birth, deceased)
	VALUES ('Frank', 'Sinatra', 'Singer, Actor', '1915-12-12', true), ('Tom', 'Cruise', 'Actor', '1962-07-03');	

-- 17.  Look at the schema of the celebrities table.
--      What do you think will happen if we try to insert the following data?
--      |first_name 	|last_name 	|occupation 	                     |date_of_birth  |deceased
-----------------------------------------------------------------------------------------------------
--      |Madonna 		|           |Singer, Actress 	                 |'08/16/1958' 	|false
--      |Prince 		|           |Singer, Songwriter, Musician, Actor |'06/07/1958' 	|true

--		Something like: NOT NULL constraint failed: celebreties.last_name

-- 18. Update the last_name column of the celebrities table so that the data in the previous question can be entered, and then add the data to the table.
-- Hint:
--      First we need to alter the table column to remove the NOT NULL constraint:
--      Then we can insert the data.

	ALTER TABLE celebreties
	DROP CONSTRAINT UC_last_name;
	
	INSERT INTO celebreties (first_name, occupation, date_of_birth, deceased)
	VALUES ('Madonna', 'Singer, Actress', '1958-08-16', false), ('Prince', 'Singer, Songwriter, Musician, Actor', '1958-06-07', true);	

-- 19. Check the schema of the celebrities table.
-- What would happen if we specify a NULL value for deceased column, such as with the data below?
--
-- |first_name 	|last_name 	|occupation 	            |date_of_birth  |deceased
-----------------------------------------------------------------------------------------
-- |Elvis 	    |Presley 	|Singer, Musician, Actor 	|'01/08/1935' 	|NULL

	$ encyclopedia=# \d celebreties
	
--  error would occured because bool can not contain NULL

-- 20. Check the schema of the animals table.
-- What would happen if we tried to insert the following data to the table?
-- Identify the problem and alter the table so that the data can be entered as shown, and then insert the data.
--
-- Hint: we need to remove this contraint before adding the data.
-- |name 	         |binomial_name 	        |max_weight_kg 	    |max_age_years 	    |conservation_status
-------------------------------------------------------------------------------------------------------------
-- |Dove 	         |Columbidae Columbiformes 	|2 	            	|15                 |LC
-- |Golden Eagle 	 |Aquila Chrysaetos 	    |6.35 	            |24 	            |LC
-- |Peregrine Falcon |Falco Peregrinus 	    	|1.5 	            |15 	            |LC
-- |Pigeon 	         |Columbidae Columbiformes 	|2 	            	|15 	            |LC
-- |Kakapo 	         |Strigops habroptila 	    |4 	            	|60 	            |CR

	$ encyclopedia=# \d animals
--	there is two same binomial names so we need to remove UNIQUE for this column
	ALTER TABLE animals
	DROP CONSTRAINT UC_binomial_name;
	
	INSERT INTO animals (name, binomial_name, max_weight_kg, max_age_years, conservation_status)
	VALUES ('Dove', 'Columbidae Columbiformes', 2, 15, 'LC'), ('Golden Eagle', 'Aquila Chrysaetos', 6.35, 24, 'LC'),
	('Peregrine Falcon', 'Falco Peregrinus', 1.5, 15, 'LC'), ('Pigeon', 'Columbidae Columbiformes', 2, 15, 'LC'), 
	('Kakapo', 'Strigops habroptila', 4, 60, 'CR')
	

-- 21.Create database ls_burger.

	$ encyclopedia=# CREATE DATABASE ls_burger

-- 22. Connect to ls_burger.

	$ encyclopedia=# \c ls_burger
	$ ls_burger=#

-- 23. Create a table in the ls_burger database called orders. The table should have the following columns:
--
--     An id column, that should contain an auto-incrementing integer value.
--     A customer_name column, that should contain a string of up to 100 characters
--     A burger column, that should hold a string of up to 50 characters
--     A side column, that should hold a string of up to 50 characters
--     A drink column, that should hold a string of up to 50 characters
--     An order_total column, that should hold a numeric value in dollars and cents. Assume that all orders will be less than $100.
--
-- The customer_name and order_total columns should always contain a value.
-- For the order_total column, our decimal needs a precision of 4, since the maximum value of an order is theoretically $99.99.
-- The scale is 2, since the two digits to the right of the decimal represent the number of cents.

	CREATE TABLE orders (
	  id SERIAL UNIQUE,
	  customer_name VARCHAR(100) NOT NULL,
	  burger VARCHAR(50),
	  side VARCHAR(50),
	  drink VARCHAR(50),
	  order_total DECIMAL(4,2) NOT NULL
	);

-- 24. Add the following columns to the orders table:
--     A column called customer_email; it should hold strings of up to 50 characters.
--     A column called customer_loyalty_points that should hold integer values. If no value is specified for this column, then a value of 0 should be applied.

	ALTER TABLE orders
	ADD customer_email VARCHAR(50);
	
	ALTER TABLE orders
	ADD customer_loyalty_points INT() DEFAULT 0;

-- 25. Add three columns to the orders table called burger_cost, side_cost, and drink_cost to hold monetary values in dollars and cents (assume that all values will be less than $100).
-- If no value is entered for these columns, a value of 0 dollars should be used.

	ALTER TABLE orders
	ADD burger_cost DECIMAL(4,2) DEFAULT 0;
	
	ALTER TABLE orders
	side_cost DECIMAL(4,2) DEFAULT 0;
	
	
	ALTER TABLE orders
	drink_cost DECIMAL(4,2) DEFAULT 0;

-- 26. Remove the order_total column from the orders table.

	ALTER TABLE orders
	DROP order_total;

-- 27. Based on the table schema and following information, write and execute an INSERT statement to add the appropriate data to the orders table.
--  There are three customers - James Bergman, Natasha O'Shea, Aaron Muller.
--  James' email address is james1998@email.com. Natasha's email address is natasha@osheafamily.com. Aaron doesn't supply an email address.
--  James orders a LS Chicken Burger, Fries and a Cola.
--  Natasha has two orders - an LS Cheeseburger with Fries but no drink, and an LS Double Deluxe Burger with Onion Rings and a Chocolate Shake.
--  Aaron orders an LS Burger with no side or drink.
--
-- The item costs and loyalty points are listed below:
--
-- |Item 	                |Cost ($)   |Loyalty Points
-----------------------------------------------------------
-- |LS Burger 	            |3.00 	    |10
-- |LS Cheeseburger         |3.50 	    |15
-- |LS Chicken Burger 	    |4.50 	    |20
-- |LS Double Deluxe Burger |6.00 	    |30
-- |Fries 	                |0.99       |3
-- |Onion Rings 	        |1.50 	    |5
-- |Cola 	                |1.50       |5
-- |Lemonade 	            |1.50       |5
-- |Vanilla Shake 	        |2.00       |7
-- |Chocolate Shake 	    |2.00       |7
-- |Strawberry Shake 	    |2.00       |7
--
-- Hint:
--      In the customer_name column, for the rows with Natasha O'Shea we need to escape the single quote
--      Where an order doesn't include a particular item (burger, side, or drink) we have to specify a NULL value for the appropriate column.
--      For the equivalent cost column, we could either explicitly use the DEFAULT or specify a value of 0.00 or 0.

	INSERT INTO orders (customer_name, customer_email, burger, side, drink, customer_loyalty_points, burger_cost, side_cost, drink_cost)
	VALUES ('James Bergman', 'james1998@email.com', 'LS Chicken Burger', 'Fries', 'Cola', 28, 4.50, 0.99, 1.50), 
	('Natasha O`Shea', 'natasha@osheafamily.com', 'LS Cheeseburger', 'Fries', null, 18, 3.50, 0.99), 
	('Natasha O`Shea', 'natasha@osheafamily.com', 'LS Double Deluxe Burger', 'Onion Rings', 'Chocolate Shake', 42, 6.00, 1.50, 2.00),
	('Aaron Muller', null, 'LS Burger', null, null, 10, 3.00)
	
