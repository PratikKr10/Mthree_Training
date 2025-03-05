### 📜 **`k8s_project_explained.md`** - Kubernetes Zero to Hero (Week 4)

# 🚀 Kubernetes Zero to Hero - Detailed Project Documentation

## 📌 Introduction

This project is a **fully containerized Python Flask application** deployed on a **Kubernetes cluster using Minikube**. It demonstrates:

✅ **Containerization using Docker**  
✅ **ConfigMaps & Secrets for configurations**  
✅ **Persistent & Ephemeral Volumes (WSL2 compatible)**  
✅ **Replica management using Deployments**  
✅ **Service exposure using NodePort & Port Forwarding**  
✅ **Resource limits, scaling, and monitoring using HPA**  
✅ **Liveness & Readiness Probes for Health Checks**  

The project is **optimized for WSL2**, avoiding common issues like **host path mounting problems** in Kubernetes.

---

## 📁 **Project Structure**

Mthree_Training/week4/
├── k8s-master-app/            # Main project directory
│   ├── app/                   # Python Flask application
│   │   ├── app.py             # Main Flask application (Logging Fix Included)
│   │   ├── Dockerfile         # Containerization instructions
│   │   ├── requirements.txt   # Required Python libraries
│   ├── config/                # Sample configuration files
│   │   ├── sample-config.txt
│   ├── data/                  # Sample data for volume testing
│   │   ├── hello.txt
│   │   ├── info.txt
│   ├── k8s/                   # Kubernetes configurations
│   │   ├── base/              # Core resources
│   │   │   ├── deployment.yaml
│   │   │   ├── namespace.yaml
│   │   ├── config/            # Configuration management
│   │   │   ├── configmap.yaml
│   │   │   ├── secret.yaml
│   │   ├── monitoring/        # Monitoring and scaling configurations
│   │   │   ├── hpa.yaml
│   │   ├── networking/        # Service definitions
│   │   │   ├── service.yaml
│   │   ├── volumes/           # Volume configurations
│   │   │   ├── volumes.yaml
│   ├── logs/                   # Stores application logs
│   ├── scripts/                # Deployment & Management Scripts
│   │   ├── deploy.sh           # Deploys the application
│   │   ├── cleanup.sh          # Cleans up the deployment
│   │   ├── test-app.sh         # Tests application functionality
│   ├── README.md               # General overview
│   ├── kubernetes-cheatsheet.md # Kubernetes command reference
│   ├── k8s_project_explained.md # Detailed documentation (this file)


## 🏗️ **Step-by-Step Setup & Deployment**

### **1️⃣ Run the fixed-k8s.sh script**
```bash
./fixed-k8s.sh
```

### **2️⃣ After that go to k8s-master-app and run ./scripts/deploy.sh**

```bash
cd k8s-master-app
./scripts/deploy.sh
```

### **3️⃣ After deployment we needed a fix in the app.py**
We changed these lines 
```bash
# Set up logging to print to console and file

logging.basicConfig(
	level=logging.INFO,
	format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
	handlers=[
		logging.StreamHandler(sys.stdout),
		logging.FileHandler(os.e./scripts/deploy.shnviron.get('LOG_PATH', '/app/app.log'))
]
)
```
to these:
```bash
# Set up logging to print to console and file

log_file = os.path.join(os.environ.get('LOG_PATH', '/logs'), 'app.log')
logging.basicConfig(
	level=logging.INFO,
	format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
	handlers=[
		logging.StreamHandler(),
		logging.FileHandler(log_file)
]
)
```
### **4️⃣ Change Directory to the App Folder**
```bash
cd ~/k8s-master-app/app
```


### **5️⃣Rebuild the Docker Image**
```bash
docker build -t k8s-master-app:latest .
```
This ensures the latest app.py changes are included in the container.



### **6️⃣Delete Existing Pods**
```bash
kubectl delete pod -l app=k8s-master -n k8s-demo
```
This will force Kubernetes to pull the updated container.



### **7️⃣Move Back to the Project Root**
```bash
cd ..
```
### **8️⃣Redeploy the Application**
```bash
./scripts/deploy.sh
```
This will redeploy the updated image with the fixed logging setup. 



## 🎯 **Testing the Application**

```bash
./scripts/test-app.sh

```

This script tests:

-   **Homepage availability** (`/`)
-   **Health check API** (`/api/health`)
-   **Application Info API** (`/api/info`)
-   **Metrics API** (`/api/metrics`)

----------

##  Explanation of `app.py`

This script is a **Flask-based web application** designed to demonstrate how a containerized application interacts with **Kubernetes features** such as **mounted volumes, environment variables, health checks, and resource monitoring**.

----------

### **1. Importing Required Modules**

At the top, we import necessary Python libraries:

```python
from flask import Flask, jsonify, render_template_string, request, redirect, url_for
import os
import socket
import datetime
import json
import logging
import uuid
import platform
import psutil  # For resource usage statistics
import time
import threading
import sys

```

-   `Flask` - Web framework for handling HTTP requests.
-   `os` - For working with environment variables and file paths.
-   `socket` - Fetches the hostname of the system (useful in Kubernetes).
-   `datetime` - Handles timestamps.
-   `json` - Works with JSON data.
-   `logging` - Logs events to files and console.
-   `uuid` - Generates a unique instance ID (useful for Kubernetes pods).
-   `platform` - Retrieves system details (OS, Python version, etc.).
-   `psutil` - Monitors system resource usage (CPU, Memory, Disk).
-   `time` - Works with time-related functions.
-   `threading` - Runs background tasks.

