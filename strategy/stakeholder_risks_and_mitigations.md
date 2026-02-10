# Microsoft 365 to Google Workspace Migration: Gaps, Pitfalls, and Risks

This document outlines common data fidelity gaps, process pitfalls, and stakeholder concerns encountered during migration from Microsoft 365 to Google Workspace. It serves as a reference for setting expectations and planning mitigations.

## 🚨 Executive Summary: Top 3 Critical Gaps & Mitigations

If you remember nothing else, plan for these three risks:

1.  **Mailbox Throttling:** M365 aggressively throttles data exits.
    *   *Mitigation:* Use multiple Service Accounts (not just one) and request a temporary EWS policy lift from Microsoft Support.
2.  **OneDrive/SharePoint Permissions:** Complex permission inheritance does *not* translate to Google Drive.
    *   *Mitigation:* Do not "lift and shift" directly to My Drive. Flatten file structures and migrate departmental data to **Shared Drives** which have cleaner, group-based permissions.
3.  **OneNote Incompatibility:** OneNote notebooks cannot be directly converted to Google formats with high fidelity.
    *   *Mitigation:* Identify heavy OneNote users early. Use a specialized tool (AvePoint/ShareGate) for just those specific users/sites, or convert critical notes to PDF/Docx manually.

---

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

## 5. Co-existence & Interoperability Strategy

During the migration (which may span weeks), ensuring seamless communication between M365 and Google Workspace users is critical.

*   **Mail Routing (Split Delivery):** We will configure Split Delivery where Google Workspace acts as the primary gateway, routing messages for non-migrated users back to M365.
*   **Calendar Co-existence:** We will enable **Google Calendar Interop** to allow bi-directional Free/Busy lookups between Outlook and Google Calendar users.

> [!TIP]
> For detailed configuration steps on setting up Split Delivery and Calendar Interop, refer to the [Co-existence and Interoperability Guide](coexistence_and_interoperability.md).

## 6. Tooling Strategy & Justification

Stakeholders often ask: *"Why use Google Workspace Migrate (GWM) instead of a SaaS tool like BitTitan MigrationWiz?"*

| Feature | Google Workspace Migrate (GWM) | Third-Party SaaS (e.g., BitTitan) | Decision Driver |
| :--- | :--- | :--- | :--- |
| **Security & Data Sovereignty** | **High.** binary data streams directly from Source -> Google. No intermediate persistent storage. Data stays within customer-controlled GCP projects. | **Medium.** Data passes through vendor infrastructure. Requires trusting vendor's security posture and compliance certifications. | **Security Compliance.** For strict regulatory environments, keeping data within our controlled perimeter is preferred. |
| **Cost** | **Free.** Included with Google Workspace enterprise licenses. Infrastructure costs (VMs) are negligible relative to license savings. | **High.** Typically ~$12–$15 per user. For 5,000 users, this would cost **~$60,000–$75,000**. | **Budget.** Significant cost avoidance allows budget reallocation to change management and training. |
| **Logging & Audit** | **Native BigQuery.** Logs export directly to our BigQuery dataset for custom, granular SQL analysis and retention. | **Proprietary.** Logs are retained in the vendor's portal. Export capabilities vary; custom analysis is limited. | **Auditability.** We require SQL-level access to migration logs for "Zero Hour" error triage. |
| **Performance Control** | **Granular.** We control the number of bridge nodes and service accounts to manage throughput and throttling. | **Black Box.** Throughput is managed by the vendor's shared infrastructure load balancing. | **Control.** We need the ability to scale infrastructure up/down based on our specific observed throttling limits. |

**Conclusion:** GWM is selected to maximize security control and cost efficiency, despite the higher initial infrastructure setup complexity.

## 7. Advanced Mitigations & Specialized Tools ("Break Glass" Options)

Migration is complex, and sometimes the standard path involves roadblocks. Below are industry-standard "workarounds" and specialized tools used to overcome specific pitfalls.

### A. Overcoming Throttling & Speed Issues
*   **The "EWS Throttling Policy" Lift (Source):**
    *   *Technique:* Request Microsoft Support (via Ticket) to temporarily relax EWS throttling policies for the migration duration (typically 30-90 days).
    *   *Result:* Can increase throughput by 2-3x during peak transfer times.
*   **Scaled Service Accounts (Destination):**
    *   *Technique:* Instead of using one Service Account for all data, shard the migration across 10-20 Service Accounts.
    *   *Implementation:* GWM handles this natively if configured with multiple "Target Connectors".

