# Workbook Integration Strategy

This document maps the "Google Workspace Administrator Journey" workbook sections to our implementation tasks, ensuring all certification-level best practices are applied to the 5,000-user migration.

## Section 1: Managing Objects
- **User Lifecycle**: Automated via `automation/gam/setup_workspace.sh` (OUs/Groups).
- **Directory Sync**: Handled by GCDS (mapped in `architecture/business/ou_group_structure.md`).

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