----------

### **2. Initializing the Flask App**

```python
app = Flask(__name__)

```

This creates a Flask web application.

----------

### **3. Setting Up Logging**

The application logs important events to a file and console.

```python
log_file = os.path.join(os.environ.get('LOG_PATH', '/logs'), 'app.log')
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),  # Print logs to console
        logging.FileHandler(log_file)  # Store logs in a file
    ]
)
logger = logging.getLogger('k8s-master-app')

```

-   Logs are stored in a **mounted volume** (`LOG_PATH`).
-   If `LOG_PATH` is not set, logs are stored in `/logs/app.log`.

----------

### **4. Reading Configuration and Secrets**

```python
APP_NAME = os.environ.get('APP_NAME', 'k8s-master-app')
APP_VERSION = os.environ.get('APP_VERSION', '1.0.0')
ENVIRONMENT = os.environ.get('ENVIRONMENT', 'development')
DATA_PATH = os.environ.get('DATA_PATH', '/data')
CONFIG_PATH = os.environ.get('CONFIG_PATH', '/config')
LOG_PATH = os.environ.get('LOG_PATH', '/logs')
SECRET_KEY = os.environ.get('SECRET_KEY', 'default-dev-key')
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'default-password')

```

-   Reads **ConfigMaps** (application settings).
-   Reads **Secrets** (sensitive data like `SECRET_KEY`, `DB_PASSWORD`).
-   Default values are used if environment variables are not set.

----------

### **5. Generating a Unique Instance ID**

```python
INSTANCE_ID = str(uuid.uuid4())[:8]

```

-   Generates an 8-character unique ID for each **container instance**.
-   Helps differentiate logs from different Kubernetes pods.

----------

### **6. Tracking Requests and Metrics**

```python
request_count = 0
start_time = time.time()
metrics = {
    'requests': 0,
    'errors': 0,
    'data_reads': 0,
    'data_writes': 0
}

```

-   `request_count`: Counts the number of requests.
-   `start_time`: Records when the app started.
-   `metrics`: Stores statistics like total requests, errors, and file operations.

----------

### **7. Background Worker for Resource Usage**

This function simulates CPU usage.

```python
def background_worker():
    logger.info("Background worker started")
    counter = 0
    while True:
        counter += 1
        if counter % 1000 == 0:
            logger.debug(f"Background worker tick: {counter}")
        time.sleep(0.1)

```

-   **Runs in a separate thread** to mimic real-world workload.
-   Logs every **1000 operations**.

#### **Starting the Worker Thread**

```python
worker_thread = threading.Thread(target=background_worker, daemon=True)
worker_thread.start()

```

-   Runs the worker **in the background** without blocking the main app.

----------

### **8. Homepage (`/`) - Displays System Info and Mounted Volumes**

```python
@app.route('/')
def index():
    global request_count, metrics
    request_count += 1
    metrics['requests'] += 1

```

-   Increments request counters for **tracking app usage**.

#### **Fetching System Information**

```python
system_info = {
    'hostname': socket.gethostname(),
    'platform': platform.platform(),
    'python_version': platform.python_version(),
    'cpu_count': psutil.cpu_count(),
    'memory': f"{psutil.virtual_memory().total / (1024 * 1024):.1f} MB",
    'uptime': f"{time.time() - start_time:.1f} seconds"
}

```

-   Retrieves **CPU, Memory, and Uptime details**.

#### **Checking Mounted Volumes**

```python
try:
    data_files = os.listdir(DATA_PATH)
    volumes['data'] = {'path': DATA_PATH, 'files': data_files, 'status': 'mounted' if data_files else 'empty'}
    metrics['data_reads'] += 1
except Exception as e:
    volumes['data'] = {'path': DATA_PATH, 'error': str(e), 'status': 'error'}

```

-   Lists files in the **mounted volumes** (`/data`, `/config`, `/logs`).
-   If an error occurs, it logs it.

#### **Rendering the HTML Page**

```python
return render_template_string(html_content, app_name=APP_NAME, ...)

```

-   **Dynamically generates** an HTML page with system stats and file information.

----------

### **9. File Viewing (`/view-file`)**

```python
@app.route('/view-file')
def view_file():
    file_path = request.args.get('path', '')
    if not file_path.startswith((DATA_PATH, CONFIG_PATH, LOG_PATH)):
        return "Access denied", 403

```

-   **Security check**: Ensures only files inside mounted volumes are accessible.
-   Prevents **path traversal attacks**.

----------

### **10. File Creation (`/create-file`)**

```python
@app.route('/create-file', methods=['GET', 'POST'])
def create_file():
    if request.method == 'POST':
        filename = request.form.get('filename', '')
        content = request.form.get('content', '')
        file_path = os.path.join(DATA_PATH, filename)

```

-   Allows users to **create files** inside the `/data` volume.

**Security Features:**

```python
if '..' in filename or '/' in filename:
    return "Invalid filename. Directory traversal not allowed.", 400

```

-   Prevents **directory traversal attacks**.

----------

### **11. API for Application Info (`/api/info`)**

