# 🛠️ **Grafana SRE Dashboards & Visualizations (Week 6, Day 3)**

We began the day by revisiting our Grafana dashboards and diving deeper into **SRE concepts** and how they relate to monitoring via Grafana.

---

## 🚦 SRE Concepts Explained with Real-Life Analogies

1. **Latency** – Time taken to serve a request  
   - 🍔 *Example:* Time from ordering a burger to receiving it.  
   - 💻 *Tech:* Time from making a request to receiving a response.  
   - **High latency = Frustrated users.**

2. **Traffic** – Number of incoming requests  
   - 🚶 *Example:* A counter at a restaurant counts people entering.  
   - 💻 *Tech:* Requests per second/minute hitting the system.  
   - **High traffic = Potential overload.**

3. **Errors** – Failed or incorrect responses  
   - 🧾 *Example:* Wrong or cold food served.  
   - 💻 *Tech:* HTTP 5xx or application-level errors.  
   - **More errors = Poor user experience.**

4. **Saturation** – Resource usage nearing full capacity  
   - 🍽️ *Example:* 49 out of 50 tables in a restaurant are occupied.  
   - 💻 *Tech:* CPU, memory, or threads reaching their limits.  
   - **High saturation = Performance drops.**

---

## 👁️ Observability Concepts

1. **Metrics** – Key numerical values to monitor system performance.  
   - ✈️ *Example:* Altitude and speed on an airplane dashboard.  

2. **Logs** – Records of system events.  
   - ✈️ *Example:* Black box recording everything.  

3. **Visualization** – Dashboards that summarize data clearly.  
   - ✈️ *Example:* Cockpit control panel.  

4. **Instrumentation** – Adding measurement tools in the system.  
   - ✈️ *Example:* Sensors checking engine temperature.

---

## ❤️ Health Monitoring Essentials

1. **Liveness Probe** – Checks if the app is running.  
   - *Is the patient breathing?*

2. **Readiness Probe** – Checks if the app is ready to handle requests.  
   - *Can the patient talk and walk?*

3. **Health Endpoints** – Monitors specific parts of the app.  
   - *Vitals like blood pressure, temperature.*

4. **Dependency Checks** – Ensures all services are working together.  
   - *Heart, lungs, and brain syncing properly.*

---

## 📏 Service Level Objectives (SLOs)

1. **Error Rate Tracking** – Percentage of failed requests.  
   - 🍕 *Example:* 5 wrong pizzas out of 100 = 5% error rate.  

2. **Latency Histogram** – Shows how long requests take across percentiles.  
   - ⏱️ *Example:* 95% of pizzas delivered within 30 minutes.  

3. **Request Success Rate** – % of successful requests processed.  
   - ✅ *Example:* 95 out of 100 pizzas were perfect.

---

## 🧪 Dashboard Setup & Script Execution

- Ran the script:  
  ```bash
  ./lightweight-sre-monitoring.sh
  ```

- If you get Docker-related errors:  
  ```bash
  sudo dockerd
  ```

- If permission denied, make the script executable:  
  ```bash
  chmod 777 lightweight-sre-monitoring.sh
  ```

- Faced error:
  ```bash
  error: unknown flag: --short
  ```
  ➤ Fixed it by **removing `--short`** from the script.

- Faced timeout error → Increased wait time from `120s` to `200s`.

- After that, opened Grafana at:  
  👉 `http://localhost:3000`

---

## 📊 Creating Dashboards from JSON

- Used `.md` files referenced in the script to add dashboards.
- Followed standard steps: **Add new dashboard → Add panel → Choose data source → Write query → Configure visualization.**

---

## 📈 Prometheus Panels

1. **Request Rate per Endpoint**
   ```promql
   sum by(endpoint) (rate(app_request_count_total{namespace="sre-demo"}[24h]))
   ```

2. **HTTP 5xx Error Percentage**
   ```promql
   sum(rate(app_request_count{namespace="sre-demo", http_status=~"5.."}[1m])) /
   sum(rate(app_request_count{namespace="sre-demo"}[1m])) * 100
   ```

3. **Active Requests**
   ```promql
   app_active_requests{namespace="sre-demo"}
   ```

4. **95th Percentile Request Latency**
   ```promql
   histogram_quantile(0.95,
     sum(rate(app_request_latency_seconds_bucket{namespace="sre-demo"}[5m])) by (le, endpoint)
   )
   ```

5. **Latency Count**
   ```promql
   app_request_latency_seconds_count{namespace="sre-demo"}
   ```

6. **API Server Cache List Rate**
   ```promql
   rate(apiserver_cache_list_total{job="kubernetes-apiservers"}[5m])
   ```

7. **API Server Cache List Total**
   ```promql
   sum(apiserver_cache_list_total{job="kubernetes-apiservers"})
   ```

📝 Saved the dashboard as **SRE Basic Dashboard**.

---

## 📋 Loki-based Panels (Log Monitoring)

1. **Logs from sre-demo Namespace**
   ```logql
   {namespace="sre-demo"}
   ```

2. **Logs Containing 'Error'**
   ```logql
   {namespace="sre-demo"} |= "Error"
   ```

3. **Log Volume in Last 1 Minute**
   ```logql
   sum(count_over_time({namespace="sre-demo"}[1m]))
   ```

📝 Saved the dashboard as **Log Analysis**.

---

## 🧠 Afternoon Recap

- Reviewed all SRE, Prometheus, and Loki topics covered in the morning.
- Prepared for the Python exam using the LMS platform.

---
