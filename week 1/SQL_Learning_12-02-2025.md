**SQL Learning Documentation -- 12-02-2025**

**Introduction**

This document covers key SQL concepts, including **Foreign Keys,
Database Normalization, ACID Properties, Stored Procedures, ER Diagrams,
Cardinality, and SQL Queries**. It also includes practical examples and
scripts used during learning.

**📌 Entity-Relationship Diagram (ER Diagram)**

An **ER Diagram (ERD)** visually represents how entities (tables) relate
to each other in a database.

**🔹 Components of an ER Diagram:**

-   **Entities:** Objects represented as tables (e.g., Students,
    Courses, Enrollments).

-   **Attributes:** Characteristics of entities (e.g., Student ID,
    Course Name).

-   **Primary Key (PK):** Unique identifier for an entity (e.g.,
    student_id).

-   **Foreign Key (FK):** Establishes a relationship between entities
    (e.g., student_id in Enrollments references student_id in Students).

-   **Relationships:** Defines connections between tables (e.g.,
    \"Enrolled In\" relationship between Students and Courses).

**📌 Cardinality in ER Diagrams**

Cardinality defines the **relationship constraints** between tables:

-   **One-to-One (1:1):** One record in Table A maps to one record in
    Table B.

-   **One-to-Many (1:M):** One record in Table A maps to multiple
    records in Table B (e.g., One **Department** has many
    **Employees**).

-   **Many-to-Many (M:N):** Many records in Table A relate to many
    records in Table B (e.g., **Students** enroll in multiple
    **Courses**).

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

📌 **Bridge Tables and Many-to-Many Relationships**

A Bridge Table (also known as a Junction Table) is used to resolve a
Many-to-Many (M:N) relationship by breaking it into two One-to-Many
(1:M) relationships.

How a Bridge Table Works:

1️⃣ Structure:

• A Bridge Table contains at least two Foreign Keys that reference the
Primary Keys of the original tables.

• Example: A table StudentCourseEnrollments with Student_ID and
Course_ID as Foreign Keys.

2️⃣ Linking Records:

• Each row in the Bridge Table represents a specific relationship
between a student and a course.

• Example: A row {Student_ID = 1, Course_ID = 3} means that Student 1 is
enrolled in Course 3.

3️⃣ Resolving Many-to-Many:

• The Many-to-Many relationship between Students and Courses is resolved
into:

o One-to-Many between Students and StudentCourseEnrollments (a student
can enroll in multiple courses).

o One-to-Many between Courses and StudentCourseEnrollments (a course can
have multiple students).

🛠️ **SQL Implementation of a Bridge Table**

CREATE TABLE StudentCourseEnrollments (

Enrollment_ID INT PRIMARY KEY AUTO_INCREMENT,

Student_ID INT,

Course_ID INT,

Enrollment_Date DATE,

FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID),

FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID)

);

✅ This table efficiently manages many-to-many relationships between
Students and Courses while maintaining referential integrity.

**📌 Database Normalization**

Normalization is the process of **structuring a database** to minimize
redundancy and ensure data integrity.

**🔹 Benefits of Normalization:**

✅ Reduces **data redundancy**\
✅ Ensures **data consistency**\
✅ Eliminates **insertion, update, and deletion anomalies**

**📌 Normal Forms (NF)**

  -----------------------------------------------------------------------
  **Normal   **Key Rule**        **Solution**
  Form**                         
  ---------- ------------------- ----------------------------------------
  **1NF**    No multi-valued     Each column should contain atomic
             columns.            values.

  **2NF**    No partial          Ensure all attributes depend on the full
             dependency.         Primary Key.

  **3NF**    No transitive       Remove attributes that depend on non-key
             dependency.         attributes.
  -----------------------------------------------------------------------

✔ **Example:** If A → B, then A is the **determinant**, and B is the
**dependent**.\
✔ **Example:** **Social Security Number uniquely identifies employees,
but names can repeat.**

**📌 ACID Properties in DBMS**

ACID ensures reliable transactions in SQL databases.

  --------------------------------------------------------------------------------
  **Property**      **Description**               **Example**
  ----------------- ----------------------------- --------------------------------
  **Atomicity**     A transaction is either fully If a payment is deducted but not
                    completed or fully rolled     credited, the deduction should
                    back.                         be reversed.

  **Consistency**   The database remains in a     A failed transaction should not
                    valid state before and after  corrupt data.
                    a transaction.                

  **Isolation**     Ensures transactions do not   If Alice transfers money while
                    interfere with each other.    Bob withdraws, neither should
                                                  affect the other.

  **Durability**    Once a transaction is         Even if the system crashes,
                    committed, it remains         completed payments should be
                    permanent.                    stored securely.
  --------------------------------------------------------------------------------

✔ **Example:**

-   If a device crashes during a payment transaction, it **rolls back**
    to prevent errors.

-   If the transaction **commits successfully**, it **remains valid**,
    even after a system restart.

**📌 Understanding Different Keys in SQL**

**🔹 Types of Keys in a Database**

