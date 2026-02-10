# GWM Platform & Node Scopes

When provisioning the Google Workspace Migrate infrastructure via Terraform or gcloud, the following OAuth scopes are **mandatory** for the Service Account attached to the VMs.

## Platform & Node Service Account Scopes
The instances must be created with the following scopes to ensure proper logging, monitoring, and API access:

- `https://www.googleapis.com/auth/devstorage.read_only` (GCS Access for installers)
- `https://www.googleapis.com/auth/logging.write` (Cloud Logging)
- `https://www.googleapis.com/auth/monitoring.write` (Cloud Monitoring)
- `https://www.googleapis.com/auth/servicecontrol`
- `https://www.googleapis.com/auth/service.management.readonly`
- `https://www.googleapis.com/auth/trace.append` (Cloud Trace)

## Application Scopes (Domain-Wide Delegation)
These must be authorized in the Google Workspace Admin Console for the GWM Service Account Client ID:
- `https://www.googleapis.com/auth/admin.directory.group`
- `https://www.googleapis.com/auth/admin.directory.user`
- `https://www.googleapis.com/auth/admin.directory.domain.readonly`
- `https://www.googleapis.com/auth/drive`
- `https://www.googleapis.com/auth/gmail.modify`
- `https://www.googleapis.com/auth/calendar`
- `https://www.googleapis.com/auth/contacts`
- `https://www.googleapis.com/auth/migrate.deployment.interop`
