# Business Architecture: OU & Group Structure

## Identity Integration (Phase B)
The migration will utilize **Google Cloud Directory Sync (GCDS)** to bridge the gap between Microsoft 365 (Azure AD) and the Google Workspace Target.

### Directory Mapping
| Source (Azure AD / Okta) | Target (Google Workspace OU) | Role / Team |
|-------------------------|------------------------------|-------------|
| Tech-Division-Engineers | `/Users/Technology/Engineering` | Software Engineering |
| Data-Science-Org        | `/Users/Technology/DataScience` | Data & BI |
| External-Contractors    | `/Users/External`             | Contingent Staff |
| Admin-PowerUsers        | `/Admin/SystemAdmins`        | Role-Based Access |

## Group Strategy
- **Dynamic Groups**: Use Google Workspace Dynamic Groups based on Azure AD attributes (e.g., `department: "engineering"`) to automate membership.
- **Shared Drive Access**: Groups will be mapped to Google Shared Drives to replace M365 SharePoint / OneDrive Shared libraries.

## Naming Conventions
- **Users**: `first.last@domain.com`
- **Groups**: `g-dept-role@domain.com` (e.g., `g-data-analysts@domain.com`)
- **Shared Drives**: `SD-[Dept]-[Project]`
