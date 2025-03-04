**1. SQL Learning Documentation - 10-02-2025**

**Understanding SQL (Structured Query Language)**

SQL is a language designed to interact with databases, helping us store,
retrieve, modify, and delete data efficiently. Imagine a **digital
filing cabinet** where you can store records, and SQL acts like a
librarian who fetches and organizes data when needed.

**Key Concepts**

1.  **Databases & Tables**

    -   A **database** is like an Excel workbook.

    -   A **table** inside a database is like a worksheet storing data
        in rows and columns.

    -   Each **row** is a record (like a student's details in a school
        database).

    -   Each **column** represents a field (like name, age, grade).

2.  **Basic SQL Commands**

    -   **Retrieving Data:**

    -   SELECT \* FROM students;

> This retrieves all students from the \"students\" table.

-   **Inserting New Data:**

-   INSERT INTO students (id, name, age) VALUES (1, \'Alice\', 14);

> This adds a new student named Alice, aged 14.

-   **Updating Existing Data:**

-   UPDATE students SET age = 15 WHERE id = 1;

> This changes Alice's age to 15.

-   **Deleting a Record:**

-   DELETE FROM students WHERE id = 1;

> This removes Alice's record.

**Why is SQL Important?**

-   Used in websites, banking systems, and apps to store and retrieve
    user data.

-   Helps in **querying and filtering data efficiently** instead of
    manually searching.

**2. SQL Learning Documentation - 11-02-2025**

**Going Deeper into SQL**

Now that we understand the basics, let's explore **advanced SQL
concepts** that allow more powerful data manipulation.

**Joins (Combining Data from Multiple Tables)**

Imagine you have two tables:

1.  **Students** table -- Contains student IDs and names.

2.  **Courses** table -- Contains student IDs and enrolled courses.

To find out which student is enrolled in which course, we use a
**JOIN**:

SELECT students.name, courses.course_name

FROM students

INNER JOIN courses

ON students.id = courses.student_id;

This retrieves a list of student names along with their courses.

**Ranking Functions**

Used to **assign ranks to data** (e.g., ranking students based on
marks).

SELECT name, marks,

RANK() OVER (ORDER BY marks DESC) AS RankValue

FROM students;

This ranks students from highest to lowest marks.

**Bitwise Operations**

-   Used in databases for **user permissions** (read, write, execute).

-   If 110 represents Read (1), Write (1), Execute (0), we can use:

-   UPDATE users SET permissions = permissions \| 2;

> This grants **write permission**.

**3. SQL Learning Documentation - 12-02-2025**

**Database Design Principles**

-   **ER Diagrams (Entity-Relationship Diagrams):** A visual blueprint
    of database tables and how they relate.

-   **Cardinality:** Describes the relationships between tables:

    -   One-to-One (1:1) → One person has one passport.

    -   One-to-Many (1:M) → One teacher has many students.

    -   Many-to-Many (M:N) → Students enroll in multiple courses.

**Normalization (Making Databases Efficient)**

-   Reduces redundancy and avoids duplicate data.

-   **Example:** Instead of storing department names in every employee's
    record, we keep a separate \"Departments\" table and reference it
    using a department_id.

**Stored Procedures**

A **stored procedure** is like a **pre-written function** that executes
SQL commands automatically.

**Example:** Instead of manually adding a student every time, we create:

CREATE PROCEDURE add_student (IN name VARCHAR(50))

BEGIN

INSERT INTO students (name) VALUES (name);

END;

Now, calling CALL add_student(\'Bob\'); adds Bob without writing an
INSERT statement.

**4. Git and SQL Learning - 13-02-2025**

**Introduction to Git**

Git is a **version control system** that tracks changes in code,
allowing multiple developers to collaborate without conflicts.

**Basic Git Commands**

-   git init → Initializes a new Git repository.

-   git add . → Stages all changes.

-   git commit -m \"Added new feature\" → Saves changes.

-   git push origin main → Uploads changes to GitHub.

**Advanced Git Concepts**

-   **Branching:** Allows multiple people to work on different features
    simultaneously.

-   git checkout -b new-feature

-   **Merging:** Combines code changes.

-   git merge new-feature

**5. Git Commands and Concepts - 14-02-2025**

**Resetting and Stashing Changes**

-   git reset \--hard origin/main → Discards all local changes and
    resets to the remote version.

-   git stash → Temporarily saves uncommitted changes for later use.

**Rewriting Git History**

-   git rebase → Rewrites commit history, keeping it clean.

-   git merge → Combines changes but keeps commit history.

**6. Linux Commands - 17-02-2025**

**Basic Linux Commands for Navigation**

-   pwd → Shows current working directory.

-   ls -la → Lists all files, including hidden ones.

-   cd folder_name → Moves into a directory.

-   mkdir new_folder → Creates a directory.

-   rm file.txt → Deletes a file.

**File Permissions**

-   **Reading (r), Writing (w), Executing (x)**

-   chmod 755 file.sh

> This grants full permissions to the owner and read-execute to others.

**7. Linux Commands and Shell Scripting - 18-02-2025**

**What is Shell Scripting?**

Shell scripting allows us to automate tasks in Linux.

**Creating a Shell Script**

#!/bin/bash

echo \"Hello, Linux!\"

ls -l

-   chmod +x script.sh → Makes the script executable.

-   ./script.sh → Runs the script.

**Using Variables in Scripts**

name=\"Alice\"

echo \"Hello, \$name!\"

-   Variables store dynamic values like usernames.

**Conditional Statements**

if \[ \$age -gt 18 \]; then

echo \"Adult\"

else

echo \"Minor\"

fi

-   Used to make decisions based on conditions.

**Loops**

for i in {1..5}; do

echo \"Number: \$i\"

done

-   Used to repeat a task multiple times.

**Detailed Explanation of the Next 7 Documents (From 19-02-2025 to
27-02-2025)**

Here's an **expanded beginner-friendly breakdown** of the next set of 7
documents, covering **advanced Linux commands, automation using Jenkins,
Docker, and Kubernetes deployment**.

**8. Linux Command - 19-02-2025**

**Understanding More Linux Commands**

By now, you understand the basics of Linux, such as file handling and
permissions. Let\'s explore **more complex commands** that help in
system administration and automation.

**Arrays in Bash**

-   Arrays allow storing multiple values in a single variable.

-   Example:

-   arr=(\"Pratik\" \"Mithi\" 1)

-   echo \${arr\[0\]} \# Outputs: Pratik

-   Arrays are useful when handling **multiple inputs** in scripts.

**Conditional Structures (\[\] vs \[\[ \]\])**

-   \[ \] is the traditional POSIX syntax.

-   \[\[ \]\] provides advanced features like pattern matching.

-   Example:

-   if \[\[ \"\$str\" == h\* \]\]; then

-   echo \"Pattern Matched\"

-   fi

-   **Tip:** Use \[\[ \]\] for Bash scripting because it provides better
    readability and functionality.

**File Test Operators (Checking File Properties)**

-   Check if a file exists:

-   \[ -e file.txt \] && echo \"File exists\"

-   Check if a directory exists:

-   \[ -d mydir \] && echo \"Directory exists\"

**9. Linux Command Learnings - 20-02-2025**

**Text Processing Commands in Linux**

Text processing commands allow filtering and modifying text files
efficiently.

**Using grep for Pattern Matching**

-   grep searches for specific words in files.

-   Example:

-   grep \"error\" logfile.txt

> Finds all occurrences of \"error\" in the log file.

-   **Advanced grep usage:**

-   grep -A 2 \"ERROR\" logfile.txt

> This **displays 2 lines after every \"ERROR\"** found.

**Using awk for Data Extraction**

-   awk processes structured data like CSV files.

-   Example: Extract the 3rd column from a file:

-   awk \'{print \$3}\' sample.csv

**Automating Tasks with crontab (Scheduler)**

-   Schedule a task to **run every day at 2 AM**:

-   0 2 \* \* \* /home/user/backup.sh

> This ensures automation without human intervention.

**10. Python Project Setup - 21-02-2025**

**Creating a Python Project**

When building Python applications, we organize the project into
**directories and modules**.

**Folder Structure**

basic-module/

├── src/

│ ├── basic_module/

│ ├── datastructure/

│ ├── pattern.py

├── pyproject.toml

├── requirements.txt

├── README.md

**Key Files Explained**

-   **pyproject.toml**: Defines the project metadata.

-   **requirements.txt**: Lists dependencies.

-   **Dockerfile** (Optional): Converts the Python project into a
    **containerized application**.

**Building & Running as a CLI**

To package and install the project as a CLI tool:

python3 -m build \--wheel

pip install dist/basic_module-0.1.0-py3-none-any.whl

Now, you can run:

basic-module

This **executes the CLI tool**, just like any built-in command.

**11. Docker Setup and Commands Reference - 24-02-2025**

**What is Docker?**

Docker is a tool that **packages applications with their dependencies**
so they run consistently across different systems.

**Why Docker?**

-   Ensures **consistency** between development and production.

-   **Lightweight** compared to Virtual Machines (VMs).

-   Makes **scaling applications easier**.

**Basic Docker Commands**

-   **Installing Docker**:

-   sudo apt install docker-ce

-   **Building a Docker Image**:

-   docker build -t myapp .

-   **Running a Docker Container**:

-   docker run -p 5000:5000 myapp

> This makes the app accessible at http://localhost:5000.

**Using Docker Hub**

-   **Login to Docker Hub**:

-   docker login

-   **Pushing an Image to Docker Hub**:

-   docker push username/myapp:latest

**12. Advanced Linux and Jenkins Setup - 25-02-2025**

**Jenkins: Automating Software Builds**

Jenkins is a tool that **automates software deployment**.

**Installing Jenkins**

-   Install Java (required for Jenkins):

-   sudo apt install openjdk-17-jre jenkins

-   Start Jenkins:

-   sudo systemctl start jenkins

-   Access Jenkins at http://localhost:8080.

**SSH Key Setup for GitHub**

To enable **secure authentication**, generate an SSH key:

ssh-keygen -t rsa -b 4096 -C \"your-email@example.com\"

This key is added to GitHub for **password-less authentication**.

**13. Jenkins Python Project Setup - 26-02-2025**

**Automating Python Deployment with Jenkins**

Jenkins pipelines allow automating:

1.  **Cloning a GitHub Repository**.

2.  **Building the Python Project**.

3.  **Running Unit Tests**.

4.  **Packaging the App into a Docker Image**.

5.  **Deploying to a Live Server**.

**Jenkinsfile for a Python Project**

A Jenkinsfile is a script that defines **automation steps**:

pipeline {

agent any

stages {

stage(\'Build Docker Image\') {

steps {

sh \'docker build -t my-python-app .\'

}

}

stage(\'Deploy\') {

steps {

sh \'docker run -p 5000:5000 my-python-app\'

}

}

}

}

This **automates building and running the application**.

**14. Kubernetes and Jenkins Deployment - 27-02-2025**

**What is Kubernetes?**

Kubernetes (**K8s**) is a system for **managing and scaling
containerized applications**.

**Project 1: Manually Deploying a Flask App on Kubernetes**

1.  **Write a Dockerfile** for Flask.

2.  **Define Kubernetes Configuration (deployment.yaml)**:

3.  apiVersion: apps/v1

4.  kind: Deployment

5.  metadata:

6.  name: flask-app

7.  spec:

8.  replicas: 2

9.  selector:

10. matchLabels:

11. app: flask-app

12. template:

13. metadata:

14. labels:

15. app: flask-app

16. spec:

17. containers:

18. \- name: flask-app

19. image: myapp:latest

20. ports:

21. \- containerPort: 5000

22. **Deploy to Kubernetes**:

23. kubectl apply -f deployment.yaml

**Project 2: Automating with Jenkins + Kubernetes**

-   Instead of manually running kubectl apply, Jenkins does it
    automatically.

-   **Jenkins Pipeline for CI/CD**:

-   pipeline {

-   stages {

-   stage(\'Build & Push Image\') {

-   steps {

-   sh \'docker build -t my-k8s-app .\'

-   sh \'docker push username/my-k8s-app:latest\'

-   }

-   }

-   stage(\'Deploy to Kubernetes\') {

-   steps {

-   sh \'kubectl apply -f deployment.yaml\'

-   }

-   }

-   }

-   }

-   **Final Outcome:** Every GitHub update **automatically triggers
    deployment** to Kubernetes.

**Summary of the Documents**

1.  **SQL Basics** (Creating, updating, deleting data).

2.  **Advanced SQL** (Joins, ranking, bitwise operations).

3.  **Database Design** (ER diagrams, normalization, stored procedures).

4.  **Git Basics** (Tracking and managing code changes).

5.  **Advanced Git** (Merging, resetting, stashing, rebasing).

6.  **Linux Basics** (File management, navigation, permissions).

7.  **Shell Scripting** (Automating tasks with scripts).

```{=html}
<!-- -->
```
8.  **Linux Advanced Commands** (Arrays, file tests, networking).

9.  **Text Processing & Automation** (grep, awk, crontab).

10. **Python Project Setup** (CLI tool packaging).

11. **Docker for Deployment** (Containers, Docker Hub).

12. **Jenkins for CI/CD** (Automating software builds).

13. **Jenkins + Python CI/CD** (Unit testing, Docker integration).

14. **Kubernetes Deployment** (Manual & Jenkins-based automation).
