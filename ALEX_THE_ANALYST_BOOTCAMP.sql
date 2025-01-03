SELECT gender,count(*) 
FROM parks_and_recreation.employee_demographics
group by gender;

select gender,AVG(age),MAX(age),MIN(age),COUNT(age)
from employee_demographics
group by gender;

select occupation, count(*)
from employee_salary
group by occupation;

select occupation, salary
from employee_salary
group by occupation, salary ;

-- ORDER BY--
SELECT * FROM employee_demographics
order by first_name;

-- HAVING--
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age)>40 ;

select occupation, AVG(Salary)
from employee_salary
WHERE occupation LIKE 'C%'
GROUP BY occupation
HAVING AVG(salary)>70000;

-- LIMIT --
SELECT *
FROM employee_demographics
order by age desc
LIMIT 4;

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3,1;

-- Aliasing--
select gender, AVG(age) as avg_age
from employee_demographics
group by gender
having avg(age)>40;

-- INNER JOIN --
SELECT * FROM employee_demographics;
select * from employee_salary;

select *
from employee_demographics
INNER JOIN employee_salary
	ON employee_demographics.employee_id= employee_salary.employee_id;

select *
from employee_demographics a 
INNER JOIN employee_salary b
	ON a.employee_id= b.employee_id;

select *
from employee_demographics AS dem 
INNER JOIN employee_salary AS sal
	ON dem.employee_id= sal.employee_id;
    
 select a.employee_id,age,occupation
 from  employee_demographics a 
 INNER JOIN employee_salary b
	ON a.employee_id=b.employee_id;
    
-- OUTER JOIN --
SELECT*
FROM employee_salary a 
LEFT JOIN employee_demographics b
	ON a.employee_id=b.employee_id;
    
SELECT*
FROM employee_demographics a 
RIGHT JOIN employee_salary b
	ON a.employee_id=b.employee_id;
    
-- SELF JOIN --

SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id = emp2.employee_id ;

SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id +1 = emp2.employee_id ;
    
SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name,
emp2.first_name AS first_name_name,
emp2.last_name AS last_name_name
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id +1 = emp2.employee_id ;
    
-- JOINING MULTIPLE TABLES--
SELECT *
FROM employee_salary emp1
INNER JOIN employee_salary emp2
	ON emp1.employee_id = emp2.employee_id 
INNER JOIN parks_departments pd
	ON pd.department_id=emp2.dept_id;

-- UNION--
SELECT age,gender
FROM employee_demographics
UNION 
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name
FROM employee_demographics
UNION 
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;


SELECT first_name,last_name,'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender='Male'
UNION
SELECT first_name,last_name,'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 and gender = 'Female'
UNION
SELECT first_name,last_name,'Highly Paided Employee' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name,last_name;

-- String function --
SELECT LENGTH('SKYFALL');

SELECT first_name,LENGTH(first_name) 
FROM employee_demographics
order by 2;

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT first_name, UPPER(last_name)
FROM employee_demographics;

SELECT '         SKY    ';
select TRIM('        SKY          ');

SELECT RTRIM('       SKY     ');

select first_name,LEFT(first_name,4),
RIGHT(first_name,4), 
SUBSTRING(first_name,3,3),
birth_date,
SUBSTRING(birth_date,6,2) AS birth_month
from employee_demographics;

SELECT first_name,REPLACE(first_name,'a','z')
FROM employee_demographics;

SELECT LOCATE('x','Alexander');

SELECT first_name, LOCATE('An',first_name) 
FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name,' ',last_name) AS full_name
FROM employee_demographics;

-- CASE STATEMENTS --
SELECT first_name,
last_name,
CASE
	WHEN age <= 30 THEN 'Young'
END
FROM employee_demographics;


SELECT first_name,
last_name,
CASE
	WHEN age <35 THEN 'Young Person'
    WHEN age >= 35 THEN 'Old Person'
END  as age_statement
FROM employee_demographics;


SELECT first_name,
last_name,
age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >=50 THEN "On Death's Door"
END AS age_bracket
FROM employee_demographics;


SELECT first_name,
last_name,
age,
CASE
	WHEN age <= 30 then 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >=50 THEN "On Death's Door"
END AS Age_bracket
FROM employee_demographics;


SELECT first_name,
last_name,
salary,
CASE
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary + (salary * 0.07)
END AS New_Salary,
CASE 
	WHEN dept_id=6 THEN salary *0.10
END AS Bonus
FROM employee_salary;

