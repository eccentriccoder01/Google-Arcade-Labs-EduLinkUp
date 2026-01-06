#!/bin/bash

# Define color variables
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'

NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'

# Define text formatting variables
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

clear

# Welcome message
echo "${YELLOW_TEXT}${BOLD_TEXT}╔══════════════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║                   EDULINKUP LAB AUTOMATION                       ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║              Launching Your Cloud Learning Journey...            ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}╚══════════════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo


gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set compute/zone "$ZONE"

gcloud config set compute/region "$REGION"

gcloud spanner databases create finance \
  --instance=bitfoon-dev \
  --ddl="CREATE TABLE Account (
            AccountId BYTES(16) NOT NULL,
            CreationTimestamp TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true),
            AccountStatus INT64 NOT NULL,
            Balance NUMERIC NOT NULL
         ) PRIMARY KEY (AccountId);"

ACCOUNT_IDS=("ACCOUNTID11123" "ACCOUNTID12345" "ACCOUNTID24680" "ACCOUNTID135791")

for ID in "${ACCOUNT_IDS[@]}"; do
  echo "Inserting AccountId: $ID"
  ENCODED_ID=$(echo -n "$ID" | base64)
  gcloud spanner databases execute-sql finance \
    --instance=bitfoon-dev \
    --sql="INSERT INTO Account (AccountId, CreationTimestamp, AccountStatus, Balance) VALUES (FROM_BASE64('$ENCODED_ID'), PENDING_COMMIT_TIMESTAMP(), 1, 22);"
done

gcloud spanner databases ddl update finance \
  --instance=bitfoon-dev \
  --ddl="CREATE CHANGE STREAM AccountUpdateStream FOR Account(AccountStatus, Balance);"

bq --location="$REGION" mk --dataset "$PROJECT_ID:changestream"

echo
echo -e "\033[1;33mCreate a Dataflow\033[0m \033[1;34mhttps://console.cloud.google.com/dataflow/createjob?inv=1&invt=Ab2T9A&project=$DEVSHELL_PROJECT_ID\033[0m"
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
