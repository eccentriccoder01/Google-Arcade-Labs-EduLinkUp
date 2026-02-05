#!/bin/bash

# Define color variables
BLACK_TEXT=$'[0;90m'
RED_TEXT=$'[0;91m'
GREEN_TEXT=$'[0;92m'
YELLOW_TEXT=$'[0;93m'
BLUE_TEXT=$'[0;94m'
MAGENTA_TEXT=$'[0;95m'
CYAN_TEXT=$'[0;96m'
WHITE_TEXT=$'[0;97m'

NO_COLOR=$'[0m'
RESET_FORMAT=$'[0m'

# Define text formatting variables
BOLD_TEXT=$'[1m'
UNDERLINE_TEXT=$'[4m'

clear

# Welcome message
echo "${YELLOW_TEXT}${BOLD_TEXT}╔══════════════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║                   EDULINKUP LAB AUTOMATION                       ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║              Launching Your Cloud Learning Journey...            ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}╚══════════════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo

# Region Configuration
echo "${BLUE_TEXT}${BOLD_TEXT}Step 1: Configuring Cloud Region${RESET_FORMAT}"
echo "${WHITE_TEXT}Detecting your project's default region...${RESET_FORMAT}"
echo

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

if [ -z "$REGION" ]; then
  echo "${YELLOW_TEXT}No default region detected in project configuration${RESET_FORMAT}"
  echo "${CYAN_TEXT}Please enter your desired region (e.g., us-central1):${RESET_FORMAT}"
  read -p "${WHITE_TEXT}Region: ${RESET_FORMAT}" REGION
  export REGION
fi

echo "${GREEN_TEXT}Region configured: ${REGION}${RESET_FORMAT}"
echo

# Enable SQL Admin API
echo "${BLUE_TEXT}${BOLD_TEXT}Step 2: Enabling SQL Admin API${RESET_FORMAT}"
echo "${WHITE_TEXT}Activating Cloud SQL administration service...${RESET_FORMAT}"
echo

gcloud services enable sqladmin.googleapis.com

echo "${GREEN_TEXT}SQL Admin API successfully enabled${RESET_FORMAT}"
echo

# Create Cloud SQL Instance
echo "${BLUE_TEXT}${BOLD_TEXT}Step 3: Creating Cloud SQL Instance${RESET_FORMAT}"
echo "${YELLOW_TEXT}This may take several minutes to complete...${RESET_FORMAT}"
echo

gcloud sql instances create my-instance   --project=$DEVSHELL_PROJECT_ID   --region=$REGION   --database-version=MYSQL_5_7   --tier=db-n1-standard-1

echo "${GREEN_TEXT}Cloud SQL instance 'my-instance' created${RESET_FORMAT}"
echo

# Create MySQL Database
echo "${BLUE_TEXT}${BOLD_TEXT}Step 4: Creating MySQL Database${RESET_FORMAT}"
echo

gcloud sql databases create mysql-db   --instance=my-instance   --project=$DEVSHELL_PROJECT_ID

echo "${GREEN_TEXT}MySQL database 'mysql-db' created${RESET_FORMAT}"
echo

# Create BigQuery Dataset
echo "${BLUE_TEXT}${BOLD_TEXT}Step 5: Setting Up BigQuery Dataset${RESET_FORMAT}"
echo

bq mk --dataset $DEVSHELL_PROJECT_ID:mysql_db

echo "${GREEN_TEXT}BigQuery dataset 'mysql_db' created${RESET_FORMAT}"
echo

# Create BigQuery Table
echo "${BLUE_TEXT}${BOLD_TEXT}Step 6: Creating BigQuery Table Structure${RESET_FORMAT}"
echo

bq query --use_legacy_sql=false "CREATE TABLE \`${DEVSHELL_PROJECT_ID}.mysql_db.info\` (
  name STRING,
  age INT64,
  occupation STRING
);"

echo "${GREEN_TEXT}BigQuery table schema created${RESET_FORMAT}"
echo

# Generate Sample Data
echo "${BLUE_TEXT}${BOLD_TEXT}Step 7: Generating Sample Data File${RESET_FORMAT}"
echo

cat > employee_info.csv <<EOF
"Sean",23,"Content Creator"
"Emily",34,"Cloud Engineer"
"Rocky",40,"Event Coordinator"
"Kate",28,"Data Analyst"
"Juan",51,"Program Manager"
"Jennifer",32,"Web Developer"
EOF

echo "${GREEN_TEXT}Sample data file 'employee_info.csv' generated${RESET_FORMAT}"
echo

# Create Cloud Storage Bucket
echo "${BLUE_TEXT}${BOLD_TEXT}Step 8: Creating Cloud Storage Bucket${RESET_FORMAT}"
echo

gsutil mb gs://$DEVSHELL_PROJECT_ID

echo "${GREEN_TEXT}Storage bucket created${RESET_FORMAT}"
echo

# Upload Data to Cloud Storage
echo "${BLUE_TEXT}${BOLD_TEXT}Step 9: Uploading Data to Cloud Storage${RESET_FORMAT}"
echo

gsutil cp employee_info.csv gs://$DEVSHELL_PROJECT_ID/

echo "${GREEN_TEXT}Data file uploaded to storage${RESET_FORMAT}"
echo

# Configure Service Account Permissions
echo "${BLUE_TEXT}${BOLD_TEXT}Step 10: Configuring Service Account Permissions${RESET_FORMAT}"
echo

SERVICE_EMAIL=$(gcloud sql instances describe my-instance   --format="value(serviceAccountEmailAddress)")

gsutil iam ch serviceAccount:$SERVICE_EMAIL:roles/storage.admin   gs://$DEVSHELL_PROJECT_ID/

echo "${GREEN_TEXT}Service account permissions configured${RESET_FORMAT}"
echo

# Final message
echo
echo "${GREEN_TEXT}${BOLD_TEXT}╔══════════════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}║                   LAB COMPLETED SUCCESSFULLY!                    ║${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}╚══════════════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo
echo "${MAGENTA_TEXT}${BOLD_TEXT}📺 SUBSCRIBE TO EDULINKUP FOR MORE CLOUD LABS! 📺${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}${UNDERLINE_TEXT}🔗 https://www.youtube.com/@EduLinkUp${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}💡 Keep Learning, Keep Growing! 💡${RESET_FORMAT}"
echo
