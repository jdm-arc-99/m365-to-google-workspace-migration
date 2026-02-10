# Google Workspace Migrate Monitoring & Reporting

> [!NOTE]
> Native reporting in GWM can be unreliable (e.g., download failures). We recommend using BigQuery logs export for accurate throughput analysis.

## 1. Throughput Analysis (BigQuery)
To help monitor API calls and data throughput, benchmark against the `activity` dataset.

```sql
SELECT
  EXTRACT(date FROM TIMESTAMP_MICROS(time_usec) AT TIME ZONE "America/Los_Angeles") AS date,
  email,
  token.client_id,
  token.api_name,
  token.method_name
FROM
  `your-project-id.your-dataset.activity`
WHERE
  token.client_id = 'your-service-account-client-id'
  AND token.num_response_bytes IS NOT NULL
  AND DATE(_PARTITIONTIME) > "2026-01-01"
ORDER BY
  1 DESC
```

## 2. Failed Item Analysis
Stream logs from MySQL to BigQuery (via Data Fusion) or use the GWM internal logs to catch specific item failures.

## 3. Bridge Architecture Constraints
> [!IMPORTANT]
> **Bridge Limit**: There is an undocumented soft limit on how many actions/partitions a single bridge can create.
> - **Recommendation**: Limit to **100 users per bridge**.
> - **Action**: Create multiple bridges in the GWM Platform for the 5,000-user wave (approx. 50 bridges).
