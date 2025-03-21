# 🛠️ **Grafana, Prometheus & Loki Setup Guide (Week 6, Day 1 - SRE Module)**

This guide walks you through setting up a full monitoring stack using **Grafana**, **Prometheus**, and **Loki** inside **Minikube**, using **Helm** for installation and customization.

---

## 👨‍💻 Step 1: Understand the Basics

### 🔁 What is Toil in SRE?
In Site Reliability Engineering:
- **Toil** = Manual, repetitive work that’s automatable and doesn’t improve the system long-term.
- SREs aim to keep toil below **50%** of their time.

### ✅ How SREs Handle Toil:
1. **Automate** – Use scripts or tools to handle repeat tasks.
2. **Eliminate** – Solve the root problem causing the toil.
3. **Reduce** – Make processes faster and less painful.
4. **Limit** – Keep a healthy balance between toil and impactful work.

---

## 🔍 Step 2: Know the Tools

### 📊 Prometheus
- Open-source tool for **monitoring and alerting**.
- Collects metrics like CPU, memory, network, and app-specific stats.
- Stores data as **time series** after scraping from endpoints.

### 📈 Grafana
- Open-source tool for **visualizing metrics** from Prometheus and others.
- Lets you build **interactive dashboards** in real time.
- Supports many data sources: **Prometheus, Loki, MySQL, Elasticsearch, etc.**

### 📄 Loki
- Log aggregation tool by Grafana Labs.
- Works like Prometheus but for logs.
- Doesn’t index full log content—only metadata (labels).
- Perfect for **correlating logs with metrics** in Grafana.

---

## ⚙️ Step 3: Setup via Script

Here’s how the Grafana dashboard setup script works:

1. Script asks if you want to reset Minikube.
2. If yes, it stops & deletes the existing Minikube cluster.
3. Starts a new cluster:
   ```bash
   minikube start --driver=docker --cpus=2 --memory=3072
   ```
4. Creates a Kubernetes YAML (`sample-app.yaml`) containing a sample container that logs:
   - `[INFO]` – Normal logs
   - `[DEBUG]` – Debugging info
   - `[ERROR]` – Random error logs

---

## 📦 Step 4: Install Prometheus with Helm

1. If a monitoring namespace exists, delete it.
2. Use **Helm**, the Kubernetes package manager, to install Prometheus.
3. Customize settings in `values.yaml` file.
4. Wait for Prometheus to be fully ready:
   ```bash
   kubectl wait --for=condition=ready pod --selector="app.kubernetes.io/name=prometheus,app.kubernetes.io/component=server" -n monitoring --timeout=120s
   ```

---

## 📦 Step 5: Install Loki Stack & Grafana

1. Install **Loki stack** from the Grafana Helm chart.
2. Define settings in `values.yaml`:
   - Admin credentials
   - Data source URLs
   - Preloaded dashboards
3. Install **Grafana** using Helm and your `values.yaml`.
4. Expose Grafana and forward the port to access the UI.

---

## 🚀 Step 6: Run Everything

Run the script to automate the setup:
```bash
./simple-grafana-monitoring.sh
```

Helpful commands to support the process:
```bash
sudo dockerd &
minikube delete
minikube start --driver=docker --cpus=2 --memory=2048
minikube status
kubectl get nodes
```

To install Helm:
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
```

Delete existing monitoring namespace (if needed) and re-run the script.

---

## 📊 Step 7: Create Grafana Dashboards

### 🔐 Login to Grafana
- Open Grafana in your browser via the forwarded port.
- Use the credentials from your `values.yaml`.

---

### 📋 Panel 1: Logs (via Loki)
1. Choose **Loki** as the data source.
2. Visualization: **Logs**
3. Add label filter:
   - **namespace = sample-app**
   - In **Line Contains**, add `ERROR`
4. Set panel title and apply.

---

### 📋 Panel 2: CPU Usage (via Prometheus)
1. Choose **Prometheus** as the data source.
2. Switch to **code mode**.
3. Use this query:
   ```promql
   sum(rate(container_cpu_usage_seconds_total{namespace="sample-app"}[5m])) by (pod)
   ```
4. Set unit: **Percent (0–100)**

---

### 📋 Panel 3: Log Volume
1. Create a new panel titled **Log Volume by Pod**
2. Use this query:
   ```promql
   sum(count_over_time({namespace="sample-app"}[5m])) by (pod_name)
   ```
3. Save the dashboard. You should now see:
   - Logs
   - CPU Usage
   - Log Volume

---

That’s it! You’ve successfully set up a basic observability stack using Grafana, Prometheus, and Loki inside Minikube. 🎉
