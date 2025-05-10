create database library;

use library;
CREATE TABLE books (
    book_id VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(50),
    category VARCHAR(20),
    rentel_price FLOAT,
    status_book VARCHAR(10),
    author VARCHAR(50),
    publisher VARCHAR(50)
);

CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(50),
    contact_no BIGINT
);

CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(20),
    position VARCHAR(20),
    salary INT,
    branch_id VARCHAR(20)
);

CREATE TABLE status (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),
    issued_book_name VARCHAR(50),
    issued_date DATETIME,
    book_id VARCHAR(50),
    issued_emp_id VARCHAR(10)
);
SELECT 
    *
FROM
    status;

CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(20),
    member_address VARCHAR(50),
    reg_date DATE
);

-- foreign key   
alter table employees
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);
-- status
alter table status
add constraint fk_members
foreign key ( issued_member_id )
references members(member_id);
-- foreign key 
alter table status
add constraint fk_book
foreign key ( book_id )
references books(book_id);
-- foreign key 
alter table status
add constraint fk_emp
foreign key (issued_emp_id )
references employees(emp_id);


-- task 1 Count All the No of the books
SELECT 
    COUNT(*)
FROM
    books;
 -- task 2 Count the books by categoryes   
SELECT 
    COUNT(*), category
FROM
    books
GROUP BY category;

--  task 3 find the employees work in branch id B001
SELECT 
    e.emp_id, e.emp_name, b.branch_id
FROM
    employees e
        INNER JOIN
    branch b ON e.branch_id = b.branch_id
WHERE
    b.branch_id = 'B001';
    
-- task 5 retrevie all employees where salary > 60000
SELECT 
    *
FROM
    employees
WHERE
    salary > 60000;

-- Task 5. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books values('978-1-60129-456-2','To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT 
    *
FROM
    books;

-- Task 6: Update an Existing Member's Address

UPDATE members 
SET 
    member_address = '143 Main Road'
WHERE
    member_id = 'C101';

-- Task 7: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.

DELETE FROM status 
WHERE
    issued_id = 'IS108';

-- Task 8: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT 
    issued_book_name, book_id, issued_emp_id
FROM
    status
WHERE
    issued_emp_id = 'E101';

-- Task 9: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
    issued_emp_id, COUNT(issued_id) AS total_issued_book
FROM
    status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;

-- Task 10: Create Summary Tables: 
-- Used CTAS to generate new tables based on query results - each book and total book_issued_cnt.
CREATE TABLE book_issue_count AS SELECT b.book_id, b.book_title, COUNT(issued_id) AS issue_count FROM
    books b
        JOIN
    status s ON b.book_id = s.book_id
GROUP BY issued_id;

SELECT 
    *
FROM
    book_issue_count;

-- Task 11. **Retrieve All Books in a Specific Category:

SELECT 
    book_title, category
FROM
    books
WHERE
    category = 'Classic';

-- Task 12: Find Total Rental Income by Category:

SELECT 
    b.category,
    SUM(b.rentel_price) AS total_rentel_price,
    COUNT(*) AS total_count
FROM
    books b
        JOIN
    status s ON s.book_id = b.book_id
GROUP BY category;

-- Task 13. **List Members Who Registered in the Last 365Days**:
SELECT 
    *
FROM
    members;
SELECT 
    *
FROM
    members
WHERE
    reg_date >= CURRENT_DATE() - INTERVAL 365 DAY;

-- Task 14: List Employees with Their Branch Manager's Name and their branch details**:
SELECT 
    e.*, b.branch_id, e1.emp_name, e1.position
FROM
    employees e
        JOIN
    branch b ON b.branch_id = e.branch_id
        JOIN
    employees e1 ON b.Manager_id = e1.emp_id;




