# Migration Tooling Comparison: Google Workspace Migrate vs. BitTitan MigrationWiz

This document provides a detailed breakdown of the two primary migration paths for this project: the "Native" path (Google Workspace Migrate) and the "SaaS" path (BitTitan MigrationWiz).

## 1. Why Choose BitTitan MigrationWiz? (The Decision Drivers)

While Google Workspace Migrate (GWM) is free and robust, organizations often choose BitTitan for the following specific reasons:

### A. Simplicity & Speed to Launch (SaaS vs. Self-Hosted)
*   **BitTitan:** is 100% SaaS. You sign up, enter credentials, and start moving data in minutes. No servers to provision.
*   **GWM:** requires a complex on-premise infrastructure (Google Compute Engine nodes, databases, bridge servers) which takes days to architect and secure properly.
*   **Driver:** *If the IT team lacks strong infrastructure skills or needs to start "tomorrow", BitTitan is the choices.*

### B. "Weird" Source Data Handling
*   **Public Folders:** BitTitan has a superior engine for disassembling complex Legacy Exchange Public Folder hierarchies and mapping them to Google Groups or Shared Drives. GWM's handling of Public Folders is manual and rigid.
*   **Hosted Exchange / IMAP:** If the source isn't pure M365 (e.g., a hybrid setup with some users on Rackspace/GoDaddy), BitTitan handles these odd connectors natively.

### C. Error Management & Retries
*   **BitTitan:** allows "User-Level" error management. You can click a specific user, see their 5 failed items, and click "Retry Errors" just for them.
*   **GWM:** operates in bulk "Waves". Retrying errors often requires re-running a large bridge job or complex SQL queries to isolate failures.

---

## 2. Feature & Limitation Matrix

| Feature | Google Workspace Migrate (GWM) | BitTitan MigrationWiz | Winner |
| :--- | :--- | :--- | :--- |
| **Cost** | **Free** (Included with Enterprise license). | **~$12-$15 / User**. | **GWM** |
| **Infrastructure** | **Heavy.** Requires Managing 10-50 VMs in GCP. | **None.** 100% Cloud SaaS. | **BitTitan** |
| **Mail Data** | High fidelity. 25MB limit. | High fidelity. | **Tie** |
| **Permissions** | Good, but complex to map for Drive. | **Granular.** "MustMigrateAllPermissions" flag allows finer control. | **BitTitan** |
| **Throttling** | **Manual Control.** You scale nodes to match quota. | **Auto-Managed.** BitTitan manages back-off, though specific errors still occur. | **BitTitan** |
| **Public Folders** | **Weak.** Converts to Groups. Manual structure mapping. | **Strong.** Highly flexible mapping of hierarchy to Shared Drives/Groups. | **BitTitan** |
| **Security** | **Data Sovereignty.** Data never leaves your GCP project. | **Third-Party Trust.** Data flows through BitTitan servers. | **GWM** |
| **Support** | **Google Cloud Support** (General). | **Specialized Migration Support** (Specific). | **BitTitan** |

---

## 3. The Verdict for Our Architecture

### We Selected: Google Workspace Migrate (GWM)
**Reasoning:**
1.  **Security:** For 5,000 users, we cannot risk data sovereignty issues by piping data through a third-party vendor.
2.  **Cost:** A $75,000 license fee for BitTitan is better spent on Change Management and Training.
3.  **Scale:** Once the GWM "Bridge" infrastructure is built (via Terraform), it scales horizontally to unlimited throughput, whereas SaaS tools often hit "noisy neighbor" bottlenecks.

### When to "Break Glass" and use BitTitan?
If we encounter a specific **Public Folder** hierarchy that is absolutely critical and fails to migrate via GWM, we will purchase a micro-license of BitTitan (e.g., 5-10 seats) just to migrate that specific data set.