### B. High-Fidelity Content (OneNote & SharePoint)
*   **Problem:** GWM and native tools often convert OneNote to flat PDFs or mess up complex SharePoint pages.
*   **Alternative Tooling:**
    *   **AvePoint Fly / ShareGate:** These paid tools have specialized engines for **Microsoft 365 -> Google** that offer higher fidelity for *specific* workloads.
    *   *Strategy:* If a department (e.g., Legal, Research) refuses to lose OneNote structure, purchase a **tactical license** of AvePoint/ShareGate just for that team (e.g., 50 users), while migrating the other 4,950 users via GWM.

### C. Large File Handling (>25GB or Deep Paths)
*   **Rclone (The "Swiss Army Knife"):**
    *   *Technique:* For localized large datasets (e.g., a Media Team's video archive), use `rclone` (open source command line tool) on a dedicated VM.
    *   *Command:* `rclone copy onedrive:VideoArchive google:SharedDrive/VideoArchive --transfers=16`.
    *   *Benefit:* Bypasses some of the overhead of heavy migration GUIs and handles large files/retries robustly.
*   **Physical Data Transfer (Uncommon now):**
    *   For Petabyte-scale, Google offers a **Transfer Appliance** (rack-mountable server shipped to your data center), but for M365 cloud-to-cloud, this is rarely applicable.

### D. Managing "User Behavior" Risks
*   **The "Read-Only" Lock:**
    *   *Technique:* Run a PowerShell script to set M365 mailboxes and OneDrive to "Read-Only" at the exact moment of cutover.
    *   *Benefit:* Prevents the "User Upload Loop" where users keep working in the old system, creating data gaps.
    ```powershell
    Set-Mailbox -Identity user@example.com -MaxSizeSend 0KB -MaxSizeReceive 0KB
    Set-SPOSite -Identity https://tenant-my.sharepoint.com/personal/user_example_com -LockState ReadOnly
    ```

## 8. User-Side & Supplementary Tools

While GWM handles the "heavy lifting" (95% of data), specialized tools empower users to move their own niche data and help Admins fix edge cases.

### A. For Users (Self-Service)
*   **Google Workspace Migration for Microsoft Outlook (GWMMO):**
    *   *Best For:* Moving local PST files or re-migrating a specific mailbox that had errors.
    *   *Deployment:* Push the MSI to users via Endpoint Manager. Users sign in with Google credentials to pull data from their local Outlook profile.
    *   *Gap Filler:* Excellent for "legacy" email archives stored on user laptops that central IT doesn't see.
*   **Google Drive for Desktop:**
    *   *Best For:* Manual drag-and-drop of critical active files.
    *   *Scenario:* A user has a working folder of 50 complex Excel files. They can drag them directly into `G: > My Drive` to ensure they are available immediately at cutover, bypassing the central queue.

### B. For Admins (Automation & Fixups)
*   **GAM / GAMADV-XTD3 (Command Line):**
    *   *The "Swiss Army Knife" for Admins.* GWM migrates data, but GAM cleans up the mess.
    *   *Key Use Cases:*
        *   **Fixing Permissions:** "Re-acl" Drive files if shares are broken.
        *   **Resource Calendars:** Bulk-update room resource settings (capacity, equipment) which don't migrate well.
        *   **Email Signatures:** Bulk-push standardized Gmail signatures to all users post-migration.
    *   *Command Example:* `gam all users sync drivefileacl user@example.com` (Fixes access for a specific VIP).

## 9. Community Wisdom & "In-the-Trenches" Tips

Based on diverse migration experiences (Reddit/SysAdmin communities), here are non-obvious tools and scripts to keep handy.

### A. The "Safety Net": Got Your Back (GYB)
*   **What it is:** A free, open-source command-line tool for backing up and restoring Gmail accounts.
*   **Why you need it:** If a VIP's migration goes wrong and you need to "wipe and reload" their mailbox without re-running the heavy GWM bridge, GYB is faster for single-user operations.
*   *Link:* [GAM-team/got-your-back](https://github.com/GAM-team/got-your-back)

### B. PowerShell Pre-Provisioning Script
*   **The Trap:** GWM can create users, but often fails to license them correctly in time for the data load, causing "Mailbox Not Found" errors.
*   **The Fix:** Do not rely on the migration tool to create users. Script the creation and licensing of ALL users in Google Workspace 48 hours *before* migration starts.
*   *Tool:* `Google Cloud Directory Sync (GCDS)` or a simple GAM loop:
    ```bash
    gam csv users.csv gam create user ~email firstname ~firstname lastname ~lastname password <random>
    ```

### C. Folder Exemptions (Speed Hack)
*   **The Tip:** A massive amount of migration time is wasted on "Junk Email" and "Deleted Items".
*   **The Fix:** Explicitly configure GWM (or your engine of choice) to **skip** these folders.
    *   *Exclusion Filter:* `Junk Email`, `Deleted Items`, `RSS Feeds`.
    *   *Impact:* Can reduce total object count by 20-30%.




