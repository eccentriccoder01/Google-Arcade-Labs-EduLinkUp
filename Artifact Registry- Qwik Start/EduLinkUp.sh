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


BLINK_TEXT=$'\033[5m'
NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'
REVERSE_TEXT=$'\033[7m'

# Step 1: Get GCP project ID & Region
echo "${BOLD}${BLUE}Getting current GCP Project ID & Region...${RESET}"
export PROJECT_ID=$(gcloud config get-value project)

export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

# Step 2: Create Docker Artifact Registry repository
echo "${BOLD}${GREEN}Creating Docker Artifact Registry repository...${RESET}"
gcloud artifacts repositories create example-docker-repo --repository-format=docker \
    --location=$REGION --description="Docker repository" \
    --project=$PROJECT_ID

# Step 3: Configure Docker to use Artifact Registry
echo "${BOLD}${RED}Configuring Docker to use Artifact Registry...${RESET}"
gcloud auth configure-docker $REGION-docker.pkg.dev

# Step 4: Pull sample Docker image
echo "${BOLD}${BLUE}Pulling sample Docker image...${RESET}"
docker pull us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0

# Step 5: Tag Docker image for Artifact Registry
echo "${BOLD}${MAGENTA}Tagging Docker image for Artifact Registry...${RESET}"
docker tag us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0 \
$REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

# Step 6: Push Docker image to Artifact Registry
echo "${BOLD}${GREEN}Pushing Docker image to Artifact Registry...${RESET}"
docker push $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

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
