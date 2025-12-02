locals {
    required_apis = [
        "compute.googleapis.com",
        "sql-component.googleapis.com",
        "sqladmin.googleapis.com",
        "run.googleapis.com",
        "storage.googleapis.com",
        "cloudbuild.googleapis.com",
        "secretmanager.googleapis.com",
        "iam.googleapis.com",
        "cloudresourcemanager.googleapis.com"
    ]
}