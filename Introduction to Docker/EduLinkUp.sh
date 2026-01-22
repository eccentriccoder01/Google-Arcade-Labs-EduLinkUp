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


# Fetching the region
read -p "${YELLOW_TEXT}${BOLD_TEXT}Enter REGION:${RESET_FORMAT} " REGION
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 1: Authenticating with gcloud...${RESET_FORMAT}"
gcloud auth list
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 2: Creating 'test' directory...${RESET_FORMAT}"
mkdir test && cd test
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 3: Creating Dockerfile...${RESET_FORMAT}"
cat > Dockerfile <<EOF
FROM node:lts
WORKDIR /app
ADD . /app
EXPOSE 80
CMD ["node", "app.js"]
EOF
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 4: Creating app.js...${RESET_FORMAT}"
cat > app.js <<EOF
const http = require("http");

const hostname = "0.0.0.0";
const port = 80;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader("Content-Type", "text/plain");
  res.end("Welcome to Cloud\n");
});

server.listen(port, hostname, () => {
  console.log("Server running at http://%s:%s/", hostname, port);
});
EOF
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 5: Building Docker image...${RESET_FORMAT}"
docker build -t node-app:0.2 .
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 6: Running Docker container...${RESET_FORMAT}"
docker run -p 8080:80 --name my-app-2 -d node-app:0.2
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 7: Listing running containers...${RESET_FORMAT}"
docker ps
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 8: Creating Artifact Registry...${RESET_FORMAT}"
gcloud artifacts repositories create my-repository \
  --repository-format=docker \
  --location=$REGION \
  --description="Docker repository"
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 9: Configuring Docker auth...${RESET_FORMAT}"
gcloud auth configure-docker $REGION-docker.pkg.dev --quiet
echo

DEVSHELL_PROJECT_ID=$(gcloud config get-value project)

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 10: Building image for Artifact Registry...${RESET_FORMAT}"
docker build -t $REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/my-repository/node-app:0.2 .
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 11: Pushing image to Artifact Registry...${RESET_FORMAT}"
docker push $REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/my-repository/node-app:0.2
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 12: Cleaning Docker containers and images...${RESET_FORMAT}"
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
docker rmi -f $(docker images -aq)
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Step 13: Running image from Artifact Registry...${RESET_FORMAT}"
docker run -p 4000:80 -d $REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/my-repository/node-app:0.2
echo

# Delete script if exists
SCRIPT_NAME="EduLinkUp.sh"
if [ -f "$SCRIPT_NAME" ]; then
  rm -- "$SCRIPT_NAME"
fi

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
