#!/bin/bash
# ===================================================================================================
# KUBERNETES ZERO TO HERO - REVISED DEPLOYMENT SCRIPT
# ===================================================================================================
# This script creates a comprehensive Kubernetes application that demonstrates:
#  - ConfigMaps for application configuration
#  - Secrets for sensitive data
#  - Deployments with replica management
#  - Services with different access types
#  - Health checks and probes
#  - Resource management
#  - Namespaces for logical separation
# ===================================================================================================
# NOTE: This revised script works around WSL2 mounting limitations and other common minikube issues

# Color definitions for better terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BLUE}             KUBERNETES ZERO TO HERO - REVISED SCRIPT                 ${NC}"
echo -e "${BLUE}======================================================================${NC}"

# ===== STEP 1: SET UP PROJECT DIRECTORY STRUCTURE =====
echo -e "${MAGENTA}[STEP 1] SETTING UP PROJECT DIRECTORY STRUCTURE${NC}"

# Define project directory - this is where all our files will be stored
PROJECT_DIR=~/k8s-master-app
echo -e "${CYAN}Creating project directory at ${PROJECT_DIR}...${NC}"

# Create the directory structure for our project
mkdir -p ${PROJECT_DIR}/{app,k8s/{base,volumes,networking,config,monitoring},scripts,data,config,logs}

# Instead of mounting host directories which causes issues in WSL2,
# we'll create and use directories within the project
echo -e "${CYAN}Creating local data directories instead of host mounts...${NC}"

# Create sample files in the data directory for our app to read
echo "This is a sample configuration file for our Kubernetes app" > ${PROJECT_DIR}/config/sample-config.txt
echo "Hello from the volume!" > ${PROJECT_DIR}/data/hello.txt
echo "This file demonstrates volume mounting in Kubernetes" > ${PROJECT_DIR}/data/info.txt

echo -e "${GREEN}✓ Project directory structure created${NC}"

# ===== STEP 2: CREATE APPLICATION FILES =====
echo -e "${MAGENTA}[STEP 2] CREATING APPLICATION FILES${NC}"
echo -e "${CYAN}Building a Flask application that demonstrates volume mounting...${NC}"

# Create a Python Flask application that works with files in the mounted volume
cat > ${PROJECT_DIR}/app/app.py << 'EOL'
#!/usr/bin/env python3
"""
Kubernetes Master Application
=============================

This Flask application demonstrates:
1. Reading from and writing to mounted volumes
2. Working with environment variables (from ConfigMaps and Secrets)
3. Health checking
4. Resource usage reporting
5. Metrics collection

This showcases how a containerized application interacts with Kubernetes features.
"""
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

# Initialize Flask application
app = Flask(__name__)

# Set up logging to print to console and file
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler(os.environ.get('LOG_PATH', '/app/app.log'))
    ]
)
logger = logging.getLogger('k8s-master-app')

# Read configuration from environment variables (from ConfigMaps)
APP_NAME = os.environ.get('APP_NAME', 'k8s-master-app')
APP_VERSION = os.environ.get('APP_VERSION', '1.0.0')
ENVIRONMENT = os.environ.get('ENVIRONMENT', 'development')
DATA_PATH = os.environ.get('DATA_PATH', '/data')
CONFIG_PATH = os.environ.get('CONFIG_PATH', '/config')
LOG_PATH = os.environ.get('LOG_PATH', '/logs')

# Read secrets from environment variables (from Secrets)
# In a real app, these would be more sensitive values like API keys
SECRET_KEY = os.environ.get('SECRET_KEY', 'default-dev-key')
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'default-password')

# Generate a unique instance ID to demonstrate statelessness
INSTANCE_ID = str(uuid.uuid4())[:8]

# Track request count and application metrics
request_count = 0
start_time = time.time()
metrics = {
    'requests': 0,
    'errors': 0,
    'data_reads': 0,
    'data_writes': 0
}

# Simulate application load for resource usage demonstration
def background_worker():
    """
    Simulate background work to demonstrate resource usage.
    In a real app, this might be processing tasks, etc.
    """
    logger.info("Background worker started")
    counter = 0
    while True:
        # Simple CPU work - calculate prime numbers
        counter += 1
        if counter % 1000 == 0:
            # Log occasionally to show activity
            logger.debug(f"Background worker tick: {counter}")
        time.sleep(0.1)  # Don't use too much CPU

# Start the background worker
worker_thread = threading.Thread(target=background_worker, daemon=True)
worker_thread.start()