```python
@app.route('/api/info')
def api_info():
    return jsonify({
        'app_name': APP_NAME,
        'version': APP_VERSION,
        'environment': ENVIRONMENT,
        'hostname': socket.gethostname(),
        'request_count': request_count
    })

```

-   Returns **application metadata** in JSON format.

----------

### **12. Health Check (`/api/health`)**

```python
@app.route('/api/health')
def health_check():
    data_ok = os.path.exists(DATA_PATH) and os.access(DATA_PATH, os.R_OK)
    config_ok = os.path.exists(CONFIG_PATH) and os.access(CONFIG_PATH, os.R_OK)
    logs_ok = os.path.exists(LOG_PATH) and os.access(LOG_PATH, os.W_OK)

```

-   Checks if **mounted volumes are accessible**.
-   **Kubernetes liveness and readiness probes** use this to restart unhealthy containers.

----------

### **13. Metrics API (`/api/metrics`)**

```python
@app.route('/api/metrics')
def get_metrics():
    return jsonify({
        'system': {'cpu_percent': psutil.cpu_percent(), 'memory_used_percent': psutil.virtual_memory().percent},
        'application': metrics
    })

```

-   Returns **CPU, memory usage, and request counts**.

----------

### **14. Running the App (`if __name__ == '__main__'`)**

```python
if __name__ == '__main__':
    print(f"Starting {APP_NAME} v{APP_VERSION} in {ENVIRONMENT} mode")
    app.run(host='0.0.0.0', port=5000, debug=True)

```

-   Runs Flask server on **port 5000**.

### **Conclusion**

-   This app **monitors Kubernetes environments**.
-   Implements **mounted volumes, logging, health checks, and metrics**.
-   Security features prevent **unauthorized access**.

## **Explanation of the Kubernetes deployment.yaml**

This YAML file describes how Kubernetes should **deploy and manage a set of identical pods** that run the **`k8s-master-app`**.

Think of it as a **restaurant manager** who ensures there are always enough **chefs (pods)** working in the kitchen. If a chef **quits or gets sick**, the manager **hires a new one** to maintain the desired staffing level. 🏢👨‍🍳

----------

### **1. Basic Information**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-master-app
  namespace: k8s-demo
  labels:
    app: k8s-master

```

-   `apiVersion: apps/v1` → Uses the **apps/v1** API for managing deployments.
-   `kind: Deployment` → Declares that this is a **Deployment** (not just a single Pod).
-   `metadata` → Contains information about the Deployment:
    -   `name: k8s-master-app` → Unique name of the Deployment.
    -   `namespace: k8s-demo` → Runs in the **k8s-demo namespace** (isolates resources).
    -   `labels` → Tags the Deployment with a label `app: k8s-master` for **easy selection**.

----------

### **2. Scaling and Update Strategy**

```yaml
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1

```

-   `replicas: 2` → Ensures **at least 2 running pods** of this application.
-   `strategy: RollingUpdate` → Updates pods **one by one** instead of all at once.
-   `maxUnavailable: 1` → Only **1 pod can be unavailable** during an update.
-   `maxSurge: 1` → Kubernetes can create **1 extra pod** while updating.

🔹 **Why?**  
This ensures **zero downtime** during deployments by updating one pod at a time.

----------

### **3. Selecting Pods**

```yaml
  selector:
    matchLabels:
      app: k8s-master

```

-   Kubernetes **finds and manages** pods that have the label **`app: k8s-master`**.
-   Ensures only the right pods are handled.

----------

### **4. Defining the Pod Template**

```yaml
  template:
    metadata:
      labels:
        app: k8s-master

```

-   **Every new pod** created by this Deployment **inherits these labels**.
-   Helps in identifying and managing pods.

----------

### **5. Exposing Metrics for Monitoring**

```yaml
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/path: "/api/metrics"
        prometheus.io/port: "5000"

```

-   **Annotations** provide extra instructions for monitoring.
-   **Prometheus** (a monitoring tool) will **collect metrics** from `/api/metrics` on port `5000`.

----------

### **6. Specifying Containers**

```yaml
      containers:
      - name: k8s-master-app
        image: k8s-master-app:latest
        imagePullPolicy: Never

```

-   `name: k8s-master-app` → Defines the **container name**.
-   `image: k8s-master-app:latest` → Uses a **Docker image** called `k8s-master-app:latest`.
-   `imagePullPolicy: Never` → Prevents Kubernetes from pulling the image from a registry (**useful in Minikube**).

----------

### **7. Exposing Ports**

```yaml
        ports:
        - containerPort: 5000
          name: http

```

-   The application runs on **port 5000** inside the container.

----------

### **8. Using Environment Variables**

```yaml
        envFrom:
        - configMapRef:
            name: app-config
        - secretRef:
            name: app-secrets

```

-   Pulls **configuration** from a **ConfigMap** (`app-config`).
-   Pulls **secrets** (like database passwords) from a **Secret** (`app-secrets`).

----------

### **9. Mounting Volumes**

```yaml
        volumeMounts:
        - name: data-volume
          mountPath: /data
          readOnly: false
        - name: config-volume
          mountPath: /config
          readOnly: true
        - name: logs-volume
          mountPath: /logs
          readOnly: false
        - name: config-files
          mountPath: /config-files
          readOnly: true

