# ANGULAR (WEEK-5, DAY-3)

After understanding **Node.js** and **React**, we were introduced to **Angular**, a powerful framework for building dynamic web applications.

---

## **ANGULAR OVERVIEW**
- **Angular** is an **open-source front-end framework** maintained by **Google**.
- It is used to build **dynamic and scalable web applications**.
- Angular is written in **TypeScript**, which later compiles into **JavaScript**.
- It follows a **component-based architecture**, making it easier to develop, test, and maintain applications.
- Provides built-in **dependency injection**, **modularization**, and **two-way data binding**.
- Angular applications run in the **browser** and follow a **Single Page Application (SPA)** model.

---

## **Installing Angular**
To get started with Angular, follow these installation steps:

### **1. Install Angular CLI**
The Angular CLI (Command Line Interface) is essential for creating, building, and managing Angular projects.
```bash
sudo npm install -g @angular/cli
```

### **2. Update npm (Optional but Recommended)**
Ensure you have the latest version of npm:
```bash
sudo npm install -g npm@11.2.0
```

### **3. Verify Installation**
To check if Angular is successfully installed, run:
```bash
ng version
```

### **4. Create a New Angular Project**
To create a fresh Angular application, use:
```bash
ng new first-hello-world
```
This command sets up the necessary files and dependencies required for an Angular application.

Once the setup is complete, navigate into the project folder and open it in your preferred code editor.

---

## **Understanding Angular’s Execution Flow**
Angular applications follow a structured execution flow:
1. The `app.component.html` file contains the main structure of the app.
2. The `index.html` file includes the necessary scripts and links to render the Angular app.
3. The browser reads the HTML and applies **default styles**.

### **Running the Project**
To start the Angular project and serve it in the browser, use:
```bash
ng serve
```
This compiles the application and makes it available at `http://localhost:4200/`.

---

## **Adding Styles and CSS**
Angular allows you to style your components using CSS files.

### **Example: Styling the Application**
1. Modify the `app.component.css` file:
```css
.container {
  background-color: gray;
  padding: 20px;
}
button {
  background-color: green;
  color: white;
  padding: 10px;
  border-radius: 5px;
}
```
2. Once added, the **background color of the container changes to gray**, and the **buttons turn green** with white text.

---

## **Working with Components**
### **Creating a Component**
Angular applications are built using components. To generate a new component, use:
```bash
ng g c my-component
```
This command creates:
- `my-component.component.ts` → The logic file.
- `my-component.component.html` → The template file.
- `my-component.component.css` → The styling file.

### **Example: Interactive UI (Hover Color Change)**
We built an app where **hovering over buttons changed their colors dynamically**.

#### **Key Files:**
- `app.component.html` → Defines a `div` with buttons.
- `app.component.css` → Styles the page and buttons.
- `app.component.ts` → Implements logic for changing colors dynamically.

### **Output Behavior:**
- **Clicking a button changes the background color dynamically**.

---

## **Routing in Angular**
Angular provides a powerful **routing mechanism** to switch between different pages without reloading the application.

### **Steps to Implement Routing:**

1. **Generate Components for Different Pages**
```bash
ng g c home
ng g c about
ng g c contact
```

2. **Modify `home.component.ts` to Include Navigation Methods:**
```typescript
navigateToAbout() {
  this.router.navigate(['/about']);
}
navigateToContact() {
  this.router.navigate(['/contact']);
}
```

3. **Define Routes in `app.routes.ts`:**
```typescript
const routes: Routes = [
  { path: 'home', component: HomeComponent },
  { path: 'about', component: AboutComponent },
  { path: 'contact', component: ContactComponent },
  { path: '', redirectTo: '/home', pathMatch: 'full' },
  { path: '**', redirectTo: '/home' }
];
```
- The **RouterModule** creates an internal routing structure based on these defined routes.
- When a user navigates to a URL, Angular matches it to a component and displays it.
- If no match is found, the wildcard route (`**`) redirects to `/home`.

### **Navigation Behavior:**
- Clicking **“Go to About”** → Redirects to the About page.
- Clicking **“Go to Home”** → Navigates back to the Home page.
- Clicking **“Go to Contact”** → Moves to the Contact page.

---

## **Afternoon Session Recap**
- We reviewed all topics covered in the session.
- Went through additional learning material in the **LMS (Learning Management System)**.
- Solved multiple **HackerRank problems** related to Angular and JavaScript.

---

## **Key Takeaways and Learnings**
- **Component-based Architecture**: Angular enforces modularity, making it easy to manage and scale applications.
- **Routing and Navigation**: Implementing routing helped in understanding **Single Page Applications (SPAs)**.
- **Dependency Injection**: Angular services can be injected into components to maintain data and logic.
- **Two-way Data Binding**: The ability to sync data between the model and the view improves reactivity in applications.
- **CLI Usage**: The Angular CLI provides powerful commands for scaffolding and managing applications efficiently.

---

This learning experience provided a solid foundation for Angular development. Moving forward, I plan to explore **services, state management, forms handling, and API integration** to deepen my understanding of the framework.
