# Azure Data Platform (ADP)

**Enterprise-grade IoT telemetry pipeline deployed on Azure using Infrastructure as Code**

A production-pattern Azure data platform that ingests simulated microgrid telemetry from edge devices, routes it through IoT Hub to a Data Lake, transforms it with Data Factory, and stores structured data in SQL Database — all monitored through Log Analytics and Grafana dashboards.

Built entirely from Terraform with hub-spoke networking, defense-in-depth security, CI/CD automation, and centralized monitoring.

---

## Architecture

```
Edge Device (Simulated Microgrid Sensors)
    │ MQTT/AMQP
    ▼
Azure IoT Hub (iot-adp-dev-ptm)
    │ Message Route
    ▼
Data Lake Gen2 (stadpdevptm/telemetry-raw)
    │ JSON partitioned by date/hour
    ▼
Azure Data Factory (adf-adp-dev-ptm)
    │ Ingest + Transform
    ▼
Azure SQL Database (sqldb-adp-dev)
    │ Analytical Queries
    ▼
Grafana Dashboard (grafana-adp-dev)
```

### Network Architecture

```
┌─────────────────────────────────────────────────┐
│  Hub VNet (10.0.0.0/16)                         │
│  ┌──────────────┐  ┌──────────────────────────┐ │
│  │ Azure Bastion│  │ GatewaySubnet            │ │
│  │ (Secure SSH) │  │ (Future VPN/ExpressRoute)│ │
│  └──────────────┘  └──────────────────────────┘ │
└──────────────────────┬──────────────────────────┘
                       │ VNet Peering (Bidirectional)
┌──────────────────────┴──────────────────────────┐
│  Spoke VNet (10.1.0.0/16)                       │
│  ┌─────────────┐ ┌────────────┐ ┌────────────┐  │
│  │  Web Subnet │ │ App Subnet │ │ Data Subnet│  │
│  │ 10.1.0.0/24 │ │10.1.1.0/24 │ │ 10.1.2.0/24│  │
│  │  NSG: HTTPS │ │ NSG: 8080  │ │ NSG: 1433  │  │
│  │  only       │ │ from web   │ │ from app   │  │
│  └─────────────┘ └────────────┘ └────────────┘  │
│                                                 │
│  Private Endpoints: Storage (blob) + SQL        │
│  Private DNS Zones: privatelink.blob + database │
└─────────────────────────────────────────────────┘
```

---

## Technology Stack

| Category | Tools |
|----------|-------|
| **Networking** | VNet (hub-spoke), NSGs (inbound + outbound), Bastion, Private Endpoints, Private DNS Zones, VNet Peering |
| **Security** | Key Vault (RBAC), Managed Identity, Azure Policy (deny public IPs, require tags), random\_password generation, gitleaks pre-commit hooks |
| **Compute** | Linux VM (Ubuntu 22.04), Azure Container Registry |
| **Data** | IoT Hub (S1), Data Lake Gen2, SQL Database (Basic), Data Factory, Python device simulator |
| **Monitoring** | Log Analytics, KQL queries, Azure Managed Grafana v12, diagnostic settings |
| **DevOps** | Terraform (9 modules, remote state), GitHub Actions CI/CD, pre-commit hooks |
| **Scripting** | Python (Azure SDK resource audit), Bash (IoT health check), PowerShell (NSG export) |

---

## Project Structure

```
azure-data-platform/
├── .github/workflows/          # CI/CD pipeline (terraform plan on PR)
├── terraform/
│   ├── modules/
│   │   ├── networking/         # Hub-spoke VNets, subnets, peering, Bastion, Private Endpoints
│   │   ├── security/           # NSGs, Key Vault, Managed Identity, random password
│   │   ├── compute/            # Linux VM, ACR
│   │   ├── storage/            # Data Lake Gen2, containers
│   │   ├── iot/                # IoT Hub, message routing, storage endpoint
│   │   ├── sql/                # SQL Server, database, firewall rules
│   │   ├── data-factory/       # ADF with managed identity
│   │   ├── monitoring/         # Log Analytics, Grafana, diagnostic settings
│   │   └── governance/         # Azure Policy assignments
│   ├── main.tf                 # Root module wiring all modules together
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Root outputs
│   ├── providers.tf            # AzureRM 4.65 + Random providers
│   └── backend.tf              # Remote state in Azure Blob Storage
├── sql/
│   ├── schema/                 # NYC Taxi database schema
│   └── queries/                # Analytical SQL queries
├── scripts/
│   ├── audit_resources.py      # Python: Azure SDK resource inventory + tag audit
│   ├── iot_health_check.sh     # Bash: IoT Hub device count + status check
│   └── export_nsg_rules.ps1    # PowerShell: NSG rules export to CSV
├── docs/
│   ├── kql/                    # KQL queries for Log Analytics
│   └── device-simulator.py     # IoT device telemetry simulator
├── data-factory/pipelines/     # ADF pipeline definitions
├── Dockerfile                  # Container image for device simulator
├── .pre-commit-config.yaml     # gitleaks secret scanning
└── .gitignore
```

