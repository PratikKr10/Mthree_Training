# 🚀 React Project: Theme Switcher, Todo, Counter & Data Table

This document provides a **step-by-step guide** for setting up and understanding the **React project**.

---

## 📌 **1. Project Setup Commands**
Below are the commands used to set up this React project.

```bash
# Update system packages
sudo apt update

# Navigate to the project directory
cd basic-module/

# Install Node.js and npm
sudo apt install nodejs npm

# Check Node.js and npm versions
node -v
npm -v

# Install the latest Node.js version
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# Create a new React app named "hello-world"
npx create-react-app hello-world

# Navigate into the project folder
cd hello-world/

# List files in the project
ls -lrt

# Clear the terminal
clear

# Verify Node.js and npm versions again
node -v
npm -v

# View command history (Optional)
history
```

---

## 📌 **2. Project Structure**
This is the folder structure of the **hello-world** React project.

```
/hello-world
│── /public              # Static files (icons, manifest, robots.txt)
│── /src                 # Source code
│   ├── About.js         # About page component
│   ├── App.css          # CSS file for global styles
│   ├── App.js           # Main entry point of the React app
│   ├── Counter.js       # Counter component
│   ├── DataTable.js     # DataTable component
│   ├── Home.js          # Home page component
│   ├── ThemeSwitcher.js # Theme toggle component
│   ├── Todo.js          # Todo list component
│── package.json         # Project dependencies
│── package-lock.json    # Dependency tree
│── .gitignore           # Files to ignore in Git
│── README.md            # Documentation
```

---

## 📌 **3. Project Code Explanation**
This section explains **each file and its functionality**.

---

### ✅ **3.1 App.js**
**Purpose:**  
- The main **entry point** for the React application.
- Manages **navigation** between Home and About pages.
- Renders **Counter, Todo, ThemeSwitcher, and DataTable** components.

```jsx
import './App.css';
import Counter from './Counter';
import Todo from './Todo';
import ThemeSwitcher from './ThemeSwitcher';
import DataTable from './DataTable';
import { BrowserRouter as Router, Route, Routes, useNavigate } from 'react-router-dom';
import Home from './Home';
import About from './About';

function MainPage() {
  const navigate = useNavigate();

  return (
    <div className="App">
      <header className="App-header">
        <h1>Hello World</h1>

        {/* Navigation Buttons */}
        <button onClick={() => navigate('/home')}>Go to Home</button>
        <button onClick={() => navigate('/about')}>Go to About</button>

        {/* Render Components */}
        <Counter />
        <Todo />
        <ThemeSwitcher />
        <DataTable />
      </header>
    </div>
  );
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<MainPage />} />
        <Route path="/home" element={<Home />} />
        <Route path="/about" element={<About />} />
      </Routes>
    </Router>
  );
}

export default App;
```

---

### ✅ **3.2 App.css**
**Purpose:**  
- Handles global styles and **theme switching**.

```css
/* Theme styles */
.light {
  background-color: white !important;
  color: black !important;
}

.dark {
  background-color: black !important;
  color: white !important;
}

/* Override App-header styles to allow theme switching */
.App-header {
  min-height: 10vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
}

/* Ensure App-header follows theme */
.light .App-header {
  background-color: white !important;
  color: black !important;
}

.dark .App-header {
  background-color: black !important;
  color: white !important;
}

```

---

### ✅ **3.3 Counter.js**
**Purpose:**  
- A **simple counter** with **increment, decrement, and reset** buttons.

```jsx
import React, { useState } from 'react';

const Counter = () => {
    const [count, setCount] = useState(0);

    return (
        <div>
            <h1>Counter</h1>
            <p><center>{count}</center></p>
            <button onClick={() => setCount(count + 1)}>Increment</button>
            <button onClick={() => setCount(count - 1)}>Decrement</button>
            <button onClick={() => setCount(0)}>Reset</button>
        </div>
    );
};  
export default Counter;
```

---

### ✅ **3.4 DataTable.js**
**Purpose:**  
- Allows users to **add and display** Name, Address, and Email.

