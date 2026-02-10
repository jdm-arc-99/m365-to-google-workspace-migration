# GAM Cloud Shell Setup Guide

This guide details the setup of **GAM (Google Apps Manager)** within Google Cloud Shell to perform bulk administrative tasks without a local machine dependency.

## Prerequisites
- Google Workspace Super Admin account.
- Google Cloud Project with the creation of Service Accounts enabled.

## 1. Cloud Project Setup
1. **Create Project**: `gcloud projects create gwm-gam-admin`
2. **Enable APIs**:
   ```bash
   gcloud services enable admin.googleapis.com \
     calendar-json.googleapis.com \
     drive.googleapis.com \
     gmail.googleapis.com \
     groupssettings.googleapis.com
   ```

## 2. GAM Installation
Run the following in Cloud Shell:
```bash
bash <(curl -s -S -L https://git.io/gam-install) -l
# Select "N" for browser (use parameters below)
```

## 3. Scopes & Permissions
During the oauth setup, authorize the following scopes (Project > API Controls > Domain-wide Delegation):
- `https://www.googleapis.com/auth/admin.directory.user`
- `https://www.googleapis.com/auth/admin.directory.group`
- `https://www.googleapis.com/auth/admin.directory.orgunit`
- `https://www.googleapis.com/auth/gmail.settings.basic`

## 4. Troubleshooting
> [!TIP]
> If you encounter "Client is unauthorized to retrieve access tokens", ensure the Service Account Client ID is added to **Security > API Controls > Domain-wide Delegation** in the Admin Console.
