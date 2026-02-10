# OneNote & Rclone Migration Guide

## Overview
OneNote notebooks cannot be directly migrated to Google Workspace with full fidelity using standard tools. This guide outlines the strategy for handling OneNote data and using **Rclone** for high-speed file transfer of other OneDrive assets.

## OneNote Migration Strategy
> [!WARNING]
> OneNote notebooks in OneDrive are not physical files (they are API markers). Rclone cannot "copy" them directly.

### 1. Discovery
Run the [SharePoint/OneDrive Assessment Script](../../automation/powershell/assess_onedrive.ps1) to identify users with >50MB of OneNote data.

### 2. User-Driven Conversion (Recommended)
Instruct users to use the "Print to PDF" feature for static notebooks or manually copy content to Google Docs for active ones. A "Migration Day" guide is available in `governance/training/`.

### 3. Automated Archival (Fallback)
For critical retention:
1. Use the **SharePoint Migration Tool (SPMT)** to download notebooks to a local staging server.
2. The notebooks will convert to folder structures (`.one` files).
3. Upload these folders to Google Drive via Rclone as "Cold Storage" (readable only by the OneNote desktop app).

---

## Rclone Setup for OneDrive
Rclone is used to bypass the sync client for bulk OneDrive migration to Google Drive.

### 1. Configuration
```bash
rclone config
# 1. New Remote -> "onedrive" (Type 31)
# 2. Client ID/Secret: [Leave Blank or use tailored App Registration]
# 3. Edit advanced config: No
# 4. Remote config: Use auto-config (browser login)
```

### 2. Bulk Transfer Command
```bash
rclone copy "onedrive:/My Files" "gdrive:/Migrated_OneDrive" \
  --transfers=32 \
  --checkers=64 \
  --drive-chunk-size=128M \
  --log-file=migration.log \
  --progress
```

### 3. Verification
```bash
rclone check "onedrive:/My Files" "gdrive:/Migrated_OneDrive" --one-way
```
