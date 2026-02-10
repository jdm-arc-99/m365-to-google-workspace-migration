#!/bin/bash
# High-level GAM automation for the 5,000-user migration

# 1. Create Organizational Units based on Business Architecture
gam create ou "/Users/Technology"
gam create ou "/Users/Technology/Engineering"
gam create ou "/Users/Technology/DataScience"
gam create ou "/Users/External"

# 2. Initialize Core Groups
gam create group g-engineering@domain.com name "Engineering Team"
gam create group g-data-science@domain.com name "Data Science Team"

# 3. Apply basic settings
gam update group g-engineering@domain.com who_can_post_message everyone_in_domain
gam update group g-data-science@domain.com who_can_post_message everyone_in_domain

echo "Workspace OUs and Groups initialized successfully."
