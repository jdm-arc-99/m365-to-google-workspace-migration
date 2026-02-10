# Workbook Integration Strategy

This document maps the "Google Workspace Administrator Journey" workbook sections to our implementation tasks, ensuring all certification-level best practices are applied to the 5,000-user migration.

## Section 1: Managing Objects
- **Account Lifecycle (1.1)**:
  - *Scenario*: Intern provisioning without AD.
  - *Action*: Use Bulk Upload CSV standard (First, Last, Email, OrgUnit).
  - *Security*: Revoke tokens & wipe devices for compromised accounts (Diagnostic Q2).
  - *Licensing*: Disable "Automatic Licensing" at Root; Enable at OU level (Diagnostic Q3).
- **Google Drive (1.2)**:
  - *Scenario*: Senior Surgical Team (Manager) vs Junior (Contributor).
  - *Action*: Granular Shared Drive permissions (Manager vs Content Manager vs Contributor).
  - *External Sharing*: Allowlisted Domains only; Disable "Anyone with the link".
- **Calendar Resources (1.3)**:
  - *Scenario*: Facilities Management.
  - *Action*: Delegate "Make changes to events" to Facility Admins; structured resources.
- **Groups (1.4)**:
  - *Scenario*: "Announcement Only" for Marketing; "Custom" for HR.
  - *Action*: Restrict "Who can contact group owners"; Enable "Allow members outside organization" for specific use cases.

## Section 2: Configuring Services
- **Data Regions (2.1)**:
  - *Requirement*: EU data residency for specific research units.
  - *Action*: Configure "Data Regions" policy in Admin Console for `OU/Europe`.
- **Gmail Routing (2.2)**:
  - *Requirement*: SMTP Relay for legacy printers/apps.
  - *Action*: Configure Secure Transport (TLS) compliance rules.

## Section 3: Troubleshooting
- **Email Log Search (3.1)**:
  - *Requirement*: Investigating missing messages.
  - *Action*: Use BigQuery export (`strategy/monitoring_and_reporting.md`) for advanced analysis beyond native tool limits.

## Section 4: Data Access and Authentication
- **Mobile Device Management (4.1)**:
  - *Requirement*: Block devices after 5 failed unlock attempts.
  - *Policy*: Set Mobile Management to "Advanced" -> Password Requirements -> Compliance Rules.
- **Context-Aware Access (4.2)**:
  - *Requirement*: Restrict partner access to specific IPs.
  - *Policy*: Create Access Level for "Partner Network" and assign to Drive/Docs apps.
- **SSO (4.4)**:
  - *Requirement*: SAML with 3rd party IdP (Okta/Azure AD).
  - *Action*: Upload X.509 certificate and configure Sign-in/Sign-out URLs.

## Section 5: Supporting Business Initiatives
- **Vault Retention (5.1)**:
  - *Requirement*: 10-year retention for "Drug Trial" data.
  - *Action*: Custom retention rules based on OU or Label.
- **Reporting (5.2)**:
  - *Requirement*: Monitor external sharing.
  - *Action*: Custom Alerts in Security Center for "Drive > Visibility Change > External".