```

-   Attaches **volumes** (storage) to the container.
-   `/data` → Read/write storage for app data.
-   `/config` → Read-only configuration files.
-   `/logs` → Stores logs.
-   `/config-files` → Read-only sample configuration files.

----------

### **10. Setting Resource Limits**

```yaml
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"

```

-   `requests` → **Minimum** guaranteed resources.
-   `limits` → **Maximum** resources the container can use.
-   Prevents **overloading** the node by limiting CPU and memory usage.

----------

### **11. Health Checks**

#### **Liveness Probe (Is the app still running?)**

```yaml
        livenessProbe:
          httpGet:
            path: /api/health
            port: http
          initialDelaySeconds: 30
          periodSeconds: 30
          timeoutSeconds: 5
          failureThreshold: 3

```

-   Checks **every 30 seconds** if the app responds on `/api/health`.
-   If **3 failures** occur, Kubernetes **restarts the container**.

#### **Readiness Probe (Is the app ready for traffic?)**

```yaml
        readinessProbe:
          httpGet:
            path: /api/health
            port: http
          initialDelaySeconds: 15
          periodSeconds: 10
          timeoutSeconds: 3

```

-   Checks **every 10 seconds** if the app is ready.
-   If it **fails**, Kubernetes will **not send traffic** to it.

----------

### **12. Handling Start and Stop Events**

```yaml
        lifecycle:
          postStart:
            exec:
              command: ["/bin/sh", "-c", "echo 'Container started' > /logs/container.log"]
          preStop:
            exec:
              command: ["/bin/sh", "-c", "echo 'Container stopping' >> /logs/container.log"]

```

-   `postStart` → Runs **after** the container starts (`echo 'Container started'`).
-   `preStop` → Runs **before** the container stops (`echo 'Container stopping'`).
-   Useful for **logging startup and shutdown events**.

----------

### **13. Defining Volumes**

```yaml
      volumes:
      - name: data-volume
        emptyDir: {}
      - name: config-volume
        emptyDir: {}
      - name: logs-volume
        emptyDir: {}
      - name: config-files
        configMap:
          name: app-files

```

-   `emptyDir: {}` → Creates a **temporary directory** for each pod.
-   `config-files` → Mounts the `app-files` ConfigMap.

----------

### **14. Initializing Data Before Starting**

```yaml
      initContainers:
      - name: init-volumes
        image: busybox
        command: ["/bin/sh", "-c", "cp /config-files/* /data/ && echo 'Volumes initialized' > /logs/init.log"]
        volumeMounts:
        - name: data-volume
          mountPath: /data
        - name: logs-volume
          mountPath: /logs
        - name: config-files
          mountPath: /config-files

```

-   **Before** starting the app, an **init container**:
    -   Copies sample config files to `/data/`.
    -   Writes `Volumes initialized` to the log.
-   Ensures the app starts with the **necessary files**.

----------

### **💡 Summary**

-   **Manages multiple pods** to ensure availability.
-   **Updates pods smoothly** (RollingUpdate).
-   **Monitors pod health** using probes.
-   **Uses environment variables** for configuration.
-   **Mounts volumes** for data storage.
-   **Prepares the app environment** with an init container.

This ensures **high availability, reliability, and scalability** in a Kubernetes cluster. 🚀
## **Explanation: Kubernetes namespace.yaml**

#### **📌 What is a Namespace in Kubernetes?**

A **namespace** is like a **separate apartment** in a big building.

-   Just like different tenants in an apartment **have their own space**, different applications in a Kubernetes cluster **can have their own isolated environments** using namespaces.
-   This helps **organize, isolate, and control resources** within the cluster.

----------

### **🔍 Breakdown of the YAML File**

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: k8s-demo
  labels:
    name: k8s-demo
    environment: demo
    app: k8s-master

```

#### **1️⃣ `apiVersion: v1`**

-   This tells Kubernetes that we are **creating a namespace** using the **v1 API**.

#### **2️⃣ `kind: Namespace`**

-   This specifies that we are **defining a namespace**.

#### **3️⃣ `metadata` (Basic Information)**

-   `name: k8s-demo` → The name of this namespace is **`k8s-demo`**.
    -   Everything inside this namespace is **separate** from resources in other namespaces.

#### **4️⃣ `labels` (Extra Information)**

Labels are like **tags** that help organize and identify the namespace.

-   `name: k8s-demo` → Identifies the namespace.
-   `environment: demo` → Specifies that this is a **demo** environment.
-   `app: k8s-master` → Indicates that this namespace is related to **k8s-master**.

----------

#### **💡 Why Use Namespaces?**

1.  **Isolation** → Keeps different applications **separate** from each other.
2.  **Access Control** → Allows setting **permissions** for different teams or users.
3.  **Organization** → Helps in **grouping** resources for better management.

#### **🏢 Real-World Analogy:**

Imagine Kubernetes as a **large apartment building**:

-   Each tenant (application) **lives in their own apartment (namespace)**.
-   Each apartment has **separate utilities and bills (resources)**.
-   The landlord (Kubernetes) **manages all apartments (namespaces) within the building (cluster)**.

----------

#### **✅ Summary**