**A database uses various types of keys to ensure data integrity,
uniqueness, and relationships between tables. Below are the key types
explained with examples.**

**1️⃣ Primary Key (PK)**

-   **A Primary Key uniquely identifies each record in a table.**

-   **It cannot contain NULL values and must be unique for every row.**

**Example:**

-   **Student_ID (101, 102, 103) is the Primary Key for the Students
    table.**

**CREATE TABLE Students (**

**Student_ID INT PRIMARY KEY,**

**Name VARCHAR(50),**

**Email VARCHAR(100)**

**);**

**2️⃣ Candidate Key**

-   **A Candidate Key is any attribute (or set of attributes) that can
    uniquely identify a row.**

-   **A Primary Key is chosen from the Candidate Keys.**

**Example:**

-   **Student_ID, Phone_Number, and Email_ID are Candidate Keys.**

**3️⃣ Super Key**

-   **A Super Key is a set of one or more attributes that can uniquely
    identify a row.**

-   **It may include extra attributes beyond the minimal required
    ones.**

**Example:**

-   **{Student_ID}, {Student_ID, Name}, {Phone_Number, Email_ID}**

**4️⃣ Foreign Key (FK)**

-   **A Foreign Key establishes a relationship between two tables by
    referring to the Primary Key in another table.**

-   **It ensures referential integrity, meaning referenced values must
    exist in the parent table.**

**Example:**

-   **Department_ID in the Employees table is a Foreign Key referencing
    the Department_ID in the Departments table.**

**CREATE TABLE Employees (**

**EmpID INT PRIMARY KEY,**

**Name VARCHAR(50),**

**Department_ID INT,**

**FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)**

**);**

**5️⃣ Alternate Key**

-   **A Candidate Key that is not chosen as the Primary Key is called an
    Alternate Key.**

**Example:**

-   **If Student_ID is chosen as the Primary Key, the Alternate Keys
    could be Phone_Number or Email_ID.**

**6️⃣ Composite Key**

-   **A Composite Key consists of two or more columns that together
    uniquely identify a row.**

**Example:**

-   **In an Enrollments table, a Composite Key can be {Student_ID,
    Course_ID} to uniquely identify a student\'s enrollment in a
    specific course.**

**CREATE TABLE Enrollments (**

**Student_ID INT,**

**Course_ID INT,**

**Enrollment_Date DATE,**

**PRIMARY KEY (Student_ID, Course_ID)**

**);**

**7️⃣ Unique Key**

-   **A Unique Key ensures values in a column remain unique but allows
    NULL values.**

**Example:**

-   **Email_ID is a Unique Key because no two students can have the same
    email.**

**CREATE TABLE Users (**

**User_ID INT PRIMARY KEY,**

**Email_ID VARCHAR(100) UNIQUE**

**);**

**📌 Foreign Key in SQL -- Complete Guide**

A **Foreign Key (FK)** enforces **referential integrity** between two
tables.

**✅ Key Features:**

-   Links a column in one table to a **Primary Key** or **Unique Key**
    in another.

-   Prevents orphaned records.

**🛠️ Creating Parent and Child Tables**

CREATE TABLE Departments (

DeptID INT PRIMARY KEY,

DeptName VARCHAR(50)

);

CREATE TABLE Employees (

EmpID INT PRIMARY KEY,

Name VARCHAR(50),

DeptID INT,

FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)

);

**📌 Stored Procedures in SQL**

**🔹 What is a Stored Procedure?**

**A Stored Procedure is a precompiled set of SQL statements that is
stored in the database and executed as a single unit. It enhances
performance, security, and reusability in database management.**

**🔹 Why Use Stored Procedures?**

  ---------------------------------------------------------------------------
  **Feature**         **Benefit**
  ------------------- -------------------------------------------------------
  **Reusability**     **Write once, execute multiple times.**

  **Performance       **Reduces execution time by eliminating repeated
  Boost**             parsing and compilation.**

  **Security**        **Protects against SQL injection by encapsulating SQL
                      logic.**

  **Encapsulation**   **Groups multiple SQL operations into a single callable
                      unit.**

  **Consistency**     **Ensures that business rules are applied uniformly.**
  ---------------------------------------------------------------------------

**📌 Creating a Stored Procedure in SQL**

**🛠️ Stored Procedure for Inserting Students**

**DELIMITER //**

**CREATE PROCEDURE sp_insert_student(**

**IN p_first_name VARCHAR(50),**

**IN p_last_name VARCHAR(50),**

**IN p_email VARCHAR(100)**

**)**

**BEGIN**

**INSERT INTO students(first_name, last_name, email, enrollment_date)**

**VALUES (p_first_name, p_last_name, p_email, CURDATE());**

**SELECT LAST_INSERT_ID() AS STUDENT_ID;**

**END //**

**✔ How to Call the Procedure:**

