# Microsoft 365 to Google Workspace Migration: Gaps, Pitfalls, and Risks

This document outlines common data fidelity gaps, process pitfalls, and stakeholder concerns encountered during migration from Microsoft 365 to Google Workspace. It serves as a reference for setting expectations and planning mitigations.

## 1. Data Gaps & Limitations

Platform differences between Microsoft and Google architectures make some data types incompatible or difficult to migrate with full fidelity.

### Email & Calendar
*   **Message Size:** Messages >25MB (including attachments) cannot be migrated to Gmail due to strict size limits.
*   **"Received" Headers:** Google Workspace rewrites the 'Received' header timestamp to the time of migration, not the original receipt time. *Impact: Sorting by date may look correct in UI (due to 'Date' header), but audit/compliance searches relying on 'Received' headers may be affected.*
*   **Calendar Attachments:** Attachments embedded in M365 calendar invites are often not migrated or are stripped.
*   **Outlook-Specific Features:**
    *   Categories/Color Coding on emails (Gmail uses Labels, but mapping is not always 1:1).
    *   client-side rules and folder views.
    *   "Notes" and "Tasks" (often require separate migration flows or are not supported by standard tools).

### OneDrive & SharePoint -> Google Drive
*   **File Naming:** OneDrive allows certain characters in file names that are restricted or handled differently in Drive. Deeply nested folder structures may exceed path length limits.
*   **Link Fidelity:** Internal links between M365 documents (e.g., an Excel formula linking to another workbook) will break upon migration to Google Sheets/Drive.
*   **File Versions:** Migration tools often only migrate the *latest* version of a file, losing version history.
*   **Proprietary Formats:** OneNote notebooks, Access databases, and certain complex Excel macros/VBA do not have direct equivalents in Google Workspace and require manual conversion or retention in legacy storage.
*   **Permissions:** "My Drive" does not support the same granular permission inheritance as SharePoint. Migrating complex permission structures to standard "My Drive" folders often results in a "mishmash" of access rights. **Mitigation: Use Shared Drives.**

## 2. Common Pitfalls & Risks

### Technical Pitfalls
*   **EWS Throttling:** Microsoft Exchange Web Services (EWS) aggressively throttles high-volume data extraction. *Mitigation: unexpected slowness. Ensure the migration tool handles back-off correctly or use multiple service accounts.*
*   **Infrastructure bottlenecks:** Running migration agents on under-provisioned VMs or low-bandwidth networks causes failures.
*   **Credential Fatigue:** Expired or MFA-locked service accounts halting the migration mid-stream.

### Process Pitfalls
*   **The "User Upload" Loop:** Users adding data to M365 *after* the initial sync but *before* the cutover, extending the delta pass duration and potentially missing the cutover window.
*   **Incomplete "Stop" Logic:** Inability to cleanly stop or pause a migration wave for a specific user without corrupting their state.
*   **Zombie Accounts:** Migrating disabled or former employee accounts unnecessarily, consuming licenses and time.

## 3. Stakeholder Concerns

Addressing these concerns proactively is crucial for project buy-in.

| Concern | Description | Response / Mitigation |
| :--- | :--- | :--- |
| **Data Fidelity** | "Will I lose my complex Excel models?" | Macros/VBA will not run in Sheets. Identify critical sheets pre-migration; keep Excel licenses for finance/power users if needed. |
| **Business Disruption** | "Will email go down?" | MX record cutover propagates quickly, but there is a risk of downtime. Use TTL reduction and perform cutover during off-hours. |
| **Loss of Features** | "I can't find X feature in Gmail." | Acknowledge the change. Provide "M365 to Google" feature mapping guides (e.g., Outlook Folders -> Gmail Labels). |
| **Security & Compliance** | "Is our data safe during transit?" | Ensure migration tools use encryption in transit. Verify that data is not cached persistently on third-party servers if using SaaS migration tools. |
| **Cost Overruns** | "Why is this taking so long?" | Throttling and data volume are the main variables. Perform a proper POC to estimate throughput per user. |

## 4. Mitigation Strategies

*   **Pre-Migration Scan:** Run a scan to identify files >25MB, deep paths, and incompatible file types *before* moving data.
*   **Shared Drives for Team Data:** Do not migrate department data to a user's "My Drive". Map SharePoint libraries to Google Shared Drives to enforce cleaner permissions.
*   **Communication Campaign:** Explicitly warn users about the "Received" header change and broken document links to manage expectations.

## 5. Tooling Strategy & Justification

Stakeholders often ask: *"Why use Google Workspace Migrate (GWM) instead of a SaaS tool like BitTitan MigrationWiz?"*

| Feature | Google Workspace Migrate (GWM) | Third-Party SaaS (e.g., BitTitan) | Decision Driver |
| :--- | :--- | :--- | :--- |
| **Security & Data Sovereignty** | **High.** binary data streams directly from Source -> Google. No intermediate persistent storage. Data stays within customer-controlled GCP projects. | **Medium.** Data passes through vendor infrastructure. Requires trusting vendor's security posture and compliance certifications. | **Security Compliance.** For strict regulatory environments, keeping data within our controlled perimeter is preferred. |
| **Cost** | **Free.** Included with Google Workspace enterprise licenses. Infrastructure costs (VMs) are negligible relative to license savings. | **High.** Typically ~$12–$15 per user. For 5,000 users, this would cost **~$60,000–$75,000**. | **Budget.** Significant cost avoidance allows budget reallocation to change management and training. |
| **Logging & Audit** | **Native BigQuery.** Logs export directly to our BigQuery dataset for custom, granular SQL analysis and retention. | **Proprietary.** Logs are retained in the vendor's portal. Export capabilities vary; custom analysis is limited. | **Auditability.** We require SQL-level access to migration logs for "Zero Hour" error triage. |
| **Performance Control** | **Granular.** We control the number of bridge nodes and service accounts to manage throughput and throttling. | **Black Box.** Throughput is managed by the vendor's shared infrastructure load balancing. | **Control.** We need the ability to scale infrastructure up/down based on our specific observed throttling limits. |

**Conclusion:** GWM is selected to maximize security control and cost efficiency, despite the higher initial infrastructure setup complexity.

