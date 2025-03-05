# Kubernetes Zero to Hero Application (WSL2-Compatible Version)

This project demonstrates a comprehensive Kubernetes application specially adapted for use with WSL2. It showcases various Kubernetes concepts including:

- ConfigMaps and Secrets for configuration
- EmptyDir volumes (avoiding WSL2 host mounting issues)
- Multiple networking access methods
- Health checks and probes
- Resource management
- And much more!

## Prerequisites

- Minikube
- kubectl
- Docker
- WSL2 (if using Windows)

## Key Changes from Standard Kubernetes Setups

This version differs from standard Kubernetes tutorials in several ways to accommodate WSL2 limitations:

1. **No Host Directory Mounting**: We avoid using `hostPath` volumes and the `minikube mount` command since these often fail in WSL2 environments due to 9p filesystem limitations.

2. **Volume Strategy**: Instead of persistent volumes with host paths, we use:
   - EmptyDir volumes for temporary storage
   - ConfigMaps to provide initial files
   - Init containers to set up the volumes

3. **Addons**: We handle addon failures gracefully, allowing the deployment to continue even if certain addons (like ingress or metrics-server) can't be enabled.

## Project Structure

```
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
│   ├── k8s_project_explained.md # Detailed documentation 
```

## Quick Start

1. Ensure Prerequisites are installed
2. Run the deployment script:

```bash
cd ~/k8s-master-app
./scripts/deploy.sh
```

3. Access the application via one of these methods:
   - Port Forwarding: http://localhost:8080
   - NodePort: http://<minikube-ip>:30080
   - Minikube Service: `minikube service k8s-master-app -n k8s-demo`

## Key Concepts Demonstrated

### 1. Pods and Containers

Pods are the smallest deployable units in Kubernetes. In this project, each pod contains:
- Our Flask application container
- Shared storage volumes
- Resource limits and requests

### 2. Volume Strategy for WSL2

Since host path mounting often fails in WSL2, we use:
- EmptyDir volumes: Temporary storage attached to the pod's lifecycle
- ConfigMaps to provide initial files
- Init containers to set up the volume data

This approach avoids the filesystem compatibility issues while still demonstrating volume concepts.

### 3. ConfigMaps and Secrets

ConfigMaps store non-sensitive configuration settings:
- Application name, version, environment
- Path configurations
- Feature flags
- Sample files for the application

Secrets store sensitive data:
- API keys
- Database passwords
- Session keys

### 4. Networking and Exposure

The application is exposed through multiple methods:
- Service (NodePort): For direct access via Node IP and port
- Port Forwarding: For easy local development access

### 5. Health Checks and Probes

The application implements multiple types of probes:
- Liveness: Determines if the container should be restarted
- Readiness: Determines if the container can receive traffic

### 6. Resource Management

The application defines:
- Resource requests: Minimum resources required
- Resource limits: Maximum resources allowed

## Exploring the Demo

The application has several features to demonstrate Kubernetes concepts:
- View files from emptyDir volumes
- Create new files in the data volume
- View pod information and resource usage
- Access API endpoints
- View environment variables from ConfigMaps and Secrets

## Cleaning Up

To remove all resources created by this demo:

```bash
./scripts/cleanup.sh
```

## Kubernetes Analogies

Throughout the configuration files, you'll find helpful analogies that explain Kubernetes concepts:

- **Namespace**: Like separate apartments in a building
- **ConfigMap**: Like recipe books for your application
- **Secret**: Like a vault for sensitive recipes
- **Deployment**: Like a restaurant manager ensuring enough chefs
- **Service**: Like a restaurant's phone number connecting customers to available staff
- **HPA**: Like adding or removing staff based on how busy a restaurant is

These analogies help make complex Kubernetes concepts more approachable and understandable.
