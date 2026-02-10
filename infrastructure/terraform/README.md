# Infrastructure as Code: Terraform Architecture

## Directory Structure
```css
infrastructure/terraform/
├── environments/
│   ├── tenant-setup/      # Initial Cloud Identity and VPC setup
│   └── migration-prod/    # Production migration worker clusters (CSV-driven)
└── modules/
    ├── platform-server/   # GWM Platform server (Windows)
    ├── database-mysql/    # GWM MySQL dependency
    ├── database-couchdb/  # GWM CouchDB dependency
    ├── node-server/       # GWM worker nodes (Windows)
    └── vpc-network/       # Isolated migration network
```

## Branching Strategy
- **`main`**: Reflects the production state of the migration infrastructure.
- **`feature/*`**: Short-lived branches for module updates or environment changes.
- **Environment Parity**: Since this is a single-tenant migration, we use a single `main` branch with directory-based environment separation (`environments/`).

## Implementation Standards
1. **Providers**: Use Google and Google-Beta.
2. **State**: Remote state GCS buckets with versioning enabled.
3. **Provisioning**: All VM provisioning must include `metadata_startup_script` to download PowerShell installers via signed URLs.
4. **Password Management**: Use `local-exec` with `gcloud compute reset-windows-password` as a bootstrap measure, injecting results into local `.txt` or Secret Manager.