-   A **namespace** creates an **isolated environment** inside a Kubernetes cluster.
-   It **prevents conflicts** between different applications.
-   It **organizes resources** using labels.
-   It's like **separate apartments in a building**, ensuring **better management and security**.
## **Explanation: Kubernetes configmap.yaml** 📖



### **🧐 What is a ConfigMap?**

A **ConfigMap** in Kubernetes is like a **recipe book** 📖 for your application. It provides **settings and configurations** that the application should follow **without changing the actual application code or container image**.

-   Instead of **hardcoding settings** inside your application, you can store them separately in a ConfigMap.
-   This makes your **containers more flexible and portable** because you can update the configuration **without rebuilding or redeploying** the application.

----------

#### **🔍 Breakdown of the YAML File**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: k8s-demo

```

#### **1️⃣ `apiVersion: v1`**

-   This tells Kubernetes that we are creating a **ConfigMap** using the **v1 API**.

#### **2️⃣ `kind: ConfigMap`**

-   This specifies that we are **defining a ConfigMap**.

#### **3️⃣ `metadata` (Basic Information)**

-   `name: app-config` → The name of this ConfigMap is **`app-config`**.
-   `namespace: k8s-demo` → This ConfigMap belongs to the **`k8s-demo`** namespace.

----------

#### **📝 Storing Key-Value Pairs**

```yaml
data:
  APP_NAME: "Kubernetes Zero to Hero"
  APP_VERSION: "1.0.0"
  ENVIRONMENT: "demo"
  DATA_PATH: "/data"
  CONFIG_PATH: "/config"
  LOG_PATH: "/logs"

```

-   These **key-value pairs** will be available as **environment variables** inside the running application pods.
-   **Example:**
    -   `APP_NAME` = `"Kubernetes Zero to Hero"` → The application will know its name.
    -   `ENVIRONMENT` = `"demo"` → The app will run in **demo mode** instead of production.

----------

#### **📄 Storing Configuration Files**

```yaml
  app-settings.json: |
    {
      "logLevel": "info",
      "enableMetrics": true,
      "maxFileSizeMB": 10
    }

```

-   This part **stores a small configuration file inside the ConfigMap**.
-   The file is named `app-settings.json` and contains settings in **JSON format**:
    -   `"logLevel": "info"` → The application should log messages at **info level**.
    -   `"enableMetrics": true` → Metrics collection is **enabled**.
    -   `"maxFileSizeMB": 10` → Files **should not exceed 10MB**.

This means your application can **read this file** as if it were a normal file inside a folder, without needing to hardcode these settings.

----------

#### **🎯 Why Use a ConfigMap?**

1.  **Separates configuration from code** → No need to rebuild containers when settings change.
2.  **Can be updated easily** → Modify settings **without restarting** the entire application.
3.  **Portable & reusable** → Works across different environments (**development, testing, production**).

----------

#### **🏢 Real-World Analogy**

Imagine you are running a **restaurant kitchen** 🍽️:

-   The **chefs (containers)** follow a **recipe book (ConfigMap)** to prepare meals.
-   If you **change a recipe (ConfigMap update)**, the chefs **don’t need to be replaced**—they just follow the new instructions.
-   This makes it easy to **adjust recipes (settings) without shutting down the entire kitchen (application).**

----------

#### **✅ Summary**

-   A **ConfigMap** is a **centralized storage for application settings**.
-   It **decouples configuration from application code**, making the app **more flexible**.
-   Stores **both key-value pairs** and **entire config files**.
-   It’s like a **recipe book** 📖 that tells the app **how to behave** without modifying the app itself.
### **Explanation: Kubernetes secrets.yaml** 🔑

----------

## **🧐 What is a Kubernetes Secret?**

A **Secret** in Kubernetes is like a **locked safe** 🔐 for storing **sensitive information** such as:

-   **Passwords**
-   **API keys**
-   **Database credentials**
-   **Tokens**

Unlike **ConfigMaps**, which store **non-sensitive** configurations, **Secrets** are used to store **private and sensitive data** that should not be exposed to everyone.

However, it's important to note that **Secrets in Kubernetes are only encoded, not encrypted by default**. This means that while they are hidden from casual viewing, they are **not fully secure** unless additional security measures (like Kubernetes RBAC or external secret management systems like Vault) are used.

----------

#### **🔍 Breakdown of the YAML File**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: k8s-demo

```

#### **1️⃣ `apiVersion: v1`**

-   This tells Kubernetes that we are **creating a Secret** using the **v1 API**.

#### **2️⃣ `kind: Secret`**

-   This specifies that we are defining a **Secret**, not a ConfigMap.

#### **3️⃣ `metadata` (Basic Information)**

-   `name: app-secrets` → This Secret is called **`app-secrets`**.
-   `namespace: k8s-demo` → This Secret belongs to the **`k8s-demo`** namespace.

----------

#### **🔒 Storing Encoded Secrets**

```yaml
type: Opaque
data:
  # Values must be base64 encoded
  SECRET_KEY: ZGV2LXNlY3JldC1rZXktMTIzNDU=
  DB_PASSWORD: cGFzc3dvcmQxMjM=

```

#### **4️⃣ `type: Opaque`**

-   Specifies that this Secret is **generic** (i.e., it can store any kind of sensitive data).
-   Other types include **docker-registry** (for storing Docker credentials) and **TLS** (for SSL certificates).

#### **5️⃣ `data` (Encoded Values)**

