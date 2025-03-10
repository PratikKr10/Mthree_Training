# **SQLAlchemy, NumPy, Pandas, MySQL & SQLite Setup Guide**

---

## **📌 1️⃣ NumPy Basics**
NumPy is a fundamental library for numerical computing in Python. It provides support for:
- Creating arrays and matrices
- Performing mathematical operations on arrays
- Performing statistical operations
- Conducting linear algebra operations
- Executing Fourier transformations
- Random number generation
- Various regression techniques (linear, polynomial, exponential, logarithmic, power)

### **1️⃣ Creating NumPy Arrays**
```python
import numpy as np

# 1D Array
arr = np.array([1, 2, 3, 4, 5])

# 2D Array (Matrix)
arr_2d = np.array([[1, 2, 3], [4, 5, 6]])

# Random array
arr_random = np.random.rand(3, 4)

# Arrays with default values
zeros_array = np.zeros((3, 4))
ones_array = np.ones((3, 4))
full_array = np.full((3, 4), 10)
```

### **2️⃣ Matrix Operations**
```python
matrix_1 = np.array([[1, 2, 3], [4, 5, 6]])
matrix_2 = np.array([[1, 2, 3], [4, 5, 6]])

# Addition, Subtraction, Multiplication, Division
matrix_add = matrix_1 + matrix_2
matrix_sub = matrix_1 - matrix_2
matrix_mul = matrix_1 * matrix_2
matrix_div = matrix_1 / matrix_2

# Matrix Transpose
matrix_transpose = matrix_1.T
```

### **3️⃣ Statistical Operations**
```python
# Mean, Median, Standard Deviation, Variance
arr_mean = np.mean(arr)
arr_median = np.median(arr)
arr_std = np.std(arr)
arr_var = np.var(arr)
```

---

## **📌 2️⃣ Pandas Basics**
Pandas is used for handling structured data like tables, CSVs, and databases.

### **1️⃣ Creating Series and DataFrames**
```python
import pandas as pd

# Creating a Series
series = pd.Series([1, 2, 3, 4, 5])

# Creating a DataFrame
data = {
    'Name': ['John', 'Jane', 'Jim', 'Jill'],
    'Age': [20, 21, 22, 23],
    'City': ['New York', 'Los Angeles', 'Chicago', 'Houston']
}

df = pd.DataFrame(data)
```

---

# **📌 3️⃣ Setting Up MySQL for SQLAlchemy**

### **Step 1: Start MySQL**
```sh
sudo service mysql start
```

### **Step 2: Log in as Root**
```sh
sudo mysql -u root -p
```

### **Step 3: Create a New Database**
```sql
CREATE DATABASE sqlAlchemy;
```

### **Step 4: Create a New User**
```sql
DROP USER IF EXISTS 'pratik'@'localhost';
CREATE USER 'pratik'@'localhost' IDENTIFIED BY 'pratik';
```

### **Step 5: Grant Privileges**
```sql
GRANT ALL PRIVILEGES ON sqlAlchemy.* TO 'pratik'@'localhost';
FLUSH PRIVILEGES;
```

### **Step 6: Verify User**
```sql
SELECT user, host FROM mysql.user;
```

### **Step 7: Exit MySQL**
```sql
EXIT;
```

---

# **📌 4️⃣ Linking SQLAlchemy with MySQL**

### **Step 8: Activate Virtual Environment**
```sh
source /home/pratik/basic-module/venv/bin/activate
```

### **Step 9: Install Dependencies**
```sh
pip install sqlalchemy pymysql cryptography
```

### **Step 10: Create a Python Script to Test Connection**
Create a new Python file (`database_test.py`):
```python
from sqlalchemy import create_engine, text

USER = "pratik"  
PASSWORD = "pratik"  
HOST = "127.0.0.1"  
PORT = "3306"
DATABASE = "sqlAlchemy"

DATABASE_URL = f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}/{DATABASE}"

engine = create_engine(DATABASE_URL)

with engine.connect() as connection:
    result = connection.execute(text("SELECT DATABASE();"))
    for row in result:
        print(row)
```

### **Step 11: Run the Script**
```sh
python3 database_test.py
```
✅ If you see `('sqlAlchemy',)`, your connection is **successful**! 🎉

---

# **📌 5️⃣ Setting Up SQLite with SQLAlchemy**

### **Step 1: Creating a Database Directory**
```sh
mkdir -p ~/databases
```

### **Step 2: Moving the Database File**
```sh
mv /home/pratik/basic-module/data.db ~/databases/
```

### **Step 3: Checking If the File Exists**
```sh
ls -l ~/databases/data.db
```

### **Step 4: Running the Python Script (`temp.py`)**
```sh
python3 /home/pratik/basic-module/numerical/temp.py
```

---

## **📌 6️⃣ SQLite + SQLAlchemy Database Script**
```python
from sqlalchemy import create_engine, text, MetaData, Table, Column, Integer, String, ForeignKey, insert, select

# Define database path
db_path = "/home/pratik/databases/data.db"
engine = create_engine(f'sqlite:///{db_path}', echo=True)

# Define metadata
metadata = MetaData()

# Define Users Table
users = Table('users', metadata,
    Column('id', Integer, primary_key=True),
    Column('name', String, nullable=False),
    Column('age', Integer, nullable=False),
    Column('city', String, nullable=False),
)

# Define Posts Table
posts = Table('posts', metadata,
    Column('id', Integer, primary_key=True),
    Column('title', String, nullable=False),
    Column('content', String, nullable=False),
    Column('user_id', Integer, ForeignKey('users.id')),
)

# Create Tables
metadata.create_all(engine)

# Insert Data
with engine.connect() as con:
    insert_stmt = insert(users).values(name='John', age=20, city='New York')
    result = con.execute(insert_stmt)
    print(f"Inserted {result.rowcount} row(s) into users table.")

    insert_stmt = insert(posts).values(title='Post 1', content='Content 1', user_id=1)
    result = con.execute(insert_stmt)
    print(f"Inserted {result.rowcount} row(s) into posts table.")

    con.commit()
```

---

## **📌 7️⃣ Best Practices for SQLAlchemy**
✅ **Use `sessionmaker()`**: Avoid creating new sessions manually every time.  
✅ **Always handle exceptions**: Rollback transactions on errors.  
✅ **Use `.close()` on sessions**: Prevent memory leaks.  
✅ **Use `Base.metadata.create_all(engine)` only once**: Ensures tables are created only when necessary.  
✅ **Use `try-except-finally` when interacting with the database**: Ensures proper error handling.  

---
