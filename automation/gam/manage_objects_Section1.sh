#!/bin/bash
# GAM Script for Workbook Section 1 Scenarios
# Focus: Object Management (Users, Drives, Groups)

# ------------------------------------------------------------------------------
# 1.1 Account Lifecycle (Interns Scenario)
# ------------------------------------------------------------------------------
# Create Interns OU
gam create ou "/Users/Interns" description "Summer Intern Program"

# CSV Bulk Upload Template Generation (for reference)
# gam print users to "intern_template.csv" fields firstname,lastname,email,password,orgunitpath

# License Assignment Strategy (Diagnostic Q3)
# Disable auto-licensing at root, enable for specific OUs
# Note: GAM cannot directly toggle 'Automatic Licensing' settings (Admin Console UI task),
# but can assign licenses effectively.
echo "Manually disable Automatic Licensing at Root in Admin Console > Billing."

# Compromised Account Procedure (Diagnostic Q2)
# Function to secure a user
secure_compromised_user() {
    local target_email=$1
    echo "Securing account: $target_email"
    gam update user $target_email suspended on
    gam user $target_email deporvision_mobile_devices
    gam user $target_email signout
    gam user $target_email turn_off_2sv
    # Password reset would happen here
}

# ------------------------------------------------------------------------------
# 1.2 Google Drive Configuration (Surgical Team Scenario)
# ------------------------------------------------------------------------------
# Create Shared Drive
gam create teamdrive "Surgical-Training-Resources"

# Assign Roles (Diagnostic Q4)
# Senior Team = Manager (Manage Content, People, Settings)
gam add drivefileacl "Surgical-Training-Resources" user senior.trainer@domain.com role organizer

# Junior Team = Contributor (Add/Edit files, but not delete/move rooted)
# Note: 'fileOrganizer' in API = Content Manager; 'writer' = Contributor
gam add drivefileacl "Surgical-Training-Resources" user junior.resident@domain.com role writer

# External Sharing Policy (Diagnostic Q5)
# Restrict sharing to Allowlisted Domains (Admin Console policy)
echo "Ensure 'Allowlisted Domains' is configured in Drive > Sharing Settings."

# ------------------------------------------------------------------------------
# 1.4 Groups Configuration (HR & Marketing Scenario)
# ------------------------------------------------------------------------------
# Marketing "Announcement Only" Group (Diagnostic Q7)
gam create group anniversary-event@domain.com name "Cymbal Health Anniversary"
gam update group anniversary-event@domain.com \
    who_can_post_message owner_managers \
    who_can_view_membership all_in_domain_can_view \
    who_can_view_group all_in_domain_can_view \
    allow_external_members true

# HR "Restricted/Custom" Group
gam create group benefits-questions@domain.com name "Benefits Questions"
gam update group benefits-questions@domain.com \
    who_can_post_message any_member \
    who_can_view_group all_members_can_view \
    allow_external_members false

echo "Section 1 Object Management Applied."