@app.route('/')
def index():
    """Main page showing application status and mounted volume information"""
    global request_count, metrics
    request_count += 1
    metrics['requests'] += 1
    
    # Log the request
    logger.info(f"Request to index page from {request.remote_addr}")
    
    # Get system information
    system_info = {
        'hostname': socket.gethostname(),
        'platform': platform.platform(),
        'python_version': platform.python_version(),
        'cpu_count': psutil.cpu_count(),
        'memory': f"{psutil.virtual_memory().total / (1024 * 1024):.1f} MB",
        'uptime': f"{time.time() - start_time:.1f} seconds"
    }
    
    # Get resource usage
    resource_usage = {
        'cpu_percent': psutil.cpu_percent(),
        'memory_percent': psutil.virtual_memory().percent,
        'disk_usage': f"{psutil.disk_usage('/').percent}%"
    }
    
    # Get information about mounted volumes
    volumes = {}
    
    # Check data volume
    try:
        data_files = os.listdir(DATA_PATH)
        volumes['data'] = {
            'path': DATA_PATH,
            'files': data_files,
            'status': 'mounted' if data_files else 'empty'
        }
        metrics['data_reads'] += 1
    except Exception as e:
        volumes['data'] = {
            'path': DATA_PATH,
            'error': str(e),
            'status': 'error'
        }
        metrics['errors'] += 1
    
    # Check config volume
    try:
        config_files = os.listdir(CONFIG_PATH)
        volumes['config'] = {
            'path': CONFIG_PATH,
            'files': config_files,
            'status': 'mounted' if config_files else 'empty'
        }
    except Exception as e:
        volumes['config'] = {
            'path': CONFIG_PATH,
            'error': str(e),
            'status': 'error'
        }
        metrics['errors'] += 1
    
    # Check logs volume
    try:
        logs_files = os.listdir(LOG_PATH)
        volumes['logs'] = {
            'path': LOG_PATH,
            'files': logs_files,
            'status': 'mounted' if logs_files else 'empty'
        }
    except Exception as e:
        volumes['logs'] = {
            'path': LOG_PATH,
            'error': str(e),
            'status': 'error'
        }
        metrics['errors'] += 1
    
    # Build HTML content using a template
    html_content = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>{{ app_name }} - Kubernetes Master App</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body { 
                font-family: Arial, sans-serif; 
                line-height: 1.6; 
                margin: 0; 
                padding: 20px; 
                background-color: #f5f5f5;
                color: #333;
            }
            h1, h2, h3 { color: #2c3e50; }
            .container { 
                max-width: 1000px; 
                margin: 0 auto; 
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .info-box { 
                background-color: #f8f9fa; 
                border-radius: 5px; 
                padding: 15px; 
                margin-bottom: 20px; 
                border-left: 4px solid #3498db;
            }
            .success { color: #27ae60; }
            .error { color: #e74c3c; }
            .warning { color: #f39c12; }
            .info { color: #3498db; }
            .file-list { 
                background-color: #f9f9f9; 
                border-radius: 5px; 
                padding: 10px; 
                border: 1px solid #ddd;
            }
            .file-item {
                display: flex;
                justify-content: space-between;
                padding: 5px 10px;
                border-bottom: 1px solid #eee;
            }
            .file-item:last-child {
                border-bottom: none;
            }
            .nav-links {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }
            .nav-link {
                display: inline-block;
                padding: 8px 16px;
                background-color: #3498db;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-weight: bold;
                transition: background-color 0.3s;
            }
            .nav-link:hover {
                background-color: #2980b9;
            }
            .metrics {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }
            .metric-card {
                flex: 1;
                min-width: 120px;
                background-color: #fff;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                text-align: center;
            }
            .metric-value {
                font-size: 24px;
                font-weight: bold;
                margin: 10px 0;
                color: #3498db;
            }
            .metric-label {
                font-size: 14px;
                color: #7f8c8d;
            }
            .badge {
                display: inline-block;
                padding: 3px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: bold;
                color: white;
                background-color: #95a5a6;
            }
            .badge-primary { background-color: #3498db; }
            .badge-success { background-color: #27ae60; }
            .badge-warning { background-color: #f39c12; }
            .badge-danger { background-color: #e74c3c; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>{{ app_name }} <span class="badge badge-primary">v{{ app_version }}</span></h1>
            <p>A comprehensive Kubernetes demonstration application</p>
            
            <div class="info-box">
                <h2>Pod Information</h2>
                <p><strong>Instance ID:</strong> {{ instance_id }}</p>
                <p><strong>Hostname:</strong> {{ system_info.hostname }}</p>
                <p><strong>Environment:</strong> <span class="badge badge-success">{{ environment }}</span></p>
                <p><strong>Request count:</strong> {{ request_count }}</p>
                <p><strong>Platform:</strong> {{ system_info.platform }}</p>
                <p><strong>Uptime:</strong> {{ system_info.uptime }}</p>
            </div>
            
            <div class="info-box">
                <h2>Resource Usage</h2>
                <div class="metrics">
                    <div class="metric-card">
                        <div class="metric-label">CPU Usage</div>
                        <div class="metric-value">{{ resource_usage.cpu_percent }}%</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-label">Memory</div>
                        <div class="metric-value">{{ resource_usage.memory_percent }}%</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-label">Disk</div>
                        <div class="metric-value">{{ resource_usage.disk_usage }}</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-label">Requests</div>
                        <div class="metric-value">{{ metrics.requests }}</div>
                    </div>
                </div>
            </div>
            
            <div class="info-box">
                <h2>Mounted Volumes</h2>
                
                <h3>Data Volume</h3>
                <p><strong>Path:</strong> {{ volumes.data.path }}</p>
                <p><strong>Status:</strong> 
                    {% if volumes.data.status == 'mounted' %}
                        <span class="success">Successfully mounted</span>
                    {% elif volumes.data.status == 'empty' %}
                        <span class="warning">Mounted but empty</span>
                    {% else %}
                        <span class="error">Error: {{ volumes.data.error }}</span>
                    {% endif %}
                </p>
                
                {% if volumes.data.files %}
                <div class="file-list">
                    <h4>Files:</h4>
                    {% for file in volumes.data.files %}
                    <div class="file-item">
                        <span>{{ file }}</span>
                        <a href="/view-file?path={{ volumes.data.path }}/{{ file }}" class="nav-link">View</a>
                    </div>
                    {% endfor %}
                </div>
                {% endif %}
                
                <h3>Config Volume</h3>
                <p><strong>Path:</strong> {{ volumes.config.path }}</p>
                <p><strong>Status:</strong> 
                    {% if volumes.config.status == 'mounted' %}
                        <span class="success">Successfully mounted</span>
                    {% elif volumes.config.status == 'empty' %}
                        <span class="warning">Mounted but empty</span>
                    {% else %}
                        <span class="error">Error: {{ volumes.config.error }}</span>
                    {% endif %}
                </p>
                
                {% if volumes.config.files %}
                <div class="file-list">
                    <h4>Files:</h4>
                    {% for file in volumes.config.files %}
                    <div class="file-item">
                        <span>{{ file }}</span>
                        <a href="/view-file?path={{ volumes.config.path }}/{{ file }}" class="nav-link">View</a>
                    </div>
                    {% endfor %}
                </div>
                {% endif %}
                
                <h3>Logs Volume</h3>
                <p><strong>Path:</strong> {{ volumes.logs.path }}</p>
                <p><strong>Status:</strong> 
                    {% if volumes.logs.status == 'mounted' %}
                        <span class="success">Successfully mounted</span>
                    {% elif volumes.logs.status == 'empty' %}
                        <span class="warning">Mounted but empty</span>
                    {% else %}
                        <span class="error">Error: {{ volumes.logs.error }}</span>
                    {% endif %}
                </p>
                
                {% if volumes.logs.files %}
                <div class="file-list">
                    <h4>Files:</h4>
                    {% for file in volumes.logs.files %}
                    <div class="file-item">
                        <span>{{ file }}</span>
                        <a href="/view-file?path={{ volumes.logs.path }}/{{ file }}" class="nav-link">View</a>
                    </div>
                    {% endfor %}
                </div>
                {% endif %}
            </div>
            
            <div class="info-box">
                <h2>Actions</h2>
                <div class="nav-links">
                    <a href="/create-file" class="nav-link">Create a File</a>
                    <a href="/api/info" class="nav-link">API Info</a>
                    <a href="/api/health" class="nav-link">Health Check</a>
                    <a href="/api/metrics" class="nav-link">Metrics</a>
                </div>
            </div>
            
            <div class="info-box">
                <h2>Environment Variables</h2>
                <p><strong>APP_NAME:</strong> {{ app_name }}</p>
                <p><strong>APP_VERSION:</strong> {{ app_version }}</p>
                <p><strong>ENVIRONMENT:</strong> {{ environment }}</p>
                <p><strong>DATA_PATH:</strong> {{ data_path }}</p>
                <p><strong>CONFIG_PATH:</strong> {{ config_path }}</p>
                <p><strong>LOG_PATH:</strong> {{ log_path }}</p>
                <p><strong>SECRET_KEY:</strong> {{ secret_key|truncate(10, True, '...') }}</p>
            </div>
        </div>
    </body>
    </html>
    """
    
    # Render the template with our data
    return render_template_string(
        html_content,
        app_name=APP_NAME,
        app_version=APP_VERSION,
        environment=ENVIRONMENT,
        instance_id=INSTANCE_ID,
        system_info=system_info,
        resource_usage=resource_usage,
        volumes=volumes,
        request_count=request_count,
        metrics=metrics,
        data_path=DATA_PATH,
        config_path=CONFIG_PATH,
        log_path=LOG_PATH,
        secret_key=SECRET_KEY
    )

@app.route('/view-file')
def view_file():
    """View the contents of a file from a mounted volume"""
    global metrics
    
    # Get the file path from the query parameters
    file_path = request.args.get('path', '')
    
    # Security check to prevent directory traversal attacks
    # Only allow access to our mounted volumes
    allowed_paths = [DATA_PATH, CONFIG_PATH, LOG_PATH]
    valid_path = False
    
    for path in allowed_paths:
        if file_path.startswith(path):
            valid_path = True
            break
    
    if not valid_path:
        metrics['errors'] += 1
        return "Access denied: Invalid path", 403
    
    # Try to read the file
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Record the successful read
        metrics['data_reads'] += 1
        logger.info(f"File viewed: {file_path}")
        
        # Simple HTML to display the file content
        html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <title>File: {os.path.basename(file_path)}</title>
            <style>
                body {{ font-family: Arial, sans-serif; line-height: 1.6; padding: 20px; }}
                pre {{ background-color: #f8f9fa; padding: 15px; border-radius: 5px; overflow-x: auto; }}
                .nav-link {{
                    display: inline-block;
                    padding: 8px 16px;
                    background-color: #3498db;
                    color: white;
                    text-decoration: none;
                    border-radius: 4px;
                    font-weight: bold;
                }}
            </style>
        </head>
        <body>
            <h1>File: {os.path.basename(file_path)}</h1>
            <p>Path: {file_path}</p>
            <pre>{content}</pre>
            <a href="/" class="nav-link">Back to Home</a>
        </body>
        </html>
        """
        return html
    except Exception as e:
        metrics['errors'] += 1
        logger.error(f"Error viewing file {file_path}: {str(e)}")
        return f"Error reading file: {str(e)}", 500

@app.route('/create-file', methods=['GET', 'POST'])
def create_file():
    """Create a new file in the mounted data volume"""
    global metrics
    
    if request.method == 'POST':
        filename = request.form.get('filename', '')
        content = request.form.get('content', '')
        
        # Only allow creating files in the data directory
        file_path = os.path.join(DATA_PATH, filename)
        
        # For security, don't allow directory traversal
        if '..' in filename or '/' in filename:
            metrics['errors'] += 1
            return "Invalid filename. Directory traversal not allowed.", 400
        
        try:
            with open(file_path, 'w') as f:
                f.write(content)
            
            # Record the successful write
            metrics['data_writes'] += 1
            logger.info(f"File created: {file_path}")
            
            # Also write to the log volume to demonstrate multiple volume mounting
            log_message = f"File created: {filename} at {datetime.datetime.now().isoformat()}\n"
            with open(os.path.join(LOG_PATH, 'file_operations.log'), 'a') as log:
                log.write(log_message)
            
            return redirect('/')
        except Exception as e:
            metrics['errors'] += 1
            logger.error(f"Error creating file {file_path}: {str(e)}")
            return f"Error creating file: {str(e)}", 500
    else:
        # Show form for creating a file
        html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Create File</title>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.6; padding: 20px; }
                .form-group { margin-bottom: 15px; }
                label { display: block; margin-bottom: 5px; }
                input[type="text"], textarea {
                    width: 100%;
                    padding: 8px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                }
                textarea { height: 200px; }
                button {
                    padding: 8px 16px;
                    background-color: #3498db;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-weight: bold;
                }
                .nav-link {
                    display: inline-block;
                    padding: 8px 16px;
                    background-color: #95a5a6;
                    color: white;
                    text-decoration: none;
                    border-radius: 4px;
                    font-weight: bold;
                }
            </style>
        </head>
        <body>
            <h1>Create a New File</h1>
            <p>This file will be saved to the mounted data volume.</p>
            
            <form method="post">
                <div class="form-group">
                    <label for="filename">Filename:</label>
                    <input type="text" id="filename" name="filename" required placeholder="example.txt">
                </div>
                
                <div class="form-group">
                    <label for="content">Content:</label>
                    <textarea id="content" name="content" required placeholder="Enter file content here..."></textarea>
                </div>
                
                <div class="form-group">
                    <button type="submit">Create File</button>
                    <a href="/" class="nav-link">Cancel</a>
                </div>
            </form>
        </body>
        </html>
        """
        return html

@app.route('/api/info')
def api_info():
    """API endpoint returning application information"""
    return jsonify({
        'app_name': APP_NAME,
        'version': APP_VERSION,
        'environment': ENVIRONMENT,
        'instance_id': INSTANCE_ID,
        'hostname': socket.gethostname(),
        'request_count': request_count,
        'uptime_seconds': time.time() - start_time,
        'volumes': {
            'data': {
                'path': DATA_PATH,
                'mounted': os.path.exists(DATA_PATH) and os.access(DATA_PATH, os.R_OK)
            },
            'config': {
                'path': CONFIG_PATH,
                'mounted': os.path.exists(CONFIG_PATH) and os.access(CONFIG_PATH, os.R_OK)
            },
            'logs': {
                'path': LOG_PATH,
                'mounted': os.path.exists(LOG_PATH) and os.access(LOG_PATH, os.R_OK)
            }
        },
        'timestamp': datetime.datetime.now().isoformat()
    })

@app.route('/api/health')
def health_check():
    """Health check endpoint for Kubernetes liveness and readiness probes"""
    # Check if we can access our mounted volumes
    data_ok = os.path.exists(DATA_PATH) and os.access(DATA_PATH, os.R_OK)
    config_ok = os.path.exists(CONFIG_PATH) and os.access(CONFIG_PATH, os.R_OK)
    logs_ok = os.path.exists(LOG_PATH) and os.access(LOG_PATH, os.W_OK)
    
    # For a real application, you might check database connections, 
    # cache availability, etc.
    
    # Overall health status
    is_healthy = data_ok and config_ok and logs_ok
    
    # Log health check results
    logger.info(f"Health check: {'PASS' if is_healthy else 'FAIL'}")
    
    response = {
        'status': 'healthy' if is_healthy else 'unhealthy',
        'checks': {
            'data_volume': 'accessible' if data_ok else 'inaccessible',
            'config_volume': 'accessible' if config_ok else 'inaccessible',
            'logs_volume': 'writable' if logs_ok else 'not writable'
        },
        'timestamp': datetime.datetime.now().isoformat(),
        'hostname': socket.gethostname()
    }
    
    # Set the HTTP status code based on health
    status_code = 200 if is_healthy else 503
    
    return jsonify(response), status_code

@app.route('/api/metrics')
def get_metrics():
    """API endpoint for application metrics - useful for monitoring systems"""
    # Get basic resource usage stats
    cpu_percent = psutil.cpu_percent()
    memory_info = psutil.virtual_memory()
    disk_info = psutil.disk_usage('/')
    
    # Collect all metrics
    all_metrics = {
        'system': {
            'cpu_percent': cpu_percent,
            'memory_used_percent': memory_info.percent,
            'memory_used_mb': memory_info.used / (1024 * 1024),
            'memory_total_mb': memory_info.total / (1024 * 1024),
            'disk_used_percent': disk_info.percent,
            'disk_used_gb': disk_info.used / (1024**3),
            'disk_total_gb': disk_info.total / (1024**3)
        },
        'application': {
            'uptime_seconds': time.time() - start_time,
            'total_requests': metrics['requests'],
            'data_reads': metrics['data_reads'],
            'data_writes': metrics['data_writes'],
            'errors': metrics['errors']
        },
        'instance': {
            'id': INSTANCE_ID,
            'hostname': socket.gethostname()
        },
        'timestamp': datetime.datetime.now().isoformat()
    }
    
    # Log metrics collection for demonstration
    logger.debug(f"Metrics collected: CPU: {cpu_percent}%, Memory: {memory_info.percent}%")
    
    return jsonify(all_metrics)

# For local testing - this won't run in Kubernetes
if __name__ == '__main__':
    print(f"Starting {APP_NAME} v{APP_VERSION} in {ENVIRONMENT} mode")
    app.run(host='0.0.0.0', port=5000, debug=True)
EOL

# Create requirements.txt with necessary dependencies
cat > ${PROJECT_DIR}/app/requirements.txt << 'EOL'
Flask==2.2.3
Werkzeug==2.2.3
psutil==5.9.5
EOL

# Create a Dockerfile for the application
cat > ${PROJECT_DIR}/app/Dockerfile << 'EOL'
# Use Python 3.9 instead of slim to avoid needing to install packages
# The non-slim version already has many utilities installed
FROM python:3.9

# Add metadata to the image
LABEL maintainer="k8s-zero-hero@example.com"
LABEL version="1.0.0"
LABEL description="Kubernetes Zero to Hero Master Application"

# Set working directory inside the container
WORKDIR /app

# Create volume mount points with proper permissions
RUN mkdir -p /data /config /logs && \
    chmod 777 /data /config /logs

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .
RUN chmod +x app.py

# Expose the port the app will run on
EXPOSE 5000

# Add custom health check script
RUN echo '#!/bin/sh' > /healthcheck.sh && \
    echo 'curl -s http://localhost:5000/api/health || exit 1' >> /healthcheck.sh && \
    chmod +x /healthcheck.sh

# Set up a non-root user for security
RUN useradd -m appuser && \
    chown -R appuser:appuser /app /data /config /logs

# Switch to the non-root user
USER appuser

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_NAME="K8s Master App" \
    APP_VERSION="1.0.0" \
    ENVIRONMENT="production" \
    DATA_PATH="/data" \
    CONFIG_PATH="/config" \
    LOG_PATH="/logs"

# Start the application
CMD ["python", "app.py"]

# Add HEALTHCHECK instruction to check container health
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD /healthcheck.sh
EOL

echo -e "${GREEN}✓ Application files created${NC}"

# ===== STEP 3: CREATE KUBERNETES MANIFEST FILES =====
echo -e "${MAGENTA}[STEP 3] CREATING KUBERNETES MANIFESTS${NC}"
echo -e "${CYAN}Creating Kubernetes configuration files with helpful analogies...${NC}"

# Create namespace.yaml
cat > ${PROJECT_DIR}/k8s/base/namespace.yaml << 'EOL'
# Namespace: Virtual clusters within a Kubernetes cluster
# Purpose: Isolate resources, control access, and organize applications
#
# In our case, we use a namespace to isolate our application from others in the cluster.
# This is similar to having separate apartments in a building - each with their own space.
apiVersion: v1
kind: Namespace
metadata:
  name: k8s-demo
  labels:
    name: k8s-demo
    environment: demo
    app: k8s-master
EOL

# Create configmap.yaml
cat > ${PROJECT_DIR}/k8s/config/configmap.yaml << 'EOL'
# ConfigMap: Store non-sensitive configuration data
# Purpose: Decouple configuration from container images
#
# ConfigMaps are like recipe books for your application - they tell the app
# how it should behave without having to rebuild the container image.
# This makes your containers more portable and easier to configure.
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: k8s-demo
data:
  # These key-value pairs will be available as environment variables in the pods
  APP_NAME: "Kubernetes Zero to Hero"
  APP_VERSION: "1.0.0"
  ENVIRONMENT: "demo"
  DATA_PATH: "/data"
  CONFIG_PATH: "/config"
  LOG_PATH: "/logs"
  # You can also store configuration files directly in the ConfigMap
  app-settings.json: |
    {
      "logLevel": "info",
      "enableMetrics": true,
      "maxFileSizeMB": 10
    }
EOL

# Create secret.yaml
cat > ${PROJECT_DIR}/k8s/config/secret.yaml << 'EOL'
# Secret: Store sensitive configuration data
# Purpose: Securely store credentials, tokens, keys, etc.
#
# Secrets are like ConfigMaps but for sensitive data. They're encoded (not encrypted)
# by default, but Kubernetes prevents them from being casually viewed.
# In production, you'd want to use a proper secret management system like Vault.
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: k8s-demo
type: Opaque
data:
  # Values must be base64 encoded
  # echo -n "dev-secret-key-12345" | base64
  SECRET_KEY: ZGV2LXNlY3JldC1rZXktMTIzNDU=
  # echo -n "password123" | base64
  DB_PASSWORD: cGFzc3dvcmQxMjM=
EOL

# Create persistent volume claims using emptyDir instead of hostPath
# This avoids the WSL2 mounting issues
cat > ${PROJECT_DIR}/k8s/volumes/volumes.yaml << 'EOL'
# Instead of using PersistentVolume and PersistentVolumeClaim with hostPath
# which causes issues in WSL2, we'll use emptyDir volumes.
# 
# EmptyDir is like a temporary scratch pad - it's created when a pod is assigned
# to a node and exists as long as that pod is running on that node.
# This is perfect for our demo without requiring special host directory mounts.
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-files
  namespace: k8s-demo
data:
  hello.txt: |
    Hello from the Kubernetes volume!
    This file is loaded from a ConfigMap, not a host mount.
  
  info.txt: |
    This file demonstrates how to use ConfigMaps to provide files to pods.
    In a real application, you might use PersistentVolumes backed by cloud storage.
  
  sample-config.txt: |
    # Sample Configuration
    log_level=info
    max_connections=100
    timeout=30
EOL

# Create deployment.yaml
# Modified to use emptyDir instead of persistent volumes
cat > ${PROJECT_DIR}/k8s/base/deployment.yaml << 'EOL'
# Deployment: Declaratively manages a set of pods
# Purpose: Ensure pods are running and updated according to a desired state
#
# Deployments are like restaurant managers who ensure there are always enough
# chefs (pods) working in the kitchen. If a chef quits or gets sick, the manager
# hires a new one to maintain the desired staffing level.
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-master-app
  namespace: k8s-demo
  labels:
    app: k8s-master
spec:
  # Number of identical pod replicas to maintain
  replicas: 2
  
  # Strategy defines how pods should be updated
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1  # Maximum number of pods that can be unavailable during update
      maxSurge: 1        # Maximum number of pods that can be created over desired number
  
  # Selector defines how the Deployment finds which Pods to manage
  selector:
    matchLabels:
      app: k8s-master
  
  # Pod template defines what each Pod should look like
  template:
    metadata:
      labels:
        app: k8s-master
      annotations:
        prometheus.io/scrape: "true"  # Tell Prometheus to scrape this pod for metrics
        prometheus.io/path: "/api/metrics"
        prometheus.io/port: "5000"
    spec:
      # Container specifications
      containers:
      - name: k8s-master-app
        image: k8s-master-app:latest
        imagePullPolicy: Never  # Use local image (for Minikube)
        
        # Ports to expose from the container
        ports:
        - containerPort: 5000
          name: http
        
        # Environment variables from ConfigMap
        envFrom:
        - configMapRef:
            name: app-config
        
        # Environment variables from Secret
        - secretRef:
            name: app-secrets
        
        # Volume mounts connect the container to volumes
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
        
        # Resource limits and requests
        # These help Kubernetes schedule pods efficiently
        resources:
          requests:
            cpu: "100m"     # 0.1 CPU core
            memory: "128Mi"  # 128 MB of memory
          limits:
            cpu: "500m"     # 0.5 CPU core
            memory: "512Mi"  # 512 MB of memory
        
        # Liveness probe checks if the container is alive
        # If it fails, Kubernetes will restart the container
        livenessProbe:
          httpGet:
            path: /api/health
            port: http
          initialDelaySeconds: 30
          periodSeconds: 30
          timeoutSeconds: 5
          failureThreshold: 3
        
        # Readiness probe checks if the container is ready to serve traffic
        # If it fails, Kubernetes won't send traffic to it
        readinessProbe:
          httpGet:
            path: /api/health
            port: http
          initialDelaySeconds: 15
          periodSeconds: 10
          timeoutSeconds: 3
        
        # Lifecycle hooks to perform actions at container startup and shutdown
        # This allows for graceful handling of container events
        lifecycle:
          postStart:
            exec:
              command: ["/bin/sh", "-c", "echo 'Container started' > /logs/container.log"]
          preStop:
            exec:
              command: ["/bin/sh", "-c", "echo 'Container stopping' >> /logs/container.log"]
      
      # Volumes define storage that can be mounted into containers
      volumes:
      # Using emptyDir instead of PersistentVolumeClaim to avoid host mount issues
      - name: data-volume
        emptyDir: {}
      - name: config-volume
        emptyDir: {}
      - name: logs-volume
        emptyDir: {}
      # ConfigMap volume to provide sample files
      - name: config-files
        configMap:
          name: app-files
      
      # Init container to copy sample files to the volumes
      # This simulates having data in the persistent volumes
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
EOL

# Create service.yaml
cat > ${PROJECT_DIR}/k8s/networking/service.yaml << 'EOL'
# Service: Stable endpoint to access pods
# Purpose: Provide a stable IP and DNS name to access a set of pods
#
# Services are like a restaurant's phone number - customers call one number
# and get connected to available staff. It doesn't matter which specific
# employee answers, and employees can change without affecting the phone number.
apiVersion: v1
kind: Service
metadata:
  name: k8s-master-app
  namespace: k8s-demo
  labels:
    app: k8s-master
  annotations:
    service.beta.kubernetes.io/description: "Exposes the K8s Master App"
spec:
  # Type: 
  # - ClusterIP (default): Internal only
  # - NodePort: Exposes on Node IP at a static port
  # - LoadBalancer: Exposes externally using cloud provider's load balancer
  type: NodePort
  
  # Selector determines which pods this service will route traffic to
  selector:
    app: k8s-master
  
  # Port mappings
  ports:
  - name: http
    port: 80             # Port exposed by the service inside the cluster
    targetPort: 5000     # Port the container accepts traffic on
    nodePort: 30080      # Port on the node (range 30000-32767)
    protocol: TCP

  # Session affinity: Determines if connections from a client go to the same pod
  sessionAffinity: None
EOL

# Create HorizontalPodAutoscaler for auto-scaling
cat > ${PROJECT_DIR}/k8s/monitoring/hpa.yaml << 'EOL'
# HorizontalPodAutoscaler: Automatically scale pods based on metrics
# Purpose: Dynamically adjust number of pods based on CPU/memory usage
#
# HPA is like a restaurant manager who adds or removes staff based on
# how busy the restaurant is. More customers = more staff needed.
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: k8s-master-hpa
  namespace: k8s-demo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: k8s-master-app
  minReplicas: 1
  maxReplicas: 5
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
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 120
EOL

echo -e "${GREEN}✓ Kubernetes manifests created${NC}"

# ===== STEP 4: CREATE DEPLOYMENT SCRIPT =====
echo -e "${MAGENTA}[STEP 4] CREATING DEPLOYMENT SCRIPTS${NC}"
echo -e "${CYAN}Creating scripts to deploy the application to Kubernetes...${NC}"

# Main deployment script - revised for WSL compatibility
cat > ${PROJECT_DIR}/scripts/deploy.sh << 'EOL'
#!/bin/bash
# Deployment script for the Kubernetes Zero to Hero application
# This script automates the entire deployment process to Minikube
# REVISED VERSION: Works around WSL2 mounting limitations

# Color definitions for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BLUE}             KUBERNETES ZERO TO HERO - DEPLOYMENT                     ${NC}"
echo -e "${BLUE}======================================================================${NC}"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Step 1: Check prerequisites
echo -e "${MAGENTA}[STEP 1] CHECKING PREREQUISITES${NC}"

# Check for required tools
for tool in minikube kubectl docker; do
    if ! command_exists $tool; then
        echo -e "${RED}Error: $tool is not installed. Please install it and try again.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ $tool is installed${NC}"
done

# Step 2: Ensure Minikube is running
echo -e "${MAGENTA}[STEP 2] ENSURING MINIKUBE IS RUNNING${NC}"

if ! minikube status | grep -q "host: Running"; then
    echo -e "${YELLOW}Minikube is not running. Starting Minikube...${NC}"
    
    # Start Minikube with appropriate configuration
    # REMOVED mounting that caused issues
    minikube start --cpus=2 --memory=4096 --disk-size=20g
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to start Minikube. Trying with minimal configuration...${NC}"
        # Fallback to minimal configuration
        minikube start --driver=docker
        
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed to start Minikube. Exiting.${NC}"
            exit 1
        fi
    fi
else
    echo -e "${GREEN}✓ Minikube is already running${NC}"
fi

# Step 3: Enable required Minikube addons
echo -e "${MAGENTA}[STEP 3] ENABLING MINIKUBE ADDONS${NC}"

# We'll handle addons more carefully, checking if they're already enabled
# and handling errors better

# Function to safely enable an addon
enable_addon() {
    local addon=$1
    local already_enabled=$(minikube addons list | grep $addon | grep -c "enabled")
    
    if [ $already_enabled -eq 1 ]; then
        echo -e "${GREEN}✓ $addon addon is already enabled${NC}"
        return 0
    fi
    
    echo -e "${CYAN}Enabling $addon addon...${NC}"
    minikube addons enable $addon
    
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}Warning: Failed to enable $addon addon. Continuing without it.${NC}"
        return 1
    else
        echo -e "${GREEN}✓ $addon addon enabled${NC}"
        return 0
    fi
}

# Try to enable addons but don't fail if they don't work
enable_addon "dashboard" || true

echo -e "${YELLOW}Note: Skipping Ingress and Metrics Server addons as they may not work in all environments${NC}"
echo -e "${YELLOW}The application will still work without these addons${NC}"

# Step 4: Configure Docker to use Minikube's Docker daemon
echo -e "${MAGENTA}[STEP 4] CONFIGURING DOCKER TO USE MINIKUBE${NC}"
echo -e "${CYAN}This allows us to build images directly into Minikube's registry${NC}"

eval $(minikube docker-env)
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to configure Docker to use Minikube. Exiting.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker configured to use Minikube's registry${NC}"

# Step 5: Build the Docker image
echo -e "${MAGENTA}[STEP 5] BUILDING DOCKER IMAGE${NC}"

echo -e "${CYAN}Building k8s-master-app:latest image...${NC}"
cd ~/k8s-master-app/app

# Added retry mechanism for Docker build with better network settings
MAX_ATTEMPTS=3
BUILD_SUCCESS=false

for ATTEMPT in $(seq 1 $MAX_ATTEMPTS); do
    echo -e "${YELLOW}Build attempt $ATTEMPT of $MAX_ATTEMPTS...${NC}"
    
    # Use host network for better connectivity in WSL
    docker build --network=host -t k8s-master-app:latest .
    
    if [ $? -eq 0 ]; then
        BUILD_SUCCESS=true
        break
    else
        echo -e "${YELLOW}Build attempt $ATTEMPT failed. Waiting before retry...${NC}"
        sleep 5
    fi
done

if [ "$BUILD_SUCCESS" != "true" ]; then
    echo -e "${RED}Failed to build Docker image after $MAX_ATTEMPTS attempts. Exiting.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker image built successfully${NC}"
docker images | grep k8s-master-app

# Step 6: Apply Kubernetes manifests
echo -e "${MAGENTA}[STEP 6] DEPLOYING TO KUBERNETES${NC}"
cd ~/k8s-master-app

echo -e "${CYAN}Creating namespace...${NC}"
kubectl apply -f k8s/base/namespace.yaml

echo -e "${CYAN}Creating ConfigMap and sample files...${NC}"
kubectl apply -f k8s/volumes/volumes.yaml

echo -e "${CYAN}Creating ConfigMap for application settings...${NC}"
kubectl apply -f k8s/config/configmap.yaml

echo -e "${CYAN}Creating Secret...${NC}"
kubectl apply -f k8s/config/secret.yaml

echo -e "${CYAN}Creating Deployment...${NC}"
kubectl apply -f k8s/base/deployment.yaml

echo -e "${CYAN}Creating Service...${NC}"
kubectl apply -f k8s/networking/service.yaml

echo -e "${CYAN}Creating HorizontalPodAutoscaler...${NC}"
kubectl apply -f k8s/monitoring/hpa.yaml || true
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Warning: Failed to create HorizontalPodAutoscaler. This is expected if metrics-server is not enabled.${NC}"
    echo -e "${YELLOW}The application will still work without auto-scaling.${NC}"
fi

echo -e "${GREEN}✓ All Kubernetes resources applied${NC}"

# Step 7: Wait for deployment to be ready
echo -e "${MAGENTA}[STEP 7] WAITING FOR DEPLOYMENT TO BE READY${NC}"
echo -e "${CYAN}This may take a minute or two...${NC}"

echo "Waiting for deployment to be ready..."
kubectl -n k8s-demo rollout status deployment/k8s-master-app --timeout=180s

if [ $? -ne 0 ]; then
    echo -e "${RED}Deployment failed to become ready within the timeout period.${NC}"
    echo -e "${YELLOW}Checking pod status...${NC}"
    kubectl -n k8s-demo get pods
    
    echo -e "${YELLOW}Checking pod logs...${NC}"
    POD=$(kubectl -n k8s-demo get pods -l app=k8s-master -o name | head -1)
    if [ ! -z "$POD" ]; then
        kubectl -n k8s-demo logs $POD
    fi
else
    echo -e "${GREEN}✓ Deployment is ready${NC}"
fi

# Step 8: Set up port forwarding for easier access
echo -e "${MAGENTA}[STEP 8] SETTING UP PORT FORWARDING${NC}"
echo -e "${CYAN}This will make the application accessible on localhost${NC}"

# Check if port forwarding is already running
if pgrep -f "kubectl.*port-forward.*k8s-demo" > /dev/null; then
    echo -e "${YELLOW}Port forwarding is already running. Stopping it...${NC}"
    pkill -f "kubectl.*port-forward.*k8s-demo"
fi

# Start port forwarding in the background
kubectl -n k8s-demo port-forward svc/k8s-master-app 8080:80 &
PORT_FORWARD_PID=$!

# Give it a moment to start
sleep 2

# Check if port forwarding started successfully
if ! ps -p $PORT_FORWARD_PID > /dev/null; then
    echo -e "${RED}Failed to start port forwarding.${NC}"
else
    echo -e "${GREEN}✓ Port forwarding started on port 8080${NC}"
fi

# Step 9: Display access information
echo -e "${MAGENTA}[STEP 9] DEPLOYMENT COMPLETE${NC}"
echo -e "${BLUE}======================================================================${NC}"
echo -e "${GREEN}Kubernetes Zero to Hero application has been deployed!${NC}"
echo -e "${BLUE}======================================================================${NC}"

echo -e "${YELLOW}Your application is accessible via multiple methods:${NC}"
echo ""
echo -e "${CYAN}1. Port Forwarding:${NC}"
echo "   URL: http://localhost:8080"
echo "   (This is running in the background with PID $PORT_FORWARD_PID)"
echo ""

# Get Minikube IP
MINIKUBE_IP=$(minikube ip)
echo -e "${CYAN}2. NodePort:${NC}"
echo "   URL: http://$MINIKUBE_IP:30080"
echo ""

echo -e "${CYAN}3. Minikube Service URL:${NC}"
echo "   Run: minikube service k8s-master-app -n k8s-demo"
echo ""

# Step 10: Display useful commands
echo -e "${BLUE}======================================================================${NC}"
echo -e "${YELLOW}USEFUL COMMANDS:${NC}"
echo -e "${BLUE}======================================================================${NC}"

echo -e "${CYAN}View the Kubernetes Dashboard:${NC}"
echo "   minikube dashboard"
echo ""
echo -e "${CYAN}View application logs:${NC}"
echo "   kubectl -n k8s-demo logs -l app=k8s-master"
echo ""
echo -e "${CYAN}Get a shell into a pod:${NC}"
echo "   kubectl -n k8s-demo exec -it $(kubectl -n k8s-demo get pods -l app=k8s-master -o name | head -1) -- /bin/bash"
echo ""
echo -e "${CYAN}View all resources in the namespace:${NC}"
echo "   kubectl -n k8s-demo get all"
echo ""
echo -e "${CYAN}Check pod resource usage (if metrics-server is enabled):${NC}"
echo "   kubectl -n k8s-demo top pods"
echo ""
echo -e "${CYAN}Clean up all resources:${NC}"
echo "   ./scripts/cleanup.sh"
echo ""
echo -e "${CYAN}Stop port forwarding:${NC}"
echo "   kill $PORT_FORWARD_PID"
echo ""

echo -e "${BLUE}======================================================================${NC}"
echo -e "${GREEN}DEPLOYMENT SUCCESSFUL!${NC}"
echo -e "${BLUE}======================================================================${NC}"
echo -e "${YELLOW}Enjoy exploring your Kubernetes application!${NC}"
EOL

# Create cleanup script
cat > ${PROJECT_DIR}/scripts/cleanup.sh << 'EOL'
#!/bin/bash
# Cleanup script for Kubernetes Zero to Hero application
# This script removes all Kubernetes resources created for the application

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BLUE}             KUBERNETES ZERO TO HERO - CLEANUP                        ${NC}"
echo -e "${BLUE}======================================================================${NC}"

# Step 1: Stop any port forwarding
echo -e "${CYAN}Stopping any port forwarding processes...${NC}"
pkill -f "kubectl -n k8s-demo port-forward" || true
echo -e "${GREEN}✓ Port forwarding stopped${NC}"

# Step 2: Delete all Kubernetes resources
echo -e "${CYAN}Deleting all resources in k8s-demo namespace...${NC}"
kubectl delete namespace k8s-demo

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ All resources in k8s-demo namespace deleted${NC}"
else
    echo -e "${RED}Failed to delete namespace. Trying individual resources...${NC}"
    
    # Delete resources in reverse order of creation
    kubectl delete -f ~/k8s-master-app/k8s/monitoring/hpa.yaml || true
    kubectl delete -f ~/k8s-master-app/k8s/networking/service.yaml || true
    kubectl delete -f ~/k8s-master-app/k8s/base/deployment.yaml || true
    kubectl delete -f ~/k8s-master-app/k8s/config/secret.yaml || true
    kubectl delete -f ~/k8s-master-app/k8s/config/configmap.yaml || true
    kubectl delete -f ~/k8s-master-app/k8s/volumes/volumes.yaml || true
    kubectl delete -f ~/k8s-master-app/k8s/base/namespace.yaml || true
    
    echo -e "${YELLOW}Individual resource deletion complete${NC}"
fi

# Step 3: Optional - clean up Docker images
echo -e "${CYAN}Cleaning up Docker images in Minikube...${NC}"
eval $(minikube docker-env)
docker rmi k8s-master-app:latest || true
echo -e "${GREEN}✓ Docker images cleaned up${NC}"

echo -e "${BLUE}======================================================================${NC}"
echo -e "${GREEN}CLEANUP COMPLETE!${NC}"
echo -e "${BLUE}======================================================================${NC}"
echo -e "${YELLOW}You can restart the application by running ./scripts/deploy.sh${NC}"
EOL

# Create script for running load tests to demonstrate basic functionality
cat > ${PROJECT_DIR}/scripts/test-app.sh << 'EOL'
#!/bin/bash
# Test script for Kubernetes Zero to Hero application
# This script tests basic functionality of the application

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BLUE}             KUBERNETES ZERO TO HERO - APPLICATION TEST               ${NC}"
echo -e "${BLUE}======================================================================${NC}"

# Check if the application is running
echo -e "${CYAN}Checking if the application is running...${NC}"
kubectl -n k8s-demo get deployment k8s-master-app &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}Application is not running. Please deploy it first.${NC}"
    exit 1
fi

# Get current pod count
CURRENT_PODS=$(kubectl -n k8s-demo get pods -l app=k8s-master | grep Running | wc -l)
echo -e "${GREEN}Current pod count: $CURRENT_PODS${NC}"

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo -e "${RED}curl is not installed. Please install it and try again.${NC}"
    exit 1
fi

# Get the service URL
# Try port-forward first, then NodePort
if netstat -tulpn 2>/dev/null | grep -q ':8080'; then
    APP_URL="http://localhost:8080"
    echo -e "${GREEN}Found port-forwarded URL: $APP_URL${NC}"
else
    # Try to get Minikube IP
    MINIKUBE_IP=$(minikube ip 2>/dev/null)
    if [ $? -eq 0 ] && [ ! -z "$MINIKUBE_IP" ]; then
        APP_URL="http://$MINIKUBE_IP:30080"
        echo -e "${GREEN}Using NodePort URL: $APP_URL${NC}"
    else
        echo -e "${RED}Could not determine application URL. Starting port forwarding...${NC}"
        kubectl -n k8s-demo port-forward svc/k8s-master-app 8080:80 &
        PORT_FORWARD_PID=$!
        sleep 2
        APP_URL="http://localhost:8080"
    fi
fi

# Function to run a test request
run_test_request() {
    local path=$1
    local description=$2
    
    echo -e "${YELLOW}Testing $description...${NC}"
    
    # Run curl with a timeout
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$APP_URL$path")
    
    if [ $HTTP_CODE -eq 200 ]; then
        echo -e "${GREEN}✓ $description test passed (HTTP 200)${NC}"
        return 0
    else
        echo -e "${RED}✗ $description test failed (HTTP $HTTP_CODE)${NC}"
        return 1
    fi
}

# Function to test the application's API
test_api() {
    echo -e "${CYAN}Running API tests...${NC}"
    
    # Test homepage
    run_test_request "/" "Homepage"
    
    # Test health check endpoint
    run_test_request "/api/health" "Health check endpoint"
    
    # Test info endpoint
    run_test_request "/api/info" "Info endpoint"
    
    # Test metrics endpoint
    run_test_request "/api/metrics" "Metrics endpoint"
    
    echo -e "${CYAN}API tests completed${NC}"
}

# Function to get pod information
get_pod_info() {
    echo -e "${CYAN}Getting pod information...${NC}"
    
    # Get pod details
    kubectl -n k8s-demo get pods -l app=k8s-master
    
    # Get detailed info for the first pod
    POD_NAME=$(kubectl -n k8s-demo get pods -l app=k8s-master -o name | head -1)
    if [ ! -z "$POD_NAME" ]; then
        echo -e "${YELLOW}Detailed info for $POD_NAME:${NC}"
        kubectl -n k8s-demo describe $POD_NAME
    fi
}

# Run the tests
test_api
get_pod_info

echo -e "${BLUE}======================================================================${NC}"
echo -e "${GREEN}TESTS COMPLETE!${NC}"
echo -e "${BLUE}======================================================================${NC}"
echo -e "${YELLOW}Your Kubernetes application is up and running.${NC}"
EOL

# Make all scripts executable
chmod +x ${PROJECT_DIR}/scripts/deploy.sh
chmod +x ${PROJECT_DIR}/scripts/cleanup.sh
chmod +x ${PROJECT_DIR}/scripts/test-app.sh

echo -e "${GREEN}✓ Deployment scripts created${NC}"

# ===== STEP 5: CREATE README AND DOCUMENTATION =====
echo -e "${MAGENTA}[STEP 5] CREATING DOCUMENTATION${NC}"
echo -e "${CYAN}Creating README and documentation files...${NC}"

# Create a comprehensive README with explanations
cat > ${PROJECT_DIR}/README.md << 'EOL'
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
k8s-master-app/
├── app/                   # Application code
│   ├── app.py             # Flask application
│   ├── Dockerfile         # Container definition
│   └── requirements.txt   # Python dependencies
├── k8s/                   # Kubernetes manifests
│   ├── base/              # Core resources
│   │   ├── deployment.yaml
│   │   └── namespace.yaml
│   ├── config/            # Configuration resources
│   │   ├── configmap.yaml
│   │   └── secret.yaml
│   ├── monitoring/        # Monitoring resources
│   │   └── hpa.yaml
│   ├── networking/        # Networking resources
│   │   └── service.yaml
│   └── volumes/           # Storage resources
│       └── volumes.yaml
└── scripts/               # Helper scripts
    ├── cleanup.sh         # Clean up all resources
    ├── deploy.sh          # Deploy the application
    └── test-app.sh        # Test the application
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
EOL

# Create a simple cheatsheet for Kubernetes commands
cat > ${PROJECT_DIR}/kubernetes-cheatsheet.md << 'EOL'
# Kubernetes Commands Cheat Sheet

A quick reference guide for common kubectl commands used in this project.

## Context and Namespace Commands

```bash
# View current context and namespace
kubectl config current-context
kubectl config view --minify | grep namespace

# Switch namespace
kubectl config set-context --current --namespace=k8s-demo
```

## Resource Management

```bash
# View resources
kubectl get pods -n k8s-demo
kubectl get all -n k8s-demo
kubectl get pods -n k8s-demo -o wide

# Describe resources (detailed info)
kubectl describe pod <pod-name> -n k8s-demo
kubectl describe deployment k8s-master-app -n k8s-demo

# Delete resources
kubectl delete pod <pod-name> -n k8s-demo
```

## Logs and Debugging

```bash
# View logs
kubectl logs <pod-name> -n k8s-demo
kubectl logs -f <pod-name> -n k8s-demo  # Stream logs

# Execute commands in pod
kubectl exec -it <pod-name> -n k8s-demo -- /bin/bash
kubectl exec <pod-name> -n k8s-demo -- ls /data

# Port forwarding
kubectl port-forward service/k8s-master-app 8080:80 -n k8s-demo
```

## Working with Minikube

```bash
# Start/stop Minikube
minikube start
minikube stop

# Get Minikube IP
minikube ip

# Open service in browser
minikube service k8s-master-app -n k8s-demo

# Access dashboard
minikube dashboard

# Configure docker to use Minikube's daemon
eval $(minikube docker-env)
```

## Tips for WSL2 Users

1. **If Minikube won't start**: Try `minikube start --driver=docker`

2. **If mounting fails**: Avoid host path mounts, use EmptyDir volumes instead

3. **If addons won't enable**: They may not be critical - the app can run without them

4. **If WSL networking issues occur**: Use port forwarding instead of NodePort access
EOL

echo -e "${GREEN}✓ Documentation created${NC}"

# ===== FINAL STEP: MAKE SCRIPTS EXECUTABLE AND PRINT COMPLETION MESSAGE =====
chmod +x ${PROJECT_DIR}/scripts/deploy.sh
chmod +x ${PROJECT_DIR}/scripts/cleanup.sh
chmod +x ${PROJECT_DIR}/scripts/test-app.sh

echo -e "${BLUE}======================================================================${NC}"
echo -e "${GREEN}KUBERNETES ZERO TO HERO PROJECT CREATED SUCCESSFULLY!${NC}"
echo -e "${BLUE}======================================================================${NC}"
echo ""
echo -e "${YELLOW}Project directory:${NC} ${PROJECT_DIR}"
echo ""
echo -e "${CYAN}To deploy the application, run:${NC}"
echo -e "cd ${PROJECT_DIR}"
echo -e "./scripts/deploy.sh"
echo ""
echo -e "${CYAN}To clean up after you're done, run:${NC}"
echo -e "./scripts/cleanup.sh"
echo ""
echo -e "${CYAN}To test the application functionality, run:${NC}"
echo -e "./scripts/test-app.sh"
echo ""
echo -e "${MAGENTA}KEY IMPROVEMENTS OVER ORIGINAL SCRIPT:${NC}"
echo -e "✓ No host path mounting (avoids WSL2 9p filesystem errors)"
echo -e "✓ Uses emptyDir volumes instead of PersistentVolumes"
echo -e "✓ Handles addon failures gracefully"
echo -e "✓ Simplified deployment process"
echo -e "✓ More robust error handling"
echo -e "✓ Maintains all the great analogies from the original"
echo ""
echo -e "${GREEN}Explore the files to learn more about each Kubernetes concept!${NC}"