-- Subqueries --
SELECT *
FROM employee_demographics
WHERE employee_id IN
					(SELECT employee_id
						FROM employee_salary
                        WHERE dept_id = 1);

SELECT first_name, salary,
	(Select AVG(salary)
    from employee_salary)
FROM employee_salary;

SELECT gender, AVG(age),MAX(age),MIN(age),COUNT(age)
FROM employee_demographics
group by gender;

SELECT gender, AVG(`MAX(age)`)
FROM 
(SELECT gender, AVG(age),MAX(age),MIN(age),COUNT(age)
FROM employee_demographics
group by gender) AS Agg_table
GROUP BY gender;

SELECT AVG(AVG_age) AS AVG_TOTAL
FROM 
(SELECT gender, 
AVG(age) as AVG_age,
MAX(age) as MAX_age,
MIN(age) as MIN_age,
COUNT(age)
FROM employee_demographics
GROUP BY gender) as Agg_table;

-- WINDOW FUNCTIONS
SELECT gender,AVG(salary) as avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id
GROUP BY gender;

SELECT dem.first_name,dem.last_name, gender,AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id;

SELECT dem.employee_id,dem.first_name,dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id;

SELECT dem.employee_id,dem.first_name,dem.last_name, gender, salary,
row_number() over()
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id;
    
select dem.employee_id,dem.first_name,dem.last_name,gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS Satır_sayı
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id;

SELECT dem.employee_id,dem.first_name,dem.last_name, gender, salary,
row_number() over(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id;
    
SELECT dem.employee_id,dem.first_name,dem.last_name,gender,salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary desc) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary desc) AS rank_num,
DENSE_RANK() OVER(PARTITION  BY gender ORDER BY salary desc) AS densse_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id;
    
-- CTEs alike subquery but regular form --

WITH CTE_Example As
(
SELECT gender,AVG(salary) AS avg_sal,MAX(salary) AS max_sal,MIN(salary) AS min_sal,COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example;

WITH CTE_Example(Gender,AVG_Sal,MAX_Sal,MIN_Sal,COUNT_Sal) As
(
SELECT gender,AVG(salary) AS avg_sal,MAX(salary) AS max_sal,MIN(salary) AS min_sal,COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example;

SELECT avg(avg_sal),max(max_sal) FROM
(
SELECT gender,AVG(salary) AS avg_sal,MAX(salary) AS max_sal,MIN(salary) AS min_sal,COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id
GROUP BY gender
)Example;


WITH CTE_Example AS
(
SELECT employee_id,gender, birth_date 
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 As
(
SELECT employee_id,salary
FROM employee_salary
WHERE salary > 50000
)
SELECT * 
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id=CTE_Example2.employee_id;

-- TEMPORARY TABLE --

CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

INSERT INTO temp_table
VALUES
('Alex','Fredeberg','Lord of the Rings');
select * from temp_table;

CREATE TEMPORARY TABLE salary_over_50k
select * 
from employee_salary
where salary >= 50000;

select * from salary_over_50k;

-- Stored Procedure --
CREATE PROCEDURE large_salary()
select * from employee_salary
where salary >= 50000;

CALL large_salary();


DELIMITER $$
CREATE PROCEDURE large_salary3()
BEGIN
    SELECT * FROM employee_salary WHERE salary >= 50000;
    SELECT * FROM employee_salary WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salary3();


DELIMITER $$
CREATE PROCEDURE large_salary4(employee_salary INT)
BEGIN
	SELECT salary
    FROM employee_salary
    WHERE employee_id=employee_id;
END $$
DELIMITER ;

CALL large_salary4(1);


DELIMITER $$
CREATE PROCEDURE large_salary6(huggymuffin INT)
BEGIN
	SELECT salary
    FROM employee_salary
    WHERE employee_id=huggymuffin;
END $$
DELIMITER ;
CALL large_salary6(1);

-- Triggers and Events--
DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id,first_name,last_name,occupation, 
salary,dept_id)
VALUES
(13,'Jean-Ralphio','Saperstein','Entertainment 720 CEO', 1000000, NULL);

SELECT * FROM employee_salary;
SELECT * FROM employee_demographics;

-- Events --
SELECT * FROM employee_demographics;
 
 DELIMITER $$
 CREATE EVENT delete_RET
 ON SCHEDULE EVERY 1 DAY
 STARTS CURRENT_TIMESTAMP
 DO
 BEGIN
	DELETE 
    FROM employee_demographics
    WHERE age > 60;
 END $$
 DELIMITER ;
 
SHOW VARIABLES LIKE 'event%';






