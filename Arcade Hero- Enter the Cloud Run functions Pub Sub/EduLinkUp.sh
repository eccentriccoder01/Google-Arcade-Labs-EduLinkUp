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


# Set your project
export PROJECT_ID=$(gcloud config get-value project)

# Set default region
DEFAULT_REGION="us-central1"

# Prompt user to enter region with default value
echo "Enter your preferred region (default: $DEFAULT_REGION):"
read REGION

# Use default if no input provided
REGION=${REGION:-$DEFAULT_REGION}

echo "Using region: $REGION"

# Set the region in gcloud config
gcloud config set functions/region $REGION
gcloud config set compute/region $REGION

# Clone the repository and navigate to the function
git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git
cd nodejs-docs-samples/functions/v2/helloPubSub/

# Deploy the function
gcloud functions deploy cf-demo \
--gen2 \
--runtime=nodejs20 \
--region=$REGION \
--source=. \
--entry-point=helloPubSub \
--trigger-topic=cf_topic \
--quiet

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
