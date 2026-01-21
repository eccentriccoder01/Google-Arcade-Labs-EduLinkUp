#!/bin/bash

# =========================
# Color & Format Variables
# =========================
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

BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

clear

# =========================
# Welcome Banner
# =========================
echo "${YELLOW_TEXT}${BOLD_TEXT}╔══════════════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║                   EDULINKUP LAB AUTOMATION                       ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║     Cloud Storage + Load Balancer Configuration Starting...      ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}╚══════════════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo

# =========================
# Project & Resource Setup
# =========================
export PROJECT_ID=$(gcloud config get-value project)

OLD_BUCKET="${PROJECT_ID}-bucket"
NEW_BUCKET="${PROJECT_ID}-new"

echo "${CYAN_TEXT}${BOLD_TEXT}📌 Active Project:${RESET_FORMAT} ${WHITE_TEXT}${PROJECT_ID}${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}📦 Source Bucket:${RESET_FORMAT} ${WHITE_TEXT}${OLD_BUCKET}${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}🆕 Target Bucket:${RESET_FORMAT} ${WHITE_TEXT}${NEW_BUCKET}${RESET_FORMAT}"
echo

# =========================
# Create & Configure Bucket
# =========================
echo "${BLUE_TEXT}${BOLD_TEXT}🪣 Creating new Cloud Storage bucket...${RESET_FORMAT}"
gsutil mb "gs://${NEW_BUCKET}"

echo "${BLUE_TEXT}${BOLD_TEXT}🌐 Configuring bucket for static website hosting...${RESET_FORMAT}"
gsutil web set -m index.html -e error.html "gs://${NEW_BUCKET}"

echo "${BLUE_TEXT}${BOLD_TEXT}🔓 Setting public access permissions...${RESET_FORMAT}"
gsutil iam ch allUsers:roles/storage.admin "gs://${NEW_BUCKET}"

# =========================
# Sync Data
# =========================
echo "${BLUE_TEXT}${BOLD_TEXT}🔄 Syncing content from source bucket...${RESET_FORMAT}"
gsutil -m rsync -r "gs://${OLD_BUCKET}" "gs://${NEW_BUCKET}"

# =========================
# Load Balancer Setup
# =========================
echo "${BLUE_TEXT}${BOLD_TEXT}⚙️ Creating backend bucket with CDN enabled...${RESET_FORMAT}"
gcloud compute backend-buckets create backend-new \
  --gcs-bucket-name="${NEW_BUCKET}" \
  --enable-cdn

echo "${BLUE_TEXT}${BOLD_TEXT}🗺️ Creating URL map...${RESET_FORMAT}"
gcloud compute url-maps create website-map \
  --default-backend-bucket=backend-new

echo "${BLUE_TEXT}${BOLD_TEXT}🎯 Creating HTTP proxy...${RESET_FORMAT}"
gcloud compute target-http-proxies create website-proxy \
  --url-map=website-map

echo "${BLUE_TEXT}${BOLD_TEXT}🌍 Creating global forwarding rule (port 80)...${RESET_FORMAT}"
gcloud compute forwarding-rules create website-rule \
  --global \
  --target-http-proxy=website-proxy \
  --ports=80

# =========================
# Completion Message
# =========================
echo
echo "${GREEN_TEXT}${BOLD_TEXT}╔══════════════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}║                   LAB COMPLETED SUCCESSFULLY!                    ║${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}╚══════════════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo
echo "${MAGENTA_TEXT}${BOLD_TEXT}📺 SUBSCRIBE TO EDULINKUP FOR MORE CLOUD LABS! 📺${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}${UNDERLINE_TEXT}🔗 https://www.youtube.com/@EduLinkUp${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}💡 Keep Learning, Keep Growing! 💡${RESET_FORMAT}"
echo
