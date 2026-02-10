# GWM Platform & Node Scopes

## 1. Google Cloud Platform (Target)
When provisioning the Google Workspace Migrate infrastructure, the Service Account attached to the GCE VMs must have:

### Platform & Node Service Account Scopes
- `https://www.googleapis.com/auth/devstorage.read_only` (GCS Access for installers)
- `https://www.googleapis.com/auth/logging.write` (Cloud Logging)
- `https://www.googleapis.com/auth/monitoring.write` (Cloud Monitoring)
- `https://www.googleapis.com/auth/servicecontrol`
- `https://www.googleapis.com/auth/service.management.readonly`
- `https://www.googleapis.com/auth/trace.append` (Cloud Trace)

### Domain-Wide Delegation (Workspace Admin Console)
Authorize the Service Account Client ID for:
- `https://www.googleapis.com/auth/admin.directory.group`
- `https://www.googleapis.com/auth/admin.directory.user`
- `https://www.googleapis.com/auth/admin.directory.domain.readonly`
- `https://www.googleapis.com/auth/drive`
- `https://www.googleapis.com/auth/gmail.modify`
- `https://www.googleapis.com/auth/calendar`
- `https://www.googleapis.com/auth/contacts`
- `https://www.googleapis.com/auth/migrate.deployment.interop`

---

## 2. Microsoft 365 (Source)
To enable GWM to read all data without "wasting iterations" on permission errors, configure an **Azure AD Application** with the following permissions.

### Application Permissions (Microsoft Graph)
Grant these in the Azure Portal -> App Registrations -> [Your App] -> API Permissions. **Admin Consent is Required.**

| API / Permission Name | Type | Purpose |
|-----------------------|------|---------|
| **Directory.Read.All** | Application | Read users, groups, and organizational structure. |
| **User.Read.All** | Application | Read full user profiles. |
| **Files.Read.All** | Application | Read all OneDrive and SharePoint files. |
| **Sites.Read.All** | Application | Read SharePoint site collections. |
| **Mail.Read** | Application | Read all mailboxes (Modern Auth). |
| **Calendars.Read** | Application | Read all calendars. |
| **Contacts.Read** | Application | Read all contacts. |

### Exchange Online (Impersonation)
Required for high-fidelity migration of Mail, Calendar, and Contacts via EWS.

1.  Create a **Service Account** in M365 (e.g., `svc-gwm-migration@source-tenant.com`).
2.  Assign the **ApplicationImpersonation** role in Exchange Admin Center:
    *   `ECP -> Permissions -> Admin Roles`
    *   Create `GWM-Impersonation` group.
    *   Add Role: `ApplicationImpersonation`.
    *   Add Member: `svc-gwm-migration`.
