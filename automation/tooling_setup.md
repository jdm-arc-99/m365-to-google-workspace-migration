# Migration Tooling Setup Guide

This document serves as the master index for downloading, installing, and configuring the essential tools required for the M365 to Google Workspace migration.

## 1. Google Apps Manager (GAM)
*Crucial for bulk object management, license assignment, and group configuration.*

*   **Purpose**: Command-line administration of Google Workspace.
*   **Download**: [GAMADV-XTD3 GitHub Releases](https://github.com/taers232c/GAMADV-XTD3/releases)
*   **Installation (Linux/Mac/Cloud Shell)**:
    ```bash
    bash <(curl -s -S -L https://git.io/install-gam)
    ```
*   **Installation (Windows)**:
    *   Download the `.msi` installer from the Releases page.
*   **Verification**:
    ```bash
    gam version
    ```

## 2. Rclone
*Required for "The OneNote Gap" and bulk file transfers not handled by GWM.*

*   **Purpose**: High-speed cloud-to-cloud file sync.
*   **Download**: [Rclone Downloads](https://rclone.org/downloads/)
*   **Installation**:
    ```bash
    # Linux/Mac
    sudo -v ; curl https://rclone.org/install.sh | sudo bash
    ```
*   **Configuration**:
    *   Run `rclone config` to authorize with OneDrive (Source) and Google Drive (Target).

## 3. PowerShell 7 (Core)
*Required for running the `automation/powershell/` scripts on Linux/Mac/Windows.*

*   **Purpose**: Cross-platform automation (Azure AD interactions).
*   **Download**: [PowerShell GitHub](https://github.com/PowerShell/PowerShell)
*   **Installation (Linux - Ubuntu/Debian)**:
    ```bash
    sudo apt-get install -y powershell
    ```
*   **Modules Needed**:
    ```powershell
    Install-Module -Name Microsoft.Graph -Scope CurrentUser
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser
    ```

## 4. Google Cloud SDK (gcloud)
*Required for provisioning the GWM infrastructure.*

*   **Purpose**: Managing GCE instances and VPCs.
*   **Download**: [Install gcloud CLI](https://cloud.google.com/sdk/docs/install)
*   **Auth**:
    ```bash
    gcloud auth login
    gcloud config set project <project-id>
    ```

## 5. Google Workspace Migrate (GWM)
*Server-side platform software.*

*   **Purpose**: The core migration engine.
*   **Component**: **Google Workspace Migrate Platform**
    *   [Download Link (Authorized Users Only)](https://support.google.com/workspacemigrate/answer/9222862)
    *   *Note*: This is installed on the Windows Server instances managed by Terraform.

---

> [!TIP]
> **Cloud Shell Recommendation**: For most administrative tasks (GAM, gcloud), we recommend using **Google Cloud Shell**, which comes pre-installed with `gcloud` and where GAM can be easily installed without local admin rights.
