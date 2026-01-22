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


# ================== COLOR DEFINITIONS ==================
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'

BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'
RESET_FORMAT=$'\033[0m'

# ================== WELCOME ==================
echo "${CYAN_TEXT}${BOLD_TEXT}==================================================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}      SUBSCRIBE EduLinkUp - INITIATING EXECUTION...              ${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}==================================================================${RESET_FORMAT}"
echo

# ================== PROJECT SET ==================
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
  echo -e "${RED_TEXT}No active project found. Exiting.${RESET_FORMAT}"
  exit 1
fi

# ================== ENABLE APIS ==================
echo -e "${YELLOW_TEXT}Enabling Database Migration API...${RESET_FORMAT}"
gcloud services enable datamigration.googleapis.com --quiet

echo -e "${YELLOW_TEXT}Enabling Service Networking API...${RESET_FORMAT}"
gcloud services enable servicenetworking.googleapis.com --quiet

# ================== USER INPUT ==================
echo
echo -e "${BOLD_TEXT}${YELLOW_TEXT}Please enter the connection profile details:${RESET_FORMAT}"

read -p "$(echo -e "${BOLD_TEXT}${WHITE_TEXT}Connection Profile ID (example: mysql-source-profile): ${RESET_FORMAT}")" CONNECTION_PROFILE_ID
read -p "$(echo -e "${BOLD_TEXT}${WHITE_TEXT}Connection Profile Display Name: ${RESET_FORMAT}")" CONNECTION_PROFILE_NAME
read -p "$(echo -e "${BOLD_TEXT}${WHITE_TEXT}Source MySQL External IP: ${RESET_FORMAT}")" HOST_OR_IP
read -p "$(echo -e "${BOLD_TEXT}${WHITE_TEXT}Region [default: us-east4]: ${RESET_FORMAT}")" REGION

REGION=${REGION:-us-east4}

# ================== CONSTANTS ==================
USERNAME="admin"
PASSWORD="changeme"
PORT=3306

# ================== CHECK IF PROFILE EXISTS ==================
if gcloud database-migration connection-profiles describe "$CONNECTION_PROFILE_ID" \
  --region="$REGION" >/dev/null 2>&1; then

  echo -e "${YELLOW_TEXT}${BOLD_TEXT}Connection profile '${CONNECTION_PROFILE_ID}' already exists in region '${REGION}'.${RESET_FORMAT}"

else
  # ================== CREATE PROFILE ==================
  gcloud database-migration connection-profiles create mysql "$CONNECTION_PROFILE_ID" \
    --display-name="$CONNECTION_PROFILE_NAME" \
    --region="$REGION" \
    --host="$HOST_OR_IP" \
    --port="$PORT" \
    --username="$USERNAME" \
    --password="$PASSWORD"

  if [ $? -eq 0 ]; then
    echo -e "${GREEN_TEXT}${BOLD_TEXT}Connection profile created successfully!${RESET_FORMAT}"
  else
    echo -e "${RED_TEXT}${BOLD_TEXT}Failed to create connection profile.${RESET_FORMAT}"
    exit 1
  fi
fi

# ================== FINAL MESSAGE ==================
echo
echo "${CYAN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}              TASK 1 COMPLETED SUCCESSFULLY!           ${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo
echo "${RED_TEXT}${BOLD_TEXT}${UNDERLINE_TEXT}https://www.youtube.com/@EduLinkUp${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}Don't forget to Like, Share and Subscribe${RESET_FORMAT}"
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
