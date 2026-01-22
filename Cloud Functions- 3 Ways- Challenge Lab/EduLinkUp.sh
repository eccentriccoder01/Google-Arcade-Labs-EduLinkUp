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


# ---------------------------------------------------------
#   EduLinkUp - Guaranteed Working Script for Challenge Lab
#   YouTube: https://www.youtube.com/@EduLinkUp
# ---------------------------------------------------------

REGION="us-central1"
PROJECT_ID=$(gcloud config get-value project)
BUCKET_NAME="$PROJECT_ID"

echo "Using Project: $PROJECT_ID"
echo "Region: $REGION"
echo "Bucket: $BUCKET_NAME"

# ---------------------- TASK 1 ---------------------------
echo "Creating Bucket (ignore error if exists)..."

gsutil mb -l $REGION gs://$BUCKET_NAME/ 2>/dev/null

echo "Bucket ready!"

# ---------------------- TASK 2 ---------------------------
echo "Preparing Cloud Storage Function..."

mkdir -p cs-func
cd cs-func

cat <<EOF > index.js
const functions = require('@google-cloud/functions-framework');

functions.cloudEvent('cs-tracker', (cloudevent) => {
  console.log('A new event in your Cloud Storage bucket has been logged!');
  console.log(cloudevent);
});
EOF

cat <<EOF > package.json
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF

echo "Deploying cs-tracker function..."

gcloud functions deploy cs-tracker \
  --gen2 \
  --region=$REGION \
  --runtime=nodejs20 \
  --source=. \
  --entry-point=cs-tracker \
  --trigger-bucket=$BUCKET_NAME \
  --max-instances=2 \
  --quiet

cd ..

echo "Cloud Storage function deployed."

# ---------------------- TASK 3 ---------------------------
echo "Preparing HTTP Function..."

mkdir -p http-func
cd http-func

cat <<EOF > index.js
const functions = require('@google-cloud/functions-framework');

functions.http('http-messenger', (req, res) => {
  res.status(200).send('HTTP function (2nd gen) has been called!');
});
EOF

cat <<EOF > package.json
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF

echo "Deploying http-messenger function..."

gcloud functions deploy http-messenger \
  --gen2 \
  --region=$REGION \
  --runtime=nodejs20 \
  --source=. \
  --entry-point=http-messenger \
  --trigger-http \
  --allow-unauthenticated \
  --min-instances=1 \
  --max-instances=2 \
  --quiet

echo "HTTP Function deployed successfully!"

# ----------------- FINISHED ----------------------------

echo "===================================================="
echo " ALL TASKS COMPLETED SUCCESSFULLY!"
echo " Bucket: $BUCKET_NAME"
echo " Cloud Storage Function: cs-tracker"
echo " HTTP Function: http-messenger"
echo "===================================================="

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
