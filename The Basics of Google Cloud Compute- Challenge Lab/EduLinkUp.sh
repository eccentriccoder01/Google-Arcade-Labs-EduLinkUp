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


# ========================= COLOR DEFINITIONS =========================
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'
TEAL_TEXT=$'\033[38;5;50m'

BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'
BLINK_TEXT=$'\033[5m'
NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'
REVERSE_TEXT=$'\033[7m'

set -e
pause_for_yes() {
  echo
  read -p "Press Y to continue: " choice
  if [[ "$choice" != "Y" && "$choice" != "y" ]]; then
    echo "${RED_TEXT}${BOLD_TEXT}❌ Script stopped by user.${RESET_FORMAT}"
    exit 1
  fi
}

# ========================= WELCOME MESSAGE =========================
echo "${CYAN_TEXT}${BOLD_TEXT}==================================================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}      SUBSCRIBE EduLinkUp- INITIATING EXECUTION...  ${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}==================================================================${RESET_FORMAT}"
echo

# ========================= PROJECT & ZONE =========================
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
ZONE=$(gcloud compute zones list --limit=1 --format="value(name)")

INSTANCE_NAME="EduLinkUp-vm"
DISK_NAME="EduLinkUp-disk"

# ========================= VALIDATION =========================
if [[ -z "$PROJECT_ID" || -z "$ZONE" || -z "$INSTANCE_NAME" || -z "$DISK_NAME" ]]; then
  echo "${RED_TEXT}${BOLD_TEXT}❌ ERROR: Required variables are empty${RESET_FORMAT}"
  exit 1
fi

echo "${GREEN_TEXT}✔ Project ID : $PROJECT_ID${RESET_FORMAT}"
echo "${GREEN_TEXT}✔ Zone       : $ZONE${RESET_FORMAT}"
echo

# ========================= ENABLE API =========================
echo "${YELLOW_TEXT}${BOLD_TEXT}▶ Enabling Compute Engine API...${RESET_FORMAT}"
gcloud services enable compute.googleapis.com
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}▶ Create Instance Manually ...${RESET_FORMAT}"
pause_for_yes

# ========================= CREATE DISK =========================
echo "${YELLOW_TEXT}${BOLD_TEXT}▶ Creating Persistent Disk...${RESET_FORMAT}"
gcloud compute disks create mydisk \
  --size=200GB \
  --zone $ZONE
echo

# ========================= ATTACH DISK =========================
echo "${YELLOW_TEXT}${BOLD_TEXT}▶ Attaching Disk to VM...${RESET_FORMAT}"
gcloud compute instances attach-disk my-instance \
  --disk mydisk \
  --zone "$ZONE"
echo

# ========================= SSH TEST =========================
echo "${YELLOW_TEXT}${BOLD_TEXT}▶ Testing SSH connection...${RESET_FORMAT}"
gcloud compute ssh "$INSTANCE_NAME" --zone="$ZONE" --command="echo SSH Connected Successfully"
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
