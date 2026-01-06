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

set -e

echo "${BOLD_TEXT}${CYAN_TEXT}Setting up environment...${RESET_FORMAT}"

# Check project ID
echo "${BLUE_TEXT}Checking Project ID...${RESET_FORMAT}"
PROJECT_ID=$(gcloud config get-value project)
echo "${GREEN_TEXT}Current Project ID: ${PROJECT_ID}${RESET_FORMAT}"

# Install virtualenv
echo "${BLUE_TEXT}Installing virtualenv...${RESET_FORMAT}"
sudo apt-get update -qq
sudo apt-get install -y virtualenv

# Create and activate virtual environment
echo "${BLUE_TEXT}Creating Python virtual environment...${RESET_FORMAT}"
python3 -m venv venv
source venv/bin/activate

# Install dependencies
echo "${BLUE_TEXT}Installing Google Cloud Pub/Sub client library...${RESET_FORMAT}"
pip install --upgrade pip
pip install --upgrade google-cloud-pubsub

# Clone sample repository
echo "${BLUE_TEXT}Cloning Pub/Sub sample repository...${RESET_FORMAT}"
git clone https://github.com/googleapis/python-pubsub.git
cd python-pubsub/samples/snippets

# Verify current directory
echo "${GREEN_TEXT}Current directory: $(pwd)${RESET_FORMAT}"

# Create topic
echo "${YELLOW_TEXT}Creating Pub/Sub topic: MyTopic${RESET_FORMAT}"
python publisher.py $PROJECT_ID create MyTopic

# List topics
echo "${TEAL}Listing all Pub/Sub topics...${RESET_FORMAT}"
python publisher.py $PROJECT_ID list

# Create subscription
echo "${YELLOW_TEXT}Creating subscription: MySub${RESET_FORMAT}"
python subscriber.py $PROJECT_ID create MyTopic MySub

# List subscriptions
echo "${TEAL}Listing all subscriptions in project...${RESET_FORMAT}"
python subscriber.py $PROJECT_ID list-in-project

# Publish messages
echo "${MAGENTA_TEXT}Publishing messages to topic MyTopic...${RESET_FORMAT}"
gcloud pubsub topics publish MyTopic --message "Hello from Cloud Shell"
gcloud pubsub topics publish MyTopic --message "Publisher's name is Cloud Student"
gcloud pubsub topics publish MyTopic --message "Publisher likes to eat pizza"
gcloud pubsub topics publish MyTopic --message "Publisher thinks Pub/Sub is awesome"

# Receive messages
echo "${CYAN_TEXT}Pulling messages from subscription MySub (press Ctrl+C to stop)...${RESET_FORMAT}"
python subscriber.py $PROJECT_ID receive MySub

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
