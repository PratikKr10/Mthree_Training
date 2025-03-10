### **Python OOP, Exceptions, and File Operations**

## **1. Object-Oriented Programming (OOP) Concepts in Python**

### **1.1 Inheritance**
- Inheritance allows a class to inherit properties and behavior from another class.

#### **Example**
```python
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        print(f"Animal {self.name} is speaking")

class Dog(Animal):
    def speak(self):
        print(f"Dog {self.name} is barking")

dog = Dog("Buddy")
dog.speak()  # Output: Dog Buddy is barking
```

---

### **1.2 Polymorphism**
- The ability of different classes to have methods with the same name but different implementations.

#### **Example**
```python
class Cat(Animal):
    def speak(self):
        print(f"Cat {self.name} is meowing")

class Bird(Animal):
    def speak(self):
        print(f"Bird {self.name} is chirping")

cat = Cat("Kitty")
bird = Bird("Sparrow")

cat.speak()   # Output: Cat Kitty is meowing
bird.speak()  # Output: Bird Sparrow is chirping
```

---

### **1.3 Method Overriding**
- A child class provides a specific implementation of a method that is already defined in the parent class.

#### **Example**
```python
class Dog(Animal):
    def speak(self):
        print(f"Dog {self.name} is barking")

dog = Dog("Buddy")
dog.speak()  # Output: Dog Buddy is barking
```

---

### **1.4 Method Overloading (Simulated using Default Arguments)**
- Python does not support true method overloading. Instead, we use default arguments.

#### **Example**
```python
class Dog(Animal):
    def speak(self, age=0):
        return f"Dog {self.name} is barking and {age} years old"

dog = Dog("Buddy")
print(dog.speak())      # Output: Dog Buddy is barking and 0 years old
print(dog.speak(10))    # Output: Dog Buddy is barking and 10 years old
```

---

### **1.5 Abstraction (Using Abstract Base Classes)**
- Abstraction allows defining a base class with abstract methods that must be implemented in child classes.

#### **Example**
```python
from abc import ABC, abstractmethod

class Animal(ABC):
    def __init__(self, name):
        self.name = name

    @abstractmethod
    def speak(self):
        pass

class Dog(Animal):
    def speak(self):
        print(f"Dog {self.name} is barking")

dog = Dog("Buddy")
dog.speak()
```

---

### **1.6 Encapsulation (Using Getters and Setters)**
- Encapsulation restricts direct access to variables and allows modification via methods.

#### **Example**
```python
class Person:
    def __init__(self, name):
        self.__name = name  # Private variable

    def get_name(self):
        return self.__name

    def set_name(self, name):
        self.__name = name

p = Person("John")
print(p.get_name())  # Output: John
p.set_name("Doe")
print(p.get_name())  # Output: Doe
```

---

### **1.7 Constructor and Destructor**
#### **Constructor (`__init__`)**
- Used for object initialization.

#### **Destructor (`__del__`)**
- Automatically called when an object is deleted.

#### **Example**
```python
class Demo:
    def __init__(self):
        print("Constructor is called")

    def __del__(self):
        print("Destructor is called")

obj = Demo()  # Constructor is called
del obj       # Destructor is called
```

---

### **1.8 Shallow Copy vs. Deep Copy**
#### **Shallow Copy**
- Creates a new object but does not create copies of nested objects.

#### **Deep Copy**
- Creates a new object along with new copies of all nested objects.

#### **Example**
```python
import copy

class Address:
    def __init__(self, city, country):
        self.city = city
        self.country = country

class Person:
    def __init__(self, name, address):
        self.name = name
        self.address = address

# Create instances
address = Address("New York", "USA")
person = Person("John", address)

# Create copies
shallow_person = copy.copy(person)
deep_person = copy.deepcopy(person)

# Modify original object
person.address.city = "Boston"

# Checking the impact
print(shallow_person.address.city)  # Output: Boston (affected)
print(deep_person.address.city)     # Output: New York (not affected)
```

---

## **2. Exception Handling**
### **2.1 Handling Built-in Exceptions**
```python
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Error: Cannot divide by zero!")
finally:
    print("Finally block executed")
```

### **2.2 Custom Exception Handling**
```python
class CustomException(Exception):
    def __init__(self, message):
        self.message = message
        super().__init__(self.message)

try:
    raise CustomException("This is a custom exception")
except CustomException as e:
    print(e)
finally:
    print("Finally block executed")
```

---

## **3. File Operations**
### **3.1 Creating and Writing to a File**
```python
with open("test.txt", "w") as file:
    file.write("Hello, World!")
```

---

### **3.2 Reading a File**
```python
with open("test.txt", "r") as file:
    print(file.read())
```

---

### **3.3 Appending to a File**
```python
with open("test.txt", "a") as file:
    file.write("\nHello Again!")
```

---

### **3.4 Checking if a File Exists**
```python
import os
if os.path.exists("test.txt"):
    print("File exists")
else:
    print("File does not exist")
```

---

### **3.5 Deleting a File**
```python
os.remove("test.txt")
```

---

### **3.6 Getting File Information**
```python
print(os.path.getsize("test.txt"))  # File size
print(os.path.getmtime("test.txt")) # Last modified time
print(os.path.basename("test.txt")) # File name
print(os.path.abspath("test.txt"))  # Absolute path
```

---

## **4. Running the Script**
```python
if __name__ == "__main__":
    main()
```