-   **Secrets are stored in base64 encoding** instead of plain text.
-   This prevents people from casually reading them, but it is **not encryption** (it can be easily decoded).

#### **6️⃣ Encoding Secrets using base64**

Since Kubernetes **does not allow storing plain text** in Secrets, you must **convert the values to base64** before adding them.

##### **Example: Encoding a Secret in base64**

If we want to store:

-   `SECRET_KEY = dev-secret-key-12345`
-   `DB_PASSWORD = password123`

We must **convert them to base64** using the following command:

```bash
echo -n "dev-secret-key-12345" | base64

```

**Output:**

```
ZGV2LXNlY3JldC1rZXktMTIzNDU=

```

Similarly, for `password123`:

```bash
echo -n "password123" | base64

```

**Output:**

```
cGFzc3dvcmQxMjM=

```

These encoded values are then stored inside the **Secret**.

----------

#### **🔑 How to Decode a Secret**

To read the stored value, you can **decode it** using:

```bash
echo -n "ZGV2LXNlY3JldC1rZXktMTIzNDU=" | base64 --decode

```

**Output:**

```
dev-secret-key-12345

```

Similarly:

```bash
echo -n "cGFzc3dvcmQxMjM=" | base64 --decode

```

**Output:**

```
password123

```

----------

#### **🎯 Why Use a Secret?**

1.  **Prevents storing credentials inside application code** 🛑
    
    -   Instead of hardcoding passwords inside your application, store them **securely** in a Secret.
2.  **Easier to update** 🔄
    
    -   If a password or key changes, you **only update the Secret**, not the entire application.
3.  **Access control** 🔐
    
    -   Kubernetes **restricts access** to Secrets using **RBAC (Role-Based Access Control)**.
4.  **Can be mounted as a file or environment variable** 📁
    
    -   Applications can **load Secrets dynamically** without modifying code.

----------

### **🏢 Real-World Analogy**

Imagine a **restaurant** 🍽️:

-   The **chefs (containers)** need access to a **safe (Secret)** to retrieve **special ingredients (API keys, passwords)**.
-   Only **authorized personnel** (pods with permission) can open the safe.
-   The **recipe (application code) stays the same**, but the **secret ingredients (credentials) can change** without affecting the recipe.

----------

#### **✅ Summary**

-   **Secrets** store **sensitive information securely** in Kubernetes.
-   Unlike ConfigMaps, Secrets are **base64-encoded**, preventing casual viewing.
-   They can be accessed by **applications via environment variables or mounted as files**.
-   You should **not** store Secrets inside your application code.
### **Explanation: Horizontal Pod Autoscaler (hpa.yaml) 🚀**

----------

## **🧐 What is a HorizontalPodAutoscaler (HPA)?**

A **Horizontal Pod Autoscaler (HPA)** is like a **restaurant manager** 👨‍🍳 who adds or removes staff (pods) **based on demand**.

-   If the restaurant gets **busier (high CPU/memory usage)** → **More chefs (pods) are added**. 👨‍🍳👨‍🍳👨‍🍳
-   If fewer customers arrive (low CPU/memory usage) → **Some chefs are sent home**. 🚶‍♂️

Similarly, in **Kubernetes**, the **HPA automatically adjusts the number of running pods** based on system load (**CPU or memory usage**).

----------

#### **🔍 Breakdown of the YAML File**

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: k8s-master-hpa
  namespace: k8s-demo

```

#### **1️⃣ `apiVersion: autoscaling/v2`**

-   Specifies that we are using version 2 (`autoscaling/v2`) of the **HorizontalPodAutoscaler** API.

#### **2️⃣ `kind: HorizontalPodAutoscaler`**

-   Defines this resource as a **Horizontal Pod Autoscaler**.

#### **3️⃣ `metadata` (Basic Information)**

-   `name: k8s-master-hpa` → The name of the **HPA**.
-   `namespace: k8s-demo` → This **HPA operates within the `k8s-demo` namespace**.

----------

#### **🛠️ What Are We Scaling?**

```yaml
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: k8s-master-app

```

#### **4️⃣ `scaleTargetRef` (What are we scaling?)**

-   This tells the **HPA which deployment to scale**.
-   `apiVersion: apps/v1` → Refers to **Deployments** API.
-   `kind: Deployment` → We are scaling a **Deployment** (not a StatefulSet or other resources).
-   `name: k8s-master-app` → The deployment being **monitored and scaled** is called `k8s-master-app`.

----------

#### **📈 How Many Pods Can It Scale?**

```yaml
  minReplicas: 1
  maxReplicas: 5

```

#### **5️⃣ `minReplicas` and `maxReplicas`**

-   `minReplicas: 1` → **At least 1 pod should always run** (even during low usage).
-   `maxReplicas: 5` → **At most 5 pods can be created** (to prevent excessive scaling).

----------

#### **📊 What Metrics Trigger Scaling?**

```yaml
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 50

```

#### **6️⃣ Scaling Based on CPU and Memory**

-   The HPA monitors **CPU and memory usage** of the pods and **adjusts the number of pods accordingly**.
-   If the **average CPU utilization** of all pods **goes above 50%**, more pods will be created.
-   If the **average memory usage** exceeds **50%**, more pods will be added.

----------

#### **⏳ Scaling Behavior: When to Scale Up or Down?**

```yaml
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 120

