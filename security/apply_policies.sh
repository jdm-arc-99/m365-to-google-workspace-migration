#!/bin/bash
# Security Policy Application Script
# Based on Workbook Section 4.1: Securing Devices

# 1. Mobile Device Management (MDM) - Advanced
# Enforce strong passwords and block compromised devices
gam update org "/Users/Technology" android_management_level advanced ios_management_level advanced
gam update org "/Users/Technology" mobile_password_requirement strong minimum_password_length 8
gam update org "/Users/Technology" mobile_screen_lock_timeout 15

# 2. Context-Aware Access (CAA) - Parter Access
# Based on Workbook Section 4.2
# Restrict partner access to specific subnet
gam create accesslevel "Partner-Office-IP" \
    description "Allow access only from Partner HQ" \
    basic_level "ip_subnets: 203.0.113.0/24"

# Assign to Drive
# Note: Actual assignment requires the Access Level ID returned above
echo "Context-Aware Access Level created. Assign to Drive via Admin Console."

# 3. Data Regions (EU Residency)
# Based on Workbook Section 2.1
gam update org "/Users/Research/EU_Lab" data_regions europe

echo "Security policies applied successfully."
