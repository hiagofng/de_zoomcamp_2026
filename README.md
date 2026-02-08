# Data Engineering Zoomcamp 2026

**Datatalks homeworks and exercises for DE Zoomcamp 2026**

---

## 📚 Course Progress

### ✅ Module 1: Containerization and Infrastructure as Code

**Status:** Completed  
**Folder:** [`01-docker-terraform/`](./01-docker-terraform/)

#### What I Learned

- **Docker fundamentals** - Container lifecycle, volumes, and data persistence
- **Docker networking** - Container communication and port mapping
- **Docker Compose** - Multi-service orchestration (PostgreSQL + pgAdmin)
- **Data pipelines** - NYC Taxi data ingestion using Python, pandas, and SQLAlchemy
- **SQL queries** - Data analysis on PostgreSQL databases
- **Terraform for GCP** - Infrastructure as Code for Google Cloud (Storage + BigQuery)
- **Terraform for AWS** - Equivalent AWS infrastructure (S3 + Glue Catalog)
- **Best practices** - Environment variables, `.gitignore` for credentials, and project structure

#### Key Deliverables

- ✅ **Homework 01** - Docker, SQL, and Terraform exercises
- Working PostgreSQL + pgAdmin environment via Docker Compose
- Python data ingestion scripts for parquet and CSV files
- Terraform configurations for GCP and AWS resource provisioning

#### Technologies Used

`Docker` `PostgreSQL` `pgAdmin` `Python` `pandas` `SQLAlchemy` `Terraform` `GCP` `AWS`

#### Cloud Service Comparison - GCP vs AWS

| GCP Service | AWS Equivalent | Purpose |
|------------|----------------|---------|
| Google Cloud Storage (GCS) | Amazon S3 | Data Lake storage |
| Uniform Bucket Level Access | S3 Public Access Block | Secure bucket access |
| Object Lifecycle Rules | S3 Lifecycle Configuration | Automatic data expiration |
| BigQuery Dataset | AWS Glue Catalog Database | Metadata & query layer |
| Service Account JSON Key | IAM User Profile (AWS CLI) | Authentication |

**Authentication Difference:**
- **GCP:** Requires `my-creds.json` service account key file
- **AWS:** Uses IAM profile from `~/.aws/credentials` (no separate file needed)

---

### ✅ Module 2: Workflow Orchestration

**Status:** Completed  
**Folder:** [`02-workflow-orchestration/`](./02-workflow-orchestration/)

#### What I Learned

- **Kestra fundamentals** - Modern declarative workflow orchestration platform
- **ETL pipeline orchestration** - Extract, transform, and load NYC taxi data to GCP
- **Variables and expressions** - Dynamic workflow configuration using Jinja templating
- **Backfill functionality** - Historical data processing for multiple time periods
- **Scheduled triggers** - Automated workflow execution with timezone support
- **GCP integration** - Cloud Storage and BigQuery data loading
- **Secrets management** - Secure credential handling with base64 encoding
- **Docker Compose orchestration** - Multi-service setup (Kestra + PostgreSQL + pgAdmin)

#### Key Deliverables

- ✅ **Homework 02** - Workflow orchestration and data pipeline exercises
- Working Kestra instance with PostgreSQL backend via Docker Compose
- Automated ETL flows processing millions of taxi trip records
- GCP bucket and BigQuery dataset created via Terraform-like flows
- Backfill executions for all 2020 data (Yellow: 24.6M rows, Green: 1.7M rows)

#### Technologies Used

`Kestra` `Docker` `PostgreSQL` `Python` `GCP` `Cloud Storage` `BigQuery` `Gemini AI`

#### Kestra Workflow Highlights

| Flow | Purpose | Data Processed |
|------|---------|----------------|
| `08_gcp_taxi` | Manual ETL execution | Single month of taxi data |
| `09_gcp_taxi_scheduled` | Scheduled ETL with backfill | Multiple months via cron triggers |
| `06_gcp_kv` | Configuration management | Stores GCP project settings |
| `07_gcp_setup` | Infrastructure provisioning | Creates GCS bucket + BigQuery dataset |

#### Data Pipeline Results

- **Yellow Taxi (2020):** 24,648,499 records across 12 months
- **Green Taxi (2020):** 1,734,051 records across 12 months
- **Yellow Taxi (March 2021):** 1,925,152 records
- **File size example:** 128.3 MiB uncompressed CSV for Dec 2020

---

### ✅ Module 3: Data Warehouse

**Status:** Completed  
**Folder:** [`03-data-warehouse/`](./03-data-warehouse/)

#### What I Learned

- **BigQuery fundamentals** - External tables, materialized tables, and metadata queries
- **Columnar storage** - Understanding how BigQuery scans only requested columns
- **Partitioning** - Table partitioning by date for efficient time-range queries
- **Clustering** - Clustering tables by high-cardinality columns for optimized filtering
- **Data loading to GCS** - Uploading parquet files to Google Cloud Storage using Python and DLT
- **SQL optimization** - Estimating bytes processed and reducing query costs
- **External vs materialized tables** - Trade-offs between storage location and query performance

#### Key Deliverables

- ✅ **Homework 03** - Data warehouse and BigQuery exercises
- Yellow Taxi Trip Records (Jan-Jun 2024) loaded into GCS and BigQuery
- External and materialized tables created for 20.3M+ records
- Partitioned and clustered table optimized for date filtering and vendor queries
- Python and DLT-based data loading scripts

#### Technologies Used

`BigQuery` `Google Cloud Storage` `SQL` `Python` `DLT` `Parquet`

#### BigQuery Optimization Results

| Table Type | Query | Estimated Bytes |
|-----------|-------|-----------------|
| Materialized (non-partitioned) | Distinct VendorID (Mar 1-15) | 310.24 MB |
| Partitioned + Clustered | Distinct VendorID (Mar 1-15) | 26.84 MB |
| Materialized | SELECT count(*) | 0 MB (metadata) |
| External | Distinct PULocationID | 0 MB |
| Materialized | Distinct PULocationID | 155.12 MB |

---

## 🚀 Getting Started
```bash