```jsx
import React, { useState } from 'react';

function DataTable() {
    const [name, setName] = useState('');
    const [address, setAddress] = useState('');
    const [email, setEmail] = useState('');
    const [entries, setEntries] = useState([]);

    const addEntry = () => {
        if (name.trim() && address.trim() && email.trim()) {
            setEntries([...entries, { name, address, email }]);
            setName('');
            setAddress('');
            setEmail('');
        }
    };

    return (
        <div style={{ textAlign: 'center', marginTop: '10px' }}>
            <h2>User Information</h2>

            {/* Input Form */}
            <div style={{ marginBottom: '10px' }}>
                <input
                    type="text"
                    placeholder="Enter Name"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    style={{ padding: '8px', marginRight: '5px' }}
                />
                <input
                    type="text"
                    placeholder="Enter Address"
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                    style={{ padding: '8px', marginRight: '5px' }}
                />
                <input
                    type="email"
                    placeholder="Enter Email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    style={{ padding: '8px', marginRight: '5px' }}
                />
                <button onClick={addEntry} style={{ padding: '8px' }}>Add Entry</button>
            </div>

            {/* Table Display */}
            {entries.length > 0 && (
                <table border="1" style={{ margin: 'auto', width: '80%', borderCollapse: 'collapse' }}>
                    <thead>
                        <tr style={{ backgroundColor: '#ddd' }}>
                            <th style={{ padding: '10px' }}>Name</th>
                            <th style={{ padding: '10px' }}>Address</th>
                            <th style={{ padding: '10px' }}>Email</th>
                        </tr>
                    </thead>
                    <tbody>
                        {entries.map((entry, index) => (
                            <tr key={index}>
                                <td style={{ padding: '10px' }}>{entry.name}</td>
                                <td style={{ padding: '10px' }}>{entry.address}</td>
                                <td style={{ padding: '10px' }}>{entry.email}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}
        </div>
    );
}

export default DataTable;

```

---

### ✅ **3.5 Todo.js**
```jsx
import React, { useState } from 'react';

function Todo() {
    const [todos, setTodos] = useState([]);
    const [input, setInput] = useState('');

    const addTodo = () => {
        if (input.trim() !== '') {
            setTodos([...todos, input]);
            setInput('');
        }
    };

    const removeTodo = (index) => {
        setTodos(todos.filter((_, i) => i !== index));
    };

    return (
        <div style={{ textAlign: 'center', marginTop: '20px' }}>
            <h1>Todo List</h1>
            <input
                type="text"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                placeholder="Add a todo"
                style={{ padding: '8px', marginRight: '5px' }}
            />
            <button onClick={addTodo} style={{ padding: '8px' }}>Add</button>
            <ul style={{ listStyle: 'none', padding: 0 }}>
                {todos.map((todo, index) => (
                    <li key={index} style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '10px', margin: '5px 0' }}>
                        {todo}
                        <button onClick={() => removeTodo(index)} style={{ padding: '5px', backgroundColor: 'red', color: 'white', border: 'none', cursor: 'pointer' }}>
                            Remove
                        </button>
                    </li>
                ))}
            </ul>
        </div>
    );
}

export default Todo;

```
--- 

### ✅ **3.6 Home.js**
```jsx
import React from 'react';

function Home() {
    return <div><h1>This is the Home page</h1></div>;
}

export default Home;
```

---

### ✅ **3.7 About.js**
```jsx
import React from 'react';

function About() {
    return <div><h1>This is the About page</h1></div>;
}

export default About;
```

---
### **📌 Total Learning from the React Project**
By working on this project, you have learned the following **key concepts in React**:

1️⃣ **React Router:**  
   - How to **set up navigation** between multiple pages using `react-router-dom`.  
   - How to use `<Routes>` and `<Route>` to manage different views.

2️⃣ **State Management (`useState`)**:  
   - Managing **dynamic values** like counter updates, todo lists, and form inputs.  
   - Handling **state changes** in a component.

3️⃣ **Component-Based Structure:**  
   - How to break a React app into **multiple reusable components**.  
   - How to **import and export** components properly.

4️⃣ **Event Handling in React:**  
   - Using `onClick`, `onChange`, and `useState` to **handle user interactions**.

5️⃣ **Dynamic UI Updates:**  
   - How React automatically **re-renders components** when state changes.

6️⃣ **Form Handling:**  
   - Capturing and storing **user input** using controlled components.

7️⃣ **Rendering Lists & Tables in React:**  
   - Using `.map()` to **dynamically generate lists** from an array (e.g., Todo List & Data Table).

8️⃣ **Styling in React:**  
   - Using **CSS files (`App.css`)** and **CSS classes** to apply styles dynamically.  
   - Switching themes by updating CSS classes.

9️⃣ **Theme Switching Using `useEffect`:**  
   - How to use `useEffect` to **apply side effects** (e.g., updating the theme dynamically).

10️⃣ **Building a Functional React App:**  
   - Combining multiple components into a **fully functional React project**.

---

### **🚀 Final Takeaway**
By completing this project, you now understand **React basics**, **state management**, **event handling**, and **dynamic UI updates**—all fundamental skills for any React developer! 