---

## Key Design Decisions

**Hub-Spoke Architecture** — Shared services (Bastion, future firewall/VPN) live in the hub. Workload subnets live in the spoke. VNet peering connects them. This is the standard enterprise Azure pattern recommended by the Cloud Adoption Framework.

**Defense in Depth** — Three independent security layers: NSGs enforce rules at the subnet boundary (inbound AND outbound), Azure Policy prevents public IP creation at the governance level, and Managed Identity eliminates all stored credentials from the pipeline.

**Private Endpoints** — Storage and SQL are accessible only through private endpoints on the data subnet. No public internet exposure. Private DNS zones resolve the privatelink FQDNs within the VNet.

**Managed Identity Over Credentials** — A single user-assigned Managed Identity (id-adp-dev) is attached to IoT Hub, Data Factory, and Storage. Services authenticate to each other without connection strings or passwords. Secrets live in Key Vault with RBAC authorization.

**Cost-Conscious Design** — Azure Firewall was deployed, tested, and decommissioned to avoid $30/day idle costs. Budget alerts at $25/month with three warning thresholds. IoT Hub on S1 (not S2/S3). SQL Database on Basic SKU (5 DTU). All resources tagged for cost tracking.

---

## Terraform Modules

| Module | Resources | Purpose |
|--------|-----------|---------|
| `networking` | 2 VNets, 6 subnets, peering, Bastion, Private Endpoints, Private DNS | Network foundation |
| `security` | 3 NSGs, Key Vault, Managed Identity, role assignments, random password | Security baseline |
| `compute` | Linux VM, NIC, ACR | Compute layer |
| `storage` | Data Lake Gen2, 3 containers, RBAC role assignment | Data landing zone |
| `iot` | IoT Hub, storage endpoint, message route | Telemetry ingestion |
| `sql` | SQL Server, database, firewall rule | Structured data store |
| `data-factory` | ADF with managed identity | Data orchestration |
| `monitoring` | Log Analytics, Grafana, diagnostic settings | Observability |
| `governance` | Azure Policy (deny public IPs, require tags) | Governance enforcement |

---

## CI/CD Pipeline

GitHub Actions workflow runs on every pull request touching `terraform/`:

1. **Format Check** — `terraform fmt -check` ensures consistent code style
2. **Init** — Connects to Azure Blob remote state backend
3. **Validate** — Catches configuration errors without Azure credentials
4. **Plan** — Shows exactly what will change before any human approves

Deployment uses the `plan -out` / `apply` pattern — the reviewed plan is the exact plan that gets applied.

---

## Monitoring & Observability

- **Log Analytics** (log-adp-dev) — Centralized log store, 30-day retention, PerGB2018 SKU
- **Diagnostic Settings** — Key Vault AuditEvents and IoT Hub Connections/DeviceTelemetry streaming to Log Analytics
- **KQL Queries** — Security audit (failed Key Vault operations), IoT device connectivity, resource health overview
- **Grafana** (grafana-adp-dev) — Azure Managed Grafana v12 with operational dashboard panels for IoT Hub and Key Vault metrics

---

## Cost Management

- Budget alert: $25/month with thresholds at 50%, 75%, 90%
- Pre-session and end-of-session cost checks on every work session
- Azure Firewall decommissioned after testing to eliminate $30/day idle cost
- All resources tagged with `project`, `environment`, `managed_by` for cost attribution
- IoT Hub sized at S1 (minimum production tier), SQL at Basic (5 DTU)

---

## How to Deploy

```bash
# Clone the repository
git clone https://github.com/PetrickMac/azure-data-platform.git
cd azure-data-platform/terraform

# Authenticate to Azure
az login

# Initialize Terraform with remote state
terraform init

# Review the deployment plan
terraform plan -out=tfplan

# Deploy
terraform apply tfplan
```

**Prerequisites:** Azure CLI, Terraform >= 1.0, Azure subscription with Contributor access.

---

## Author

**Petrick McCarver**  
Help Desk → Cloud Engineer  
[GitHub](https://github.com/PetrickMac) · [LinkedIn](https://linkedin.com/in/petrickmccarver)

Certifications: AZ-900 · AZ-104 · AWS Cloud Practitioner · AWS Solutions Architect Associate
