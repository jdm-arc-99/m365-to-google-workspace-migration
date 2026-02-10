# GAM Command Reference for Administrators

This guide details the specific **GAM (Google Apps Manager)** commands required to administer the 5,000-user Google Workspace environment.

## 1. User Management

### Provisioning
> [!NOTE]
> GCDS handles the bulk creation, but GAM is used for "fix-it" tasks.

```bash
# Create a single user
gam create user <email> firstname <First> lastname <Last> password <Password> org <OrgUnitPath>

# Update a user's Organization Unit
gam update user <email> org "/Users/Technology/Engineering"
```

### Offboarding
```bash
# Deprovision a user immediately
gam update user <email> suspended on

# Transfer Drive files to a manager
gam create datatransfer <LeaverEmail> gdrive <ManagerEmail>
```

## 2. Group Management

### Dynamic Group Logic
We prioritize Dynamic Groups, but for manual overrides:

```bash
# Add member to a group
gam update group <GroupEmail> add member <UserEmail>

# Sync members from a CSV (Bulk)
gam update group <GroupEmail> sync member csv <PathToCSV>
```

## 3. Shared Drives (Team Folders)
Shared Drives replace SharePoint Document Libraries.

```bash
# Create a Shared Drive
gam create drivefile drivefilename "Engineering-Architecture" parentid root mimetype application/vnd.google-apps.folder

# **Correct Command for Shared Drive Creation**:
gam create teamdrive "Engineering-Architecture"

# Add members
gam add drivefileacl <DriveID> user <UserEmail> role organizer
```

## 4. Calendar Resource Management
Mapping "Room Mailboxes" to Google Resources.

```bash
# Create a Building
gam create building id "HQ-NYC" name "Headquarters - New York"

# Create a Feature (e.g., Video Conference)
gam create feature id "VC" name "Video Conferencing"

# Create a Resource (Room)
gam create calendarresource id "HQ-10-ConfA" name "10-A Conference Room" capacity 10 building "HQ-NYC" feature "VC"
```

## 5. Security & Auditing

### 2-Step Verification (2SV)
```bash
# Check 2SV enrollment status for the Engineering OU
gam print user ou "/Users/Technology/Engineering" 2sv
```

### OAuth Token Revocation
```bash
# Revoke all tokens for a compromised user
gam user <email> deprovision
```
