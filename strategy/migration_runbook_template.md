# Migration Execution Runbook (Template)

## Wave ID: [e.g., Tech-Wave-1]
**Target Date**: [Date]
**User Count**: [Number]

### 1. T-Minus 14 Days: Provisioning
- [ ] Initialize Terraform for Worker Cluster (`infrastructure/terraform/environments/migration-prod`).
- [ ] Verify GCDS sync for Wave 1 users.
- [ ] Generate Signed URLs for latest GWM installers.

### 2. T-Minus 7 Days: Staging
- [ ] Seed background data (Mail/Drive) using GWM delta sync.
- [ ] Verify OneNote hierarchy for high-priority users.
- [ ] Distribute "Migration Day" guide to users.

### 3. T-Minus 24 Hours: Final Prep
- [ ] Perform final Delta Sync.
- [ ] Audit Google Vault retention rules.
- [ ] Freeze M365 write access (optional, depending on coexistence strategy).

### 4. Zero Hour: Cutover
- [ ] Update MX records (if global) or Split-Delivery routing.
- [ ] Reset Google Workspace passwords (if not using SSO/Okta).
- [ ] Activate helpdesk "War Room."

### 5. Post-Migration (Day 1-7)
- [ ] Monitor eDiscovery search results.
- [ ] Address OneNote accessibility tickets.
- [ ] Decommission successful migration workers to save cost.
