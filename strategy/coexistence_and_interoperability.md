# Co-existence and Interoperability Guide

This guide details the technical configuration required to maintain interoperability between Microsoft 365 (M365) and Google Workspace (GWS) during the migration phase.

## 1. Mail Routing (Split Delivery)

Split delivery ensures that users on both platforms can send and receive email using the same domain (e.g., `@example.com`).

### Architecture Overview
*   **Primary MX:** Google Workspace (Recommended for final state).
*   **Routing Logic:** Google Workspace receives all mail. If the recipient exists in GWS, deliver locally. If not, route to M365 via a smart host.

### Configuration Steps

#### Step 1: Google Workspace (Primary)
1.  **Add Domain:** Ensure the domain is verified in GWS.
2.  **Configure Host:**
    *   Go to **Apps > GWS > Gmail > Hosts**.
    *   Add Route: `M365-Host`.
    *   Server: `[your-tenant].mail.protection.outlook.com`.
    *   Port: `25`.
    *   Options: Check "Require TLS".
3.  **Configure Routing Rule:**
    *   Go to **Apps > GWS > Gmail > Routing**.
    *   Create a rule "Split Delivery to M365".
    *   *Messages to affect:* Inbound & Internal-receiving.
    *   *Envelope filter:* "Only affect specific envelope recipients" -> "Pattern match" -> `.*@example.com`.
    *   *Route:* Change route to `M365-Host`.
    *   *Conditions:* "Also deliver to Addressee" (Dual delivery) OR "Perform this action on non-recognized addresses only" (Split delivery). **Split Delivery is preferred to avoid duplicates.**

#### Step 2: Microsoft 365 (Secondary)
1.  **Accepted Domains:** Set the domain to **Internal Relay** (not Authoritative). This allows M365 to route unknown recipients back to GWS if necessary.
2.  **Connectors:**
    *   Create an Inbound Connector: From "Your Organization's Email Server" -> To "Office 365".
    *   Identify by: IP address range of Google Workspace (see Google IP blocks).

---

## 2. Calendar Interoperability

Allows users on both systems to view each other's Free/Busy availability.

### Prerequisites
*   **Google Role Account:** A standard GWS user (no admin rights) used by Exchange to query GWS.
*   **Exchange Role Account:** A User or Service Account in M365 used by Google to query Exchange.

### Configuration Steps

#### Step 1: Google Admin Console
1.  Navigate to **Apps > GWS > Calendar > Calendar Interop Management**.
2.  **Exchange Web Services (EWS) URL:** `https://outlook.office365.com/EWS/Exchange.asmx`.
3.  **Exchange Role Account:** Enter the credentials of the M365 service account configued above.
4.  **Google Role Account:** Enter the email of the GWS user created for lookups.
5.  **User Mapping:** Standard (email address matching).

#### Step 2: Microsoft 365 (Exchange Online)
1.  **Availability Address Space:** Run PowerShell to tell Exchange where to look for `@example.com` availability (if pointing to GWS).
    ```powershell
    Add-AvailabilityAddressSpace -ForestName example.com -AccessMethod OrgWideFB -UseServiceAccount $true -TargetAutodiscoverEpr "https://www.google.com/calendar/feeds/exchange/"
    ```
    *(Note: Since the domain is shared, specific intra-organization connectors created by the Google Calendar Interop tool usually handle this. Use the "Automatic User Provisioning" tool provided by Google for the most reliable setup.)*

#### Step 3: Verification
*   **Test GWS -> M365:** Create a meeting in Google Calendar, add an M365 user. Verify "Find a Time" shows their blue blocks.
*   **Test M365 -> GWS:** Create a meeting in Outlook Web Access (OWA), add a GWS user. Verify availability.

## 3. Co-existence Management & Limitations

### Managing the "Split Brain"
*   **Global Address List (GAL):** Neither system automatically sees the other's *new* users.
    *   **Solution:** Use **Google Cloud Directory Sync (GCDS)** to sync M365 users as "Shared Contacts" into Google Workspace.
    *   **Reverse:** Script a sync of GWS users as "Mail Contacts" into M365 (less common for short migrations).
*   **Resource Booking:** Rooms should live in ONE system (target state).
    *   Migrate all Resource Mailboxes to Google Workspace early.
    *   Configure Outlook users to book them via the GWS Interop (treated as external attendees).

### Common Pitfalls
*   **Sensitivity Labels:** "Private" events in Outlook may show as "Busy" in Google, but details are stripped.
*   **Recurrence Exceptions:** moved meetings in a recurring series may not sync changes perfectly across interop.
