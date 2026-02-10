# Project Risk Register

## Resource & Infrastructure Risks
| Risk ID | Description | Impact | Probability | Mitigation Strategy |
|---------|-------------|--------|-------------|----------------------|
| R-101 | **GCP Quota Exceedance** (`DISKS_TOTAL_GB`, `CPUS_ALL_REGIONS`) | High | High | Proactively request quota increases 4 weeks before the mass migration wave. |
| R-102 | **EWS Throttling** | Medium | High | Implement multi-node GWM clusters and background sync deltas. |
| R-103 | **Windows License Activation** | Low | Medium | Utilize KMS or automated activation logic in PowerShell startup scripts. |

## Migration & Data Risks
| Risk ID | Description | Impact | Probability | Mitigation Strategy |
|---------|-------------|--------|-------------|----------------------|
| R-201 | **OneNote Data Loss** | Medium | Medium | Maintain read-only access to M365 for 90 days; provide "Save as PDF" guides. |
| R-202 | **Shared Drive Overflow** | Low | Low | Monitor Drive storage limits and implement Shared Drive OUs early. |
| R-203 | **Timeline Slippage** (April 30 Deadline) | High | Medium | Prioritize "Wave 1" users (Tech/Data) and defer complex non-critical business units. |
