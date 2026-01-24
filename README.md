# GCP Price Monitor and Scraper

This project implements a serverless architecture on Google Cloud Platform (GCP) to monitor financial asset prices. The entire infrastructure is managed as code (IaC) and deployed through automated CI/CD pipelines.

## Architecture

The solution follows a cloud-native event-driven approach:

1.  **Cloud Scheduler:** Acts as a cron-job trigger, invoking the process at defined intervals.
2.  **Cloud Functions (Python):** Executes the web scraping logic using BeautifulSoup4 and processes the data.
3.  **Firestore (NoSQL):** Stores the retrieved price data with timestamps for historical tracking.
4.  **Cloud Logging:** Provides centralized observability and error tracking.



## Technical Stack

* **Cloud Provider:** Google Cloud Platform (GCP)
* **Infrastructure as Code:** Terraform
* **CI/CD:** GitHub Actions
* **Language:** Python 3.10
* **Database:** Google Firestore (Native Mode)
* **State Management:** Google Cloud Storage (Remote Backend)

## Key Technical Features

### Infrastructure as Code (IaC)
The infrastructure is fully modularized using Terraform. Key implementations include:
* **Remote State Management:** State files are stored in a GCS bucket with state locking to prevent concurrency issues.
* **Resource Lifecycle Management:** Implementation of `lifecycle` blocks and `ignore_changes` to handle immutable cloud resources, such as Firestore locations.
* **Least Privilege Access:** Dedicated Service Accounts with specific IAM roles for the Cloud Function execution.

### CI/CD Pipeline
Automated workflows using GitHub Actions:
* **Validation Pipeline:** Triggered on Pull Requests to perform `terraform fmt`, `terraform validate`, and generate a `terraform plan`.
* **Deployment Pipeline:** Triggered on merges to the main branch, executing `terraform apply` and updating the Cloud Function source code.

### Performance and Reliability
* **Memory Optimization:** Function configured with 256MB to handle scraping overhead and prevent Out-Of-Memory (OOM) errors.
* **Idempotency:** The pipeline is designed to be idempotent, ensuring that repeated runs do not cause resource duplication or errors.

## Deployment Instructions

### Prerequisites
* GCP Project with billing enabled.
* Terraform CLI installed.
* Configured Workload Identity Federation or Service Account Keys for GitHub Actions.

### Manual Deployment
1. Initialize the working directory:
   ```bash
   terraform init

2. Preview the infrastructure changes:
   ```bash
   terraform plan

3. Apply the configuration:
   ```bash
   terraform apply

## Repository Structure

* **/terraform**: Contains all HCL files for infrastructure provisioning.
* **/modules**: Modularized resources for compute (Functions) and database (Firestore).
* **/src**: Python source code for the scraping logic and requirements.txt.
* **/.github/workflows**: YAML definitions for the CI/CD pipelines (Plan and Apply).

## Observability and Logs

The application utilizes Python's logging integration with Google Cloud Logging. Logs can be monitored via the Logs Explorer in the GCP Console using the following filter:

`resource.type="cloud_function" AND resource.labels.function_name="gcp-price-monitor"`

## Future Improvements

* Integration with Cloud Pub/Sub for real-time alerting systems.
* Implementation of unit tests for the Python handler using pytest.
* Data visualization dashboard using Looker Studio for price history analysis.

## Author

João Ferreira - [LinkedIn](https://www.linkedin.com/in/joaoferreira-dev)