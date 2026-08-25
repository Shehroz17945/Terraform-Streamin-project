# StreamVault 🚀

StreamVault is a fully automated, cloud-native video streaming platform infrastructure deployed on **Microsoft Azure** using **Terraform**. This project eliminates manual configuration by leveraging Infrastructure as Code (IaC), custom initialization scripts, and remote-exec provisioners to seamlessly provision network topologies, databases, load balancers, and backend/frontend application servers.

---

## 🏗️ Architecture Overview

StreamVault uses a secure, highly scalable hub-and-spoke and multi-tier network architecture on Azure:

- **Azure Application Gateway (v2)**: Acts as the entry point with **Path-Based Routing**, routing `/api/*` traffic directly to the backend API server and default traffic to the static web frontend. Custom health probes ensure high availability.
- **Frontend Server (Nginx)**: Serves high-performance static UI assets (`index.html`, `videos.html`, `script.js`) protected by modern styling.
- **Backend Server (Node.js & Express)**: Handles authentication, JSON web tokens (JWT), and communicates securely with Azure Storage.
- **Azure Database for PostgreSQL / SQL (Backend DBMS)**: Manages user accounts, credentials, and app states.
- **Azure Blob Storage**: Stores video files securely, dynamically injected via environment variables (`.env`) during provisioning.

---

## 🛠️ Tech Stack & Tools

- **Infrastructure as Code**: Terraform, HCL
- **Cloud Provider**: Microsoft Azure (Virtual Networks, Subnets, Network Security Groups, Application Gateway, Public IPs, NICs, Virtual Machines, Blob Storage)
- **Backend**: Node.js, Express, JavaScript, JWT Authentication
- **Frontend**: HTML5, CSS3 (Custom Dark UI), JavaScript (`fetch` API)
- **Automation**: Terraform `remote-exec` provisioners, `templatefile` data sources, Nginx web server

---

## 📂 Project Structure

```text
StreamVault/
├── terraform/
│   ├── main.tf              # Resource definitions (VNet, Subnets, VMs, App Gateway)
│   ├── variables.tf         # Configurable variables
│   ├── outputs.tf           # Public IP / DNS outputs
│   └── templates/
│       └── backend_env.tpl  # Dynamic environment variable injection template
├── frontend/
│   ├── index.html           # Sign-in UI
│   ├── videos.html          # Video dashboard & player interface
│   └── script.js            # Client-side authentication and API orchestration
└── backend/
    ├── server.js            # Express API server & streaming endpoints
    └── package.json         # Node dependencies
```

---

## ⚙️ Key Automation Features

1. **Dynamic Secret & Config Injection**: Utilizes Terraform's `templatefile` function to bind Azure Blob Storage keys and database credentials directly into the backend `.env` file during deployment.
2. **Path-Based Load Balancing**: Configures Azure Application Gateway to split traffic intelligently between static frontend assets and dynamic backend API endpoints.
3. **Zero-Touch Provisioning**: Automated bootstrapping installs Node.js, configures Nginx, mounts application code, and starts services via automated provisioning pipelines.

---

## 🚀 Getting Started & Deployment

### Prerequisites
- [Terraform](https://www.terraform.io/) installed (>= 1.0)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) authenticated (`az login`)

### Deployment Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/StreamVault.git
   cd StreamVault/terraform
   ```
2. Initialize Terraform providers:
   ```bash
   terraform init
   ```
3. Plan the infrastructure deployment:
   ```bash
   terraform plan
   ```
4. Apply the configuration to provision Azure resources and deploy code:
   ```bash
   terraform apply --auto-approve
   ```

5. Access the application using the output Application Gateway public DNS name:
   ```text
   http://streamvault.<region>.cloudapp.azure.com
   ```

---

## 💡 Troubleshooting & Architecture Highlights

- **Static Asset Serving**: Nginx is configured on the frontend server to serve static HTML/JS assets efficiently. Absolute paths (`/script.js`) are utilized to maintain seamless routing under query parameters.
- **Secure Video Streaming**: Videos are protected via token-authenticated endpoints that securely pull streaming blobs from Azure Storage without exposing storage account keys to the client.

---

## 📜 License
This project is open-source and available under the [MIT License](LICENSE).
