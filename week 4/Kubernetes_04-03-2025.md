**🚀 What is Kubernetes?**

Kubernetes (K8s) is an **open-source container orchestration platform**
that helps **deploy, manage, and scale applications** automatically. It
ensures that applications **run reliably** without downtime, even if
some parts of the system fail.

**🤔 Why Do We Need Kubernetes?**

Imagine you have a **Flask web application** running inside a **Docker
container**. You need to:

-   Deploy it on **multiple servers** for reliability.

-   Automatically restart it if it **crashes**.

-   Distribute traffic to different instances (**load balancing**).

-   Scale it up/down based on **traffic load**.

Doing this manually is **painful**---this is where **Kubernetes helps**!

**🏠 Example: A Restaurant Analogy**

Think of **Kubernetes as a restaurant manager** who ensures food is
cooked, served, and ready for new customers.

  -------------------------------------------------------------------------
  **Kubernetes     **Restaurant         **Technical Meaning**
  Concept**        Analogy**            
  ---------------- -------------------- -----------------------------------
  **Pod**          A **chef** who       The **smallest deployable unit** in
                   prepares food        Kubernetes, runs containers

  **Container**    The **cooking        Runs your app (Flask, Node.js,
                   station**            etc.)

  **Deployment**   A **recipe** for     Defines how many **chefs (pods)**
                   cooking              should be available

  **Service**      The **waiter**       Exposes the app so customers
                   delivering food      (users) can access it

  **Liveness       A **health check**   If the chef **stops working**, the
  Probe**          for chefs            manager replaces them

  **Readiness      A **food quality     Ensures food is ready before
  Probe**          check**              serving

  **Scaling        Hiring **more        Kubernetes **adds/removes pods**
  (HPA)**          chefs** in rush      based on traffic
                   hours                

  **Ingress**      The **menu board     Routes different requests to
                   outside**            different apps
  -------------------------------------------------------------------------

**🎯 Setting Up the Project**

**Today, we worked on setting up a Kubernetes project (prac_k8s) using
Minikube.**

**Project Folder Structure**

prac_k8s/

├── k8s/ \# Stores all Kubernetes YAML files

│ ├── deployment.yaml \# Defines how many pods to run

│ ├── service.yaml \# Exposes the app to external users

├── app.py \# Flask application code

├── Dockerfile \# Instructions to build a Docker image

**⚙️ Steps We Followed Today**

**1️⃣ Setting Up Minikube**

-   **Started Minikube** to run Kubernetes locally:

-   minikube start

-   **Faced an issue** where the Kubernetes API server did not start
    properly.

-   **Solution:** Restarted Minikube:

-   minikube delete

-   minikube start

**2️⃣ Writing the Flask App (app.py)**

We created a **Flask web app** and added an endpoint (/hang) to
**simulate a failure**:

from flask import Flask

import os

import signal

import sys

app = Flask(\_\_name\_\_)

\@app.route(\"/\")

def home():

return \"Hello, Kubernetes!\"

\@app.route(\"/hang\")

def hang():

print(\"Simulating a full crash\...\")

sys.stdout.flush()

os.kill(os.getpid(), signal.SIGKILL) \# Forcefully kills the process

if \_\_name\_\_ == \"\_\_main\_\_\":

app.run(host=\"0.0.0.0\", port=5000)

**3️⃣ Creating a Docker Image**

-   **Built the image**:

-   docker build -t pratikkumar10/flask-app:v1 .

-   **Pushed the image to Docker Hub**:

-   docker push pratikkumar10/flask-app:v1

**4️⃣ Writing Kubernetes Deployment (k8s/deployment.yaml)**

Defines **how many pods** should run and includes **Liveness Probe**:

apiVersion: apps/v1

kind: Deployment

metadata:

name: flask-app

spec:

replicas: 2

selector:

matchLabels:

app: flask-app

template:

metadata:

labels:

app: flask-app

spec:

containers:

\- name: flask-container

image: pratikkumar10/flask-app:v1

ports:

\- containerPort: 5000

livenessProbe:

httpGet:

path: /

port: 5000

initialDelaySeconds: 3

periodSeconds: 5

timeoutSeconds: 1

failureThreshold: 2

-   **Applied the deployment**:

-   kubectl apply -f k8s/deployment.yaml

**5️⃣ Creating a Kubernetes Service (k8s/service.yaml)**

Defines how **users can access the app**:

apiVersion: v1

kind: Service

metadata:

name: flask-service

spec:

selector:

app: flask-app

ports:

\- protocol: TCP

port: 80

targetPort: 5000

type: NodePort

-   **Applied the service**:

-   kubectl apply -f k8s/service.yaml

-   **Got the service URL**:

-   minikube service flask-service \--url

**🔍 Problems We Faced & Solutions**

**🚨 1️⃣ Problem: Liveness Probe Not Restarting the Pod**

**Issue:**

-   When running:

-   kubectl exec -it flask-app-xxxxx \-- curl http://localhost:5000/hang

> The Flask app returned **500 Internal Server Error**, but **Kubernetes
> did NOT restart the pod**.

**Solution:**

1.  **Modified /hang to fully kill the process**:

2.  os.kill(os.getpid(), signal.SIGKILL)

3.  **Updated the Docker image**:

4.  docker build -t pratikkumar10/flask-app:v2 .

5.  docker push pratikkumar10/flask-app:v2

6.  **Updated Kubernetes deployment to use new image**:

7.  image: pratikkumar10/flask-app:v2

8.  **Deleted old pods to apply changes**:

9.  kubectl delete pod -l app=flask-app

**Final Test:**

-   Ran:

-   kubectl exec -it flask-app-xxxxx \-- curl http://localhost:5000/hang

-   **Result:** **Pod restarted successfully! 🎉**

**🚨 2️⃣ Problem: Kubernetes Cached Old Image**

**Issue:**

-   After pushing a new image, Kubernetes was still using an **old
    cached image**.

**Solution:**

-   **Forced Kubernetes to pull the latest image** by **deleting old
    pods**:

-   kubectl delete pod -l app=flask-app

-   **Verified new image was used**:

-   kubectl get pods -w

**🎯 What We Learned Today**

✅ **Kubernetes concepts (Pod, Deployment, Service, Liveness Probe)**\
✅ **How Minikube runs Kubernetes locally**\
✅ **How to containerize a Flask app with Docker**\
✅ **Deploying an app using Kubernetes YAML files**\
✅ **Configuring Liveness Probe to restart failing pods**\
✅ **Debugging issues (kubectl describe pod, logs)**\
✅ **Ensuring Kubernetes pulls the latest Docker image**
