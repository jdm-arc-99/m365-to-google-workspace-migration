# Security & Configuration Standards

Derived from the **Google Workspace Administrator Journey** workbook.

## 1. Device Security
- **MDM Level**: Advanced (Required for selective wipe and approval).
- **Password Policy**: Strong (Complex, 8+ chars).
- **Screen Lock**: 15 minutes max.
- **Failures**: Device wipes after 5 failed attempts (configured in Admin Console > Mobile > Password settings).

## 2. Context-Aware Access
- **Scenario**: Partner Collaboration.
- **Policy**: `Partner-Office-IP`.
- **Condition**: Subnet `203.0.113.0/24`.
- **Enforcement**: Applied to Google Drive and Docs.

## 3. Data Residency
- **Scenario**: EU Research Compliance.
- **Policy**: Data Regions -> "Europe".
- **Scope**: `OU/Research/EU_Lab`.
