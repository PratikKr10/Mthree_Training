# 🛠️ **Grafana Dashboard Import & Export Guide (Week 6, Day 2)**

Yesterday, we created dashboards and panels in Grafana. Today, we focused on **backing them up and reusing them** by exporting the dashboard JSON files from the Grafana pod to our local machine and re-importing them.

---

## 🔍 Step 1: Check Running Pods
Run the following command to list all the pods in the `monitoring` namespace:
```bash
kubectl get pods -n monitoring
```
This confirms that your **Grafana**, **Prometheus**, and **Loki** pods are running.

---

## 📂 Step 2: Locate Dashboard Files in Grafana Pod

1. **Access the Grafana pod**:
   Use a terminal or the Kubernetes dashboard to check inside the pod.

2. Inside the Grafana pod, navigate to the directory where dashboards are stored:
   ```
   /var/lib/grafana/dashboards/default/
   ```

3. You should see files like:
   - `k8s-pod-logs.json`
   - `k8s-simple-dashboard.json`

These are the saved dashboards in JSON format.

---

## ⬇️ Step 3: Copy Dashboards to Local Machine

Use the following commands to copy the JSON files from the Grafana pod to your system:

```bash
kubectl cp grafana-<pod-name>:/var/lib/grafana/dashboards/default/k8s-pod-logs.json ./k8s-pod-logs.json -n monitoring

kubectl cp grafana-<pod-name>:/var/lib/grafana/dashboards/default/k8s-simple-dashboard.json ./k8s-simple-dashboard.json -n monitoring
```

(Replace `<pod-name>` with the actual name of your Grafana pod.)

---

## ✅ Step 4: Confirm the Files Are Downloaded

Check if the files are now on your local machine:

```bash
ls k8s-pod-logs.json k8s-simple-dashboard.json
```

---

## 🔁 Step 5: Port Forward Grafana (If Not Already Done)

If you're having trouble accessing Grafana in the browser, forward the Grafana service to your localhost:

```bash
kubectl port-forward svc/grafana -n monitoring 3000:80
```

Now, Grafana will be available at `http://localhost:3000`.

---

## 🌐 Step 6: Import the Dashboard into Grafana

1. Open your browser and go to:  
   👉 `http://localhost:3000`

2. Log in using your Grafana username and password.

3. Navigate to **Dashboards → Import**.

4. Upload one of the downloaded JSON files.

5. Change the UID if prompted and click **"Create"**.

Now your previously created dashboard is restored and ready to use!

---

## 📊 Step 7: View Your Dashboard

Once imported, your dashboard (e.g., **Mydashboard**) will appear in the list. Click on it to view the panels you set up earlier.

---

## 🧠 Afternoon Recap

- Revised key concepts on **Grafana**, **Prometheus**, and **Loki**
- Practiced dashboard import/export
- Continued work on the SRE project

---
