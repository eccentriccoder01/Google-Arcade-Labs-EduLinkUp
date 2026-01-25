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


# Initial Setup
echo -e "${YELLOW}🔍 Checking Authentication${NC}"
gcloud auth list
echo

echo -e "${YELLOW}🌍 Configuring Cluster Settings${NC}"
export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
export MY_ZONE=$ZONE
echo -e "${GREEN}✅ Zone: ${WHITE}$MY_ZONE${NC}"
echo -e "${GREEN}✅ Region: ${WHITE}$REGION${NC}"
echo

# Cluster Creation
echo -e "${YELLOW}🚀 Creating GKE Cluster${NC}"
gcloud container clusters create simplecluster \
  --zone $MY_ZONE \
  --num-nodes 2 \
  --metadata=disable-legacy-endpoints=false
echo -e "${GREEN}✅ Cluster created successfully${NC}"

echo -e "${YELLOW}🔧 Verifying Kubernetes Version${NC}"
kubectl version --short
sleep 20

# Initial Pod Deployment
echo -e "\n${YELLOW}📦 Deploying Initial Pod (Less Secure)${NC}"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-insecure
spec:
  containers:
  - name: hostpath
    image: google/cloud-sdk:latest
    command: ["/bin/bash"]
    args: ["-c", "tail -f /dev/null"]
    volumeMounts:
    - mountPath: /rootfs
      name: rootfs
  volumes:
  - name: rootfs
    hostPath:
      path: /
EOF

echo -e "${YELLOW}🔄 Checking Pod Status${NC}"
kubectl get pod hostpath-insecure
sleep 20

# Secure Node Pool Creation
echo -e "\n${YELLOW}🛡️ Creating Secure Node Pool${NC}"
gcloud beta container node-pools create second-pool \
  --cluster=simplecluster \
  --zone=$MY_ZONE \
  --num-nodes=1 \
  --metadata=disable-legacy-endpoints=true \
  --workload-metadata-from-node=SECURE
echo -e "${GREEN}✅ Secure node pool created${NC}"
sleep 20

# Security Configuration
echo -e "\n${YELLOW}🔐 Configuring Cluster Security${NC}"
kubectl create clusterrolebinding clusteradmin \
  --clusterrole=cluster-admin \
  --user="$(gcloud config list account --format 'value(core.account)')"

kubectl label namespace default pod-security.kubernetes.io/enforce=restricted

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pod-security-manager
rules:
- apiGroups: ['policy']
  resources: ['podsecuritypolicies']
  resourceNames: ['privileged', 'baseline', 'restricted']
  verbs: ['use']
- apiGroups: ['']
  resources: ['namespaces']
  verbs: ['get', 'list', 'watch', 'label']
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-security-modifier
  namespace: default
subjects:
- kind: Group
  apiGroup: rbac.authorization.k8s.io
  name: system:authenticated
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: pod-security-manager
EOF
echo -e "${GREEN}✅ Security policies applied${NC}"
sleep 20

# Service Account Setup
echo -e "\n${YELLOW}👤 Configuring Service Account${NC}"
gcloud iam service-accounts create demo-developer
MYPROJECT=$(gcloud config list --format 'value(core.project)')

gcloud projects add-iam-policy-binding "${MYPROJECT}" \
  --role=roles/container.developer \
  --member="serviceAccount:demo-developer@${MYPROJECT}.iam.gserviceaccount.com"

gcloud iam service-accounts keys create key.json \
  --iam-account "demo-developer@${MYPROJECT}.iam.gserviceaccount.com"
sleep 15

echo -e "${YELLOW}🔑 Activating Service Account${NC}"
gcloud auth activate-service-account --key-file=key.json
gcloud container clusters get-credentials simplecluster --zone $MY_ZONE

# Secure Pod Deployment Attempt
echo -e "\n${YELLOW}🔄 Testing Security Policies${NC}"
echo -e "${YELLOW}❌ Attempting to deploy less secure pod...${NC}"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-test
spec:
  containers:
  - name: hostpath
    image: google/cloud-sdk:latest
    command: ["/bin/bash"]
    args: ["-c", "tail -f /dev/null"]
    volumeMounts:
    - mountPath: /rootfs
      name: rootfs
  volumes:
  - name: rootfs
    hostPath:
      path: /
EOF

echo -e "${YELLOW}🧹 Cleaning up test pod...${NC}"
kubectl delete pod hostpath-test --force --grace-period=0

# Final Secure Deployment
echo -e "\n${YELLOW}🛡️ Deploying Secure Pod Configuration${NC}"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-secure
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 2000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: hostpath
    image: google/cloud-sdk:latest
    command: ["/bin/bash"]
    args: ["-c", "tail -f /dev/null"]
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
EOF

echo -e "${YELLOW}🔍 Verifying Security Configuration${NC}"
kubectl get pod hostpath-secure -o=jsonpath='{.spec.securityContext}'
kubectl get ns -o=jsonpath='{.items[*].metadata.annotations}'

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
