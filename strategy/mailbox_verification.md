# Mailbox Verification Procedures

## Post-Migration Validation (Zero Hour + 24 Hours)

### 1. Quantitative Verification (Automated)
Run the `verify_counts.ps1` script to compare item counts between Source (M365) and Target (Gmail).

- **Threshold**: <2% discrepancy is acceptable (often due to corrupt items or filter rules).
- **Critical Check**: Verify `Inbox` and `Sent Items` match closely. `Deleted Items` often varies.

### 2. Qualitative Verification (Manual "White Glove")
Select 5 VIP users and 5 random users from the current wave.

1. **Calendar**: Check recurring meetings for:
   - Correct time zone.
   - Resource (Room) booking retention.
   - External attendee visibility.
2. **Drive**: Open 3 random files (Doc, Sheet, PDF) to ensure permissions carried over.
3. **Mail**: Send a test email from an external account to verify MX/Split-Delivery routing.

### 3. BigQuery Analysis
Use the GWM logging export to query for failed items:
```sql
SELECT email, item_subject, error_message
FROM `migration_logs.failed_items`
WHERE wave = 'Wave-1'
AND error_type != 'Transient'
ORDER BY email
```
> [!NOTE]
> GWM reporting is sometimes limited; use this direct BigQuery access for reliable error tracking.
