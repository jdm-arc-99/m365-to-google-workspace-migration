# Migration Checklist Manifesto & Delivery Approaches

## 1. Technical Delivery Approaches
Before executing the checklist, confirm the chosen delivery model.

### Option A: The "Wave" Model (Selected for 5k Users)
**Best for**: Large enterprises, risk aversion, complex department dependencies.
- **Strategy**: Group users by department (Tech, Data, HR) and migrate in bi-weekly batches.
- **Pros**: Lower support volume, iterative learning.
- **Cons**: Prolonged co-existence period (free/busy interoperability required).

### Option B: "Big Bang" Cutover
**Best for**: Small companies (<500 users), simple data structures.
- **Strategy**: Migrate everyone over a single weekend.
- **Pros**: No co-existence complexity.
- **Cons**: High risk; support team overwhelmed on Day 1.

---

## 2. Phase 1: Assessment & Discovery
*Technical Goal*: Map the Source (M365) to Target (Workspace) and identify blockers.*

- [ ] **Identity Scan**: Export all Azure AD Users, Groups, and Contacts.
    - *Tool*: `Get-AzureADUser` / Graph API
- [ ] **Data Volume Analysis**: Identify mailboxes >50GB and OneDrive >1TB.
    - *Action*: Flag for VIP handling or pre-migration archiving.
- [ ] **Integration Inventory**: List all apps relying on SSO/SAML (Okta/Azure AD).
- [ ] **OneNote Audit**: specific scan for `.one` files in SharePoint/OneDrive.
- [ ] **Resource Booking Logic**: Map "Room Mailboxes" to Google Calendar Resources.

## 3. Phase 2: Foundation (Infrastructure)
*Technical Goal*: Build the "landing zone" in Google Cloud.*

- [ ] **GCP Project Setup**: Create rigid project structure with billing enabled.
- [ ] **Network Topology**: Deploy VPC and Firewall rules for GWM.
    - *Validation*: Verify port 443 (Outbound) and 3389 (Admin access) logic.
- [ ] **Identity Bridge**: Configure Google Cloud Directory Sync (GCDS) or GCCS.
    - *Check*: Ensure users are suspended in Google until license assignment.
- [ ] **Provisioning**: Deploy GWM Platform + 10 Nodes via Terraform.
    - *Ref*: `infrastructure/terraform/environments/migration-prod/`

## 4. Phase 3: Migration Execution (The Factory)
*Technical Goal*: Move bits and bytes with zero data loss.*

- [ ] **Bridge Sharding**: provisioning 1 bridge per 100 users.
- [ ] **Delta Sync 1**: 90-day historical mail + Drive data.
    - *Timing*: T-Minus 4 weeks.
- [ ] **Delta Sync 2**: Recent items.
    - *Timing*: T-Minus 1 week.
- [ ] **Cutover Sync (Final Delta)**: The "weekend" run.
- [ ] **Verify Mailbox Item Counts**: Run `strategy/mailbox_verification.md` procedure.
- [ ] **Error Remediation**: Retry failed items >3 times before flagging.

## 5. Phase 4: Workbook Compliance & Certification Readiness
*Ensuring the environment matches the "Administrator Journey" standards.*

### 5.1 Object Management
- [ ] **Intern Provisioning**: Verify CSV upload process for users without AD accounts.
- [ ] **Compromised Account Protocol**: Test `secure_compromised_user` function (Revoke tokens, Wipe device).
- [ ] **Shared Drive Rights**: Confirm "Senior Trainers" have Manager access; "Juniors" have Contributor.

### 5.2 Security & Services
- [ ] **Data Regions**: Verify `OU/Research/EU_Lab` is pinned to "Europe".
- [ ] **Context-Aware Access**: Attempt login from non-Partner IP to verify block.
- [ ] **MDM Enforcement**: Enroll test Android folder and verify 15-min screen lock policy.
- [ ] **Gmail Routing**: Validate SMTP Relay TLS enforcement for legacy printers.

## 6. Phase 5: Post-Migration Administration
*Technical Goal*: Stabilize the new environment.*

- [ ] **MX Record Swing**: Switch mail flow to Google.
- [ ] **Outlook Decommissioning**: Push GPO to remove Outlook profile or deploy GWSSMO.
- [ ] **Storage Quotas**: Apply Drive storage limits to prevent abuse.
- [ ] **License cleanup**: Reclaim M365 licenses for migrated users.
