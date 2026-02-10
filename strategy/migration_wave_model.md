# Migration Strategy: Wave Model (April Deadline)

## Wave 1 Schedule (Tech & Data Teams)

### Phase 1: Preparation (Weeks 1-3)
- [ ] Infrastructure Provisioning (Terraform/PowerShell).
- [ ] Initial GCDS Identity Sync.
- [ ] Deployment of 10-node Migration Cluster.

### Phase 2: Pilot (Weeks 4-5)
- [ ] Migration of 100 "Champions" from Tech/Data teams.
- [ ] Verification of OneNote/Drive conversion issues.
- [ ] Training and SOP distribution.

### Phase 3: Mass Migration (Weeks 6-8)
- [ ] **Target**: 5,000 users.
- [ ] **Method**: Background sync (Delta migration) followed by weekend cutover.
- [ ] **Cutover Date**: Friday, April 24, 2026.

## Rollback & Contingency
- **Co-existence Period**: Maintain dual-routing for 14 days post-migration.
- **Rollback Trigger**: Failure of >15% of mail delivery or catastrophic data loss in Google Drive.
