# Migration Pitfalls & Mitigation Strategies

## 1. OneNote to Google Workspace
- **Problem**: OneNote notebooks lack a direct equivalent in Google Workspace. Conversion to Google Docs often loses hierarchical structure.
- **Mitigation**:
    - **Inventory**: Use a PowerShell script to inventory all OneNote files in OneDrive/SharePoint.
    - **Transformation**: Use the Google Workspace Migrate tool to convert notebooks to Google Drive folders containing PDFs or Google Docs for individual pages.
    - **User Advisory**: Inform Tech/Data teams early about the change in note-taking workflow (suggesting Google Docs or Google Keep for lightweight notes).

## 2. EWS Throttling (Microsoft 365)
- **Problem**: Microsoft EWS limits data extraction rates, which will bottleneck a 5,000-user migration.
- **Mitigation**:
    - **Cluster Scaling**: Deploy a 10+ node GWM cluster using the `infrastructure/terraform` logic.
    - **Service Account Impersonation**: Enable application impersonation in M365 to allow GWM to act on behalf of users without per-user credential overhead.
    - **Off-Peak Scheduling**: Schedule massive data transfers during weekends and evening hours to maximize available EWS bandwidth.

## 3. Data Governance & eDiscovery
- **Problem**: Compliance requirements for real estate data must be maintained during transfer.
- **Mitigation**:
    - **Google Vault Setup**: Pre-configure Google Vault discovery and retention rules *before* the first wave of data arrives.
    - **Integrity Validation**: Use GWM's native logging to verify that 100% of items identified in the assessment phase were transferred or accounted for in error logs.

## 4. GWM Bridge Scaling
- **Problem**: Undocumented performance degradation when a single bridge handles >100 users.
- **Mitigation**: 
    - **Sharding**: Architect the migration to use ~50 separate bridges (100 users each) for the 5,000-user population.
    - **Automation**: Use the `setup-bridges.ps1` script (planned) to auto-provision these bridges via the GWM API.

## 5. Native Reporting Gaps
- **Problem**: GWM built-in reports frequently fail to download or timeout.
- **Mitigation**:
    - **BigQuery Export**: Rely on the SQL queries defined in `strategy/monitoring_and_reporting.md` for reliable throughput and error tracking.