```

#### **7️⃣ `behavior` (Controls Scaling Speed)**

-   **`scaleUp: stabilizationWindowSeconds: 60`**
    -   If CPU/memory usage **remains high for 60 seconds**, **new pods will be added**.
-   **`scaleDown: stabilizationWindowSeconds: 120`**
    -   If CPU/memory usage **drops for 120 seconds**, **pods will be removed**.

These settings **prevent rapid scaling up/down** due to temporary traffic spikes.

----------

#### **🏢 Real-World Analogy: A Restaurant 🍽️**

Imagine you own a **restaurant**:

1.  If **more customers** arrive, you **hire more chefs** to keep up with demand. 👨‍🍳🍽️
2.  If **fewer customers** show up, you **send some chefs home** to avoid overstaffing. 🚶‍♂️
3.  You **track the number of customers every few minutes** before making hiring/firing decisions.
4.  You **wait a bit before making changes** to avoid unnecessary hiring or firing due to **temporary rush hours**.

In Kubernetes:

-   Pods **scale up when CPU/memory usage increases**.
-   Pods **scale down when CPU/memory usage decreases**.
-   There is a **waiting period before adjusting pod count**.

----------

#### **✅ Summary**

-   **HorizontalPodAutoscaler (HPA) dynamically scales pods based on CPU/memory usage.**
-   **Prevents resource wastage** when demand is low and **ensures enough capacity** during high demand.
-   **MinReplicas & MaxReplicas** define the scaling range (1 to 5 pods).
-   **Metrics like CPU (50%) & Memory (50%)** determine when scaling should happen.
-   **Scaling behavior (delays) prevents unnecessary scaling due to temporary spikes**.

## **Explanation: Kubernetes service.yaml 🏢📞**


### **🧐 What is a Kubernetes Service?**

Imagine you are calling a **restaurant's phone number** 📞:

-   You don’t know **which specific employee** will answer.
-   You just **call the number**, and someone available picks up.
-   Employees may change, but the **phone number stays the same**.

This is exactly how a **Kubernetes Service** works! Instead of calling individual **Pods (employees)**, you call the **Service (phone number)**, and it automatically connects you to an available pod.

----------

### **🔍 Breakdown of the YAML File**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: k8s-master-app
  namespace: k8s-demo
  labels:
    app: k8s-master
  annotations:
    service.beta.kubernetes.io/description: "Exposes the K8s Master App"

```

#### **1️⃣ `apiVersion: v1`**

-   Since **Services are a basic Kubernetes resource**, they use `apiVersion: v1`.

#### **2️⃣ `kind: Service`**

-   This tells Kubernetes **we are creating a Service**.

#### **3️⃣ `metadata` (Basic Information)**

-   `name: k8s-master-app` → The **name of the service**.
-   `namespace: k8s-demo` → The **namespace this service belongs to**.
-   `labels` → Help Kubernetes **identify and manage** this service.
-   `annotations` → Extra information **for humans and tools**.

----------

### **🛠️ How Does the Service Work?**

```yaml
  # Type: 
  # - ClusterIP (default): Internal only
  # - NodePort: Exposes on Node IP at a static port
  # - LoadBalancer: Exposes externally using cloud provider's load balancer
  type: NodePort

```

#### **4️⃣ `type: NodePort` (How is the service exposed?)**

-   **ClusterIP (default)** → Makes the service available **inside** the cluster (like an internal-only phone line).
-   **NodePort** → Makes the service available **outside** the cluster using a **specific port on every node**.
-   **LoadBalancer** → Uses a cloud provider’s **load balancer** for external access.

👉 **In this case, we use `NodePort`, meaning:**

-   The app is **accessible on a specific port** (`30080`) from outside the cluster.

----------

### **🎯 Which Pods Will This Service Route To?**

```yaml
  selector:
    app: k8s-master

```

#### **5️⃣ `selector` (How does the service find the right pods?)**

-   This service **routes traffic to pods** that have the label:
    
    ```yaml
    app: k8s-master
    
    ```
    
-   Any **pod with this label will be part of the service**.

🛠 **Example:**  
Imagine your restaurant has **multiple chefs** 🧑‍🍳:

-   You don't call each chef separately.
-   You **call the restaurant number**, and the system connects you to **any available chef**.

Similarly, **you call the Service**, and it connects you to **any available pod**.

----------

### **📡 How is Traffic Handled?**

```yaml
  ports:
  - name: http
    port: 80             # Port exposed by the service inside the cluster
    targetPort: 5000     # Port the container accepts traffic on
    nodePort: 30080      # Port on the node (range 30000-32767)
    protocol: TCP

```

#### **6️⃣ `ports` (What ports are being used?)**

-   `port: 80` → The **Service's internal port** (inside the cluster).
-   `targetPort: 5000` → The **port on the container** where the app is running.
-   `nodePort: 30080` → The **port on the Kubernetes node** that exposes the service externally.
-   `protocol: TCP` → The network protocol being used (TCP is standard for web apps).

👉 **How does traffic flow?**

1.  A user accesses the app at **NodeIP:30080** (e.g., `http://192.168.1.100:30080`).
2.  The **Service forwards the request to one of the available pods**.
3.  The **pod listens on port `5000`** and processes the request.

----------

### **🔁 What Happens to Client Connections?**

