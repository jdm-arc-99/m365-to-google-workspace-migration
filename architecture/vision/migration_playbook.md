# Architecture Vision: M365 to Google Workspace Migration

## Executive Summary
This vision outlines the partial migration of 5,000 Tech and Data users from Microsoft 365 to a unified Google Workspace tenant. The goal is to achieve cost standardization and specialized toolset alignment by **April 30, 2026**.

## Key Drivers
- **Cost Efficiency**: Consolidating tech-heavy units on Google Workspace.
- **Technical Excellence**: Provisioning Data/Tech teams with native Google Cloud integration.
- **Aggressive Timeline**: Phase 1 cutover required in ~60 days.

## Technical Pitfalls & Mitigation

### 1. OneNote Migration
> [!WARNING]
> OneNote does not have a native 1:1 equivalent in Google Workspace (Keep is insufficient).
- **Strategy**: Migrate high-value OneNote content to Google Docs or maintain read-only M365 access for 90 days post-cutover.
- **Tooling**: Use Google Workspace Migrate with custom mapping for notebook structure.

### 2. EWS Throttling
- **Risk**: Aggressive migrations of 5,000 users will trigger Microsoft EWS throttling.
- **Mitigation**: Deploy a multi-node Google Workspace Migrate cluster (Platform + MySQL + CouchDB + 10+ Nodes) as defined in `infrastructure/terraform`.

### 3. File Sharing Permissions
- **Risk**: Complex share permissions in OneDrive frequently break during transfer.
- **Mitigation**: Perform a preliminary eDiscovery/Scan Wave (TOGAF Phase E) using the migration workers to identify shared-link dependencies.

## Target Architecture (Phase A)
- **Identity**: Azure AD / Okta as primary IdP, synced via Google Cloud Directory Sync (GCDS).
- **Core Services**: Gmail, Drive, Calendar, Meet, Chat.
- **Specialized Tools**: Google Cloud Platform (GCP) integration for Data teams.
