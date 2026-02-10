# M365 PowerShell Permissions Matrix

To run the assessment and interaction scripts in `automation/powershell/`, the executing account (or App Registration) requires the following permissions.

## 1. Graph API (Application Permissions)
Used for non-interactive scripts scanning the tenant.

| Permission | Purpose | Justification |
|------------|---------|---------------|
| `User.Read.All` | Inventory Users | Required to map 5,000 users for license planning. |
| `Group.Read.All` | Inventory Groups | Needed to map M365 Groups/Teams to Google Groups. |
| `Files.Read.All` | Scan OneDrive | Required for the OneNote/Rclone assessment script. |
| `Sites.Read.All` | Scan SharePoint | Assess document libraries for Shared Drive migration. |

## 2. Exchange Online (Role Based)
Used for mailbox statistics and forwarding configuration.

| Role / Cmdlet | Purpose |
|---------------|---------|
| **Organization Management** | `Set-Mailbox` | **Super Admin for Exchange**. Full access to all configuration and data. |
| **Recipient Management** | `Set-Mailbox` | Sufficient for configuring forwarding addresses on user mailboxes. |
| **View-Only Organization Management** | `Get-Mailbox` | Read-only access to all configuration (safest for assessment). |

## 3. Azure AD Roles
- **Global Reader**: Sufficient for most read-only assessment scripts.
- **User Administrator**: Required if the script creates "Mail Contacts" for co-existence.
- **Global Administrator**: The "Super Admin" for the entire tenant. Includes full Exchange access implicitly.