```yaml
  sessionAffinity: None

```

#### **7️⃣ `sessionAffinity` (Do clients always talk to the same pod?)**

-   **`None` (default)** → Each request can be sent to **any pod**.
-   **`ClientIP`** → Ensures a **client always connects to the same pod**.

----------

### **🏢 Real-World Analogy: A Call Center ☎️**

Imagine a **customer support call center**:

1.  **Customers call a single support number** (Service).
2.  **Any available agent (Pod) answers** the call.
3.  If an agent **leaves or is replaced**, customers **still use the same phone number**.

In Kubernetes:

-   The **Service** is like the call center phone number 📞.
-   **Pods** are like the customer service agents answering calls 🎧.
-   Clients **always reach the Service**, and Kubernetes **connects them to an available pod**.

----------

### **✅ Summary**

-   A **Service provides a stable way to access a set of pods**.
-   It **routes traffic** to pods based on **labels**.
-   The **NodePort (30080)** makes the app accessible from outside the cluster.
-   The **Service remains stable** even if individual pods change.
-   It’s **like a restaurant phone number**, always reachable, but different people (pods) may respond.
## **📂  Explanation: Using `emptyDir` Instead of Persistent Volumes in Kubernetes(volumes.yaml)**

----------

### **🔍 What is this YAML file doing?**

This Kubernetes `ConfigMap` **stores and provides text files** to pods in the cluster. Instead of using **Persistent Volumes** (which can cause issues in WSL2), we are using **`emptyDir` volumes**.

Think of **`emptyDir`** like a **temporary scratch pad** 📝:

-   It **exists only while the pod is running**.
-   When the pod **restarts or is deleted, the data inside disappears**.
-   It's useful for **temporary storage**, **caching**, or **file sharing between containers** inside the same pod.

----------

### **🏗 Breakdown of the YAML File**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-files
  namespace: k8s-demo

```

#### **1️⃣ `apiVersion: v1`**

-   Since **ConfigMap is a core Kubernetes resource**, it uses `apiVersion: v1`.

#### **2️⃣ `kind: ConfigMap`**

-   This tells Kubernetes **we are creating a ConfigMap** (which holds configuration data or files).

#### **3️⃣ `metadata` (Basic Information)**

-   `name: app-files` → The **name of this ConfigMap**.
-   `namespace: k8s-demo` → This ConfigMap **belongs to the `k8s-demo` namespace**.

----------

### **📜 What Files Are Stored in the ConfigMap?**

```yaml
data:
  hello.txt: |
    Hello from the Kubernetes volume!
    This file is loaded from a ConfigMap, not a host mount.

```

#### **4️⃣ `data:` (Key-Value Storage)**

-   This **stores files inside the ConfigMap**.
-   Each **key (e.g., `hello.txt`)** is the filename.
-   The **value** is the file's **content**.

📂 **Example:** `hello.txt`

-   **Content inside the file**:
    
    ```
    Hello from the Kubernetes volume!
    This file is loaded from a ConfigMap, not a host mount.
    
    ```
    

This means any **pod that mounts this ConfigMap** will have access to this file.

----------

### **📄 More Example Files Inside the ConfigMap**

```yaml
  info.txt: |
    This file demonstrates how to use ConfigMaps to provide files to pods.
    In a real application, you might use PersistentVolumes backed by cloud storage.

```

📂 **Example:** `info.txt`

-   **Contains instructions** on how to use ConfigMaps for file storage.

```yaml
  sample-config.txt: |
    # Sample Configuration
    log_level=info
    max_connections=100
    timeout=30

```

📂 **Example:** `sample-config.txt`

-   A **sample configuration file** with settings:
    
    ```
    log_level=info
    max_connections=100
    timeout=30
    
    ```
    
-   This **simulates real-world application settings** (like logging levels, connection limits, and timeouts).

----------

### **🛠 Why Use `emptyDir` Instead of Persistent Volumes?**

-   **PersistentVolumes (`hostPath`) cause issues in WSL2** 🐧 because they rely on **host directory mounts**.
-   **`emptyDir` is simpler** → it works **without needing external storage**.
-   It’s **automatically created when a pod starts** and **deleted when the pod stops**.
-   Ideal for **temporary files, caching, and sharing files between containers in a pod**.

----------

### **🏢 Real-World Analogy: A Whiteboard in an Office**

Think of **`emptyDir`** like a **whiteboard in a meeting room**:

-   **It appears when a meeting starts** (when a pod is scheduled on a node).
-   **Team members can write notes on it** (store files temporarily).
-   **When the meeting ends, the whiteboard is erased** (when the pod stops, the data disappears).

----------

### **✅ Summary**

-   **ConfigMaps store non-sensitive files** (like text files and configs).
-   Instead of using **PersistentVolumes**, we use **`emptyDir`**, which:
    -   **Exists only while the pod is running**.
    -   **Prevents storage issues in WSL2**.
    -   **Is great for temporary files and caching**.
-   **Pods can mount this ConfigMap** and use the files inside it.




## 🔥 **Final Thoughts**

This project serves as a **complete Kubernetes tutorial**, covering: ✅ Containerization with Docker  
✅ Kubernetes configurations (Deployments, Services, ConfigMaps, Secrets)  
✅ Scalability with HPA  
✅ WSL2 optimizations