**CALL sp_insert_student(\'Pratik\', \'Kumar\', \'pk@email.com\');**

**SELECT \* FROM students;**

**✅ This procedure inserts a student's details into the students table
and returns the last inserted ID.**

**📌 Stored Procedure for Updating Student GPA**

**DELIMITER //**

**CREATE PROCEDURE sp_update_student_gpa(**

**IN p_student_id INT,**

**IN p_new_gpa DECIMAL(3,2)**

**)**

**BEGIN**

**DECLARE current_gpa DECIMAL(3,2);**

**\-- Fetch the existing GPA**

**SELECT IFNULL(gpa, 0) INTO current_gpa FROM students WHERE student_id
= p_student_id;**

**\-- Update only if the new GPA is higher**

**IF p_new_gpa \> current_gpa THEN**

**UPDATE students**

**SET gpa = p_new_gpa, enrollment_date = NOW()**

**WHERE student_id = p_student_id;**

**SELECT \'GPA IMPROVED\' AS MESSAGE;**

**ELSE**

**SELECT \'NO CHANGE\' AS MESSAGE;**

**END IF;**

**END //**

**✔ How to Call the Procedure:**

**CALL sp_update_student_gpa(2, 9.9);**

**CALL sp_update_student_gpa(2, 9.8);**

**SELECT \* FROM students;**

**✅ This procedure updates a student\'s GPA only if the new GPA is
higher than the existing one.**

**📌 Stored Procedure with IF-ELSE Logic**

**Classifying Students Based on GPA**

**DELIMITER //**

**CREATE PROCEDURE sp_classify_student_gpa(**

**IN p_student_id INT,**

**OUT p_category VARCHAR(20)**

**)**

**BEGIN**

**DECLARE student_gpa DECIMAL(3,2);**

**\-- Retrieve GPA for the given student**

**SELECT gpa INTO student_gpa FROM students WHERE student_id =
p_student_id;**

**\-- Categorize the student based on GPA**

**IF student_gpa \>= 9.0 THEN**

**SET p_category = \'Excellent\';**

**ELSEIF student_gpa BETWEEN 7.0 AND 8.9 THEN**

**SET p_category = \'Good\';**

**ELSE**

**SET p_category = \'Needs Improvement\';**

**END IF;**

**END //**

**✔ How to Call the Procedure:**

**CALL sp_classify_student_gpa(2, \@category);**

**SELECT \@category;**

**✅ This procedure classifies students based on their GPA into
different performance categories.**

**📌 Stored Procedure with Input and Output Parameters**

**DELIMITER //**

**CREATE PROCEDURE sp_get_total_enrollments(**

**IN p_course_id INT,**

**OUT p_total_enrollments INT**

**)**

**BEGIN**

**SELECT COUNT(\*) INTO p_total_enrollments FROM enrollments WHERE
course_id = p_course_id;**

**END //**

**✔ How to Call the Procedure:**

**CALL sp_get_total_enrollments(1, \@total);**

**SELECT \@total;**

**✅ This procedure calculates the total number of students enrolled in
a given course.**

**📌 Dropping a Stored Procedure**

**DROP PROCEDURE IF EXISTS sp_insert_student;**

**✅ This command deletes the stored procedure if it exists.**

**📌 Summary & Key Takeaways**

✔ **Foreign Keys** enforce **referential integrity** and prevent
orphaned records.\
✔ **Normalization** reduces **redundancy** and improves **data
integrity**.\
✔ **Stored Procedures** optimize performance and enhance security.\
✔ **ACID Properties** ensure **reliable and fault-tolerant**
transactions.

1.  Problem 1

> <https://leetcode.com/problems/students-and-examinations/description/?envType=study-plan-v2&envId=top-sql-50>

![](media/image1.png){width="6.268055555555556in"
height="2.7416666666666667in"}

2.  Problem 2

> <https://leetcode.com/problems/confirmation-rate/description/?envType=study-plan-v2&envId=top-sql-50>

![](media/image2.png){width="6.268055555555556in"
height="2.7506944444444446in"}

3.  Problem 3

<https://leetcode.com/problems/not-boring-movies/description/?envType=study-plan-v2&envId=top-sql-50>

![](media/image3.png){width="6.268055555555556in" height="2.775in"}

4.  Problem 4

<https://leetcode.com/problems/average-selling-price/description/?envType=study-plan-v2&envId=top-sql-50>

![](media/image4.png){width="6.268055555555556in"
height="2.7729166666666667in"}

5.  Problem 5

<https://leetcode.com/problems/project-employees-i/description/?envType=study-plan-v2&envId=top-sql-50>

![](media/image5.png){width="6.268055555555556in"
height="2.759027777777778in"}

6.  Problem 6

<https://leetcode.com/problems/percentage-of-users-attended-a-contest/description/?envType=study-plan-v2&envId=top-sql-50>

![](media/image6.png){width="6.268055555555556in"
height="2.7819444444444446in"}

7.  Problem 7

<https://leetcode.com/problems/queries-quality-and-percentage/description/?envType=study-plan-v2&envId=top-sql-50>\
![](media/image7.png){width="6.268055555555556in"
height="2.770138888888889in"}

8.  Problem 8

<https://leetcode.com/problems/monthly-transactions-i/description/?envType=study-plan-v2&envId=top-sql-50>

![](media/image8.png){width="6.268055555555556in"
height="2.9506944444444443in"}
