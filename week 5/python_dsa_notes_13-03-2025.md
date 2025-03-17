# Python & DSA Comprehensive Notes - Week 5

---

## **Overview**

This document covers key concepts in **Angular vs React**, **Linux Commands**, and **Data Structures in Python**, including **Stacks and Trees**. It provides a **detailed yet easy-to-understand** explanation with **tables, code snippets, and diagrams** for clarity.

---

## **1. Angular vs React**

### **Angular**
- A **TypeScript-based** framework maintained by Google.
- Follows **Model-View-Controller (MVC)** and **Component-based** architecture.
- Used for building large-scale, **structured** web applications.

### **React**
- A **JavaScript library** maintained by Facebook.
- Uses **Component-based architecture** and **Virtual DOM** for performance optimization.
- Ideal for **dynamic, fast UI** applications.

### **Comparison Table**
| Feature             | Angular                          | React                              |
|---------------------|--------------------------------|----------------------------------|
| **Language**        | TypeScript                     | JavaScript                        |
| **Architecture**    | MVC + Component-based         | Component-based                   |
| **DOM Handling**    | Real DOM                      | Virtual DOM                        |
| **Performance**     | Slightly slower with updates  | Faster due to Virtual DOM         |
| **Data Binding**    | Two-way                        | One-way                            |
| **Learning Curve**  | Steeper                        | Easier                             |
| **Use Case**       | Large, structured apps        | Dynamic, fast UI apps             |

### **How Virtual DOM Works in React?**
1. When the **state changes**, React creates a **new Virtual DOM**.
2. It compares the **old Virtual DOM** with the **new one**.
3. Identifies changes (**diffing process**).
4. Updates **only the changed parts** of the Real DOM.
5. The **browser repaints** the updated elements.

**Diagram:**
```
Real DOM   ->   Virtual DOM   ->   Diffing   ->   Only updates changed parts
```

---

## **2. Linux Commands**
Some essential Linux commands for system monitoring and package management:

### **System Monitoring**
| Command                        | Description |
|--------------------------------|-------------|
| `free -h`                      | Displays memory usage |
| `top`                           | Shows running processes |
| `ps aux --sort -%mem | head`  | Lists top memory-consuming processes |

### **Networking**
| Command                        | Description |
|--------------------------------|-------------|
| `ping google.com`              | Checks network connectivity |
| `nslookup google.com`          | Gets DNS details of a domain |
| `ifconfig`                     | Displays network interface details |

### **Package Management**
| Command                        | Description |
|--------------------------------|-------------|
| `sudo apt update`              | Updates package lists |
| `apt list --upgradable`        | Shows upgradable packages |
| `sudo apt install <package>`   | Installs a package |
| `sudo apt remove <package>`    | Removes a package |

---

## **3. Data Structures in Python**

### **Stacks**
- A **Last-In-First-Out (LIFO)** data structure.
- Used in **undo mechanisms**, **browser history**, **function calls**, etc.

### **Operations on Stack**
| Operation    | Description |
|-------------|-------------|
| `push(x)`   | Adds `x` to the stack |
| `pop()`     | Removes and returns the top element |
| `peek()`    | Returns the top element without removing it |
| `is_empty()`| Checks if the stack is empty |

### **Python Implementation**
```python
class Stack:
    def __init__(self):
        self.items = []
    def push(self, item):
        self.items.append(item)
    def pop(self):
        return self.items.pop() if not self.is_empty() else None
    def peek(self):
        return self.items[-1] if not self.is_empty() else None
    def is_empty(self):
        return len(self.items) == 0
```

### **Diagram: Stack Operations**
```
Push(10)  ->  [10]
Push(20)  ->  [10, 20]
Pop()     ->  [10]  (returns 20)
```

---

### **Trees in Python**
- A **hierarchical data structure** used in databases, file systems, AI, etc.

### **Basic Tree Terminology**
| Term      | Description |
|-----------|-------------|
| **Root**  | The starting node |
| **Parent**| A node that has children |
| **Child** | A node connected to another node above it |
| **Leaf**  | A node with no children |
| **Edge**  | Connection between nodes |

### **Python Implementation of a Tree**
```python
class TreeNode:
    def __init__(self, value):
        self.value = value
        self.children = []
    def add_child(self, child):
        self.children.append(child)
```

### **Diagram: Basic Tree Structure**
```
        Root
       /    \
   Node1   Node2
    /
ChildNode
```

---

## **4. HackerRank Python Practice**
- Solved Python problems covering **strings, lists, dictionaries, and recursion**.
- Practiced **algorithmic thinking** and **time complexity analysis**.

---

## **Conclusion**
- Revised **Angular & React** differences.
- Learned **Linux commands** for system monitoring and package management.
- Studied **Stack & Tree** data structures in Python.
- Practiced **DSA problems** on HackerRank.
---

