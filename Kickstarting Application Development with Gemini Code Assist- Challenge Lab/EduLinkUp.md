<div align="center">

# Kickstarting Application Development with Gemini Code Assist: Challenge Lab
### Google Cloud Skills Boost - Lab GSP527

[![Open Lab](https://img.shields.io/badge/▶️_Open_Lab-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)]( https://www.skills.google/catalog_lab/32458 )

##  Lab Overview

This lab provides hands-on experience with Google Cloud services. You'll learn key concepts, configure resources, and gain practical skills for working with cloud infrastructure and applications.

```mermaid
graph LR
    A[Start Lab] --> B[Set Up Environment]
    B --> C[Configure Resources]
    C --> D[Complete Tasks]
    D --> E[Test Solution]
    E --> F[Verify Results]
    F --> G[Complete Lab]
    
    style A fill:#4285F4,stroke:#1967D2,color:#fff
    style G fill:#34A853,stroke:#188038,color:#fff
    style C fill:#FBBC04,stroke:#F29900,color:#000
```

---
##  Quick Start Guide

## Task-2 `backend/index.test.ts`:

```bash
// Gemini: Write a test for the /outofstock endpoint to verify it returns a status 200 and a list of 2 items.
```
```bash
cd cymbal-superstore/backend
npm install
npm run test
```
## Task-3 `backend/index.ts`:
```bash
// This endpoint should return all out-of-stock products.
```
```bash
npm run test
```
## Task-4 `functions/index.js`:
```bash
const functions = require('@google-cloud/functions-framework');
const {Firestore} = require('@google-cloud/firestore');

// Create a Firestore client
const firestore = new Firestore();

// Create a Cloud Function that will be triggered by an HTTP request
functions.http('newproducts', async (req, res) => {
Â  // Get the products from Firestore
Â  const products = await firestore.collection('inventory').where('timestamp', '>', new Date(Date.now() - 604800000)).get();

Â  initFirestoreCollection();

Â  // Create an array of products
Â  const productsArray = [];
Â  products.forEach((product) => {
Â    const p = {
Â      id: product.id,
Â      name: product.data().name + ' (' + product.data().quantity + ')',
Â      price: product.data().price,
Â      quantity: product.data().quantity,
Â      imgfile: product.data().imgfile,
Â      timestamp: product.data().timestamp,
Â      actualdateadded: product.data().actualdateadded,
Â    };
Â    productsArray.push(p);
Â  });

Â  // Send the products array to the client
Â  res.set('Access-Control-Allow-Origin', '*');
Â  res.send(productsArray);
});

// Create a Cloud Function for out-of-stock products
functions.http('outofstock', async (req, res) => {
Â  // Query Firestore for products with quantity 0 (out of stock)
Â  const snapshot = await firestore.collection('inventory').where('quantity', '==', 0).get();
Â  const outOfStock = [];
Â  snapshot.forEach(doc => {
Â    outOfStock.push({
Â      id: doc.id,
Â      name: doc.data().name,
Â      price: doc.data().price,
Â      quantity: doc.data().quantity,
Â      imgfile: doc.data().imgfile,
Â      timestamp: doc.data().timestamp,
Â      actualdateadded: doc.data().actualdateadded
Â    });
Â  });
Â  res.set('Access-Control-Allow-Origin', '*');
Â  res.status(200).json(outOfStock);
});

// ------------------- ------------------- ------------------- ------------------- -------------------
// HELPERS -- SEED THE INVENTORY DATABASE (PRODUCTS)
// ------------------- ------------------- ------------------- ------------------- -------------------

// This will overwrite products in the database - this is intentional, to keep the date-added fresh.
function initFirestoreCollection() {
Â  const oldProducts = [
Â    "Apples",
Â    "Bananas",
Â    "Milk",
Â    "Whole Wheat Bread",
Â    "Eggs",
Â    "Cheddar Cheese",
Â    "Whole Chicken",
Â    "Rice",
Â    "Black Beans",
Â    "Bottled Water",
Â    "Apple Juice",
Â    "Cola",
Â    "Coffee Beans",
Â    "Green Tea",
Â    "Watermelon",
Â    "Broccoli",
Â    "Jasmine Rice",
Â    "Yogurt",
Â    "Beef",
Â    "Shrimp",
Â    "Walnuts",
Â    "Sunflower Seeds",
Â    "Fresh Basil",
Â    "Cinnamon",
Â  ];
Â  // Add "old" products to Firestore
Â  for (let i = 0; i < oldProducts.length; i++) {
Â    const oldProduct = {
Â      name: oldProducts[i],
Â      price: Math.floor(Math.random() * 10) + 1,
Â      quantity: Math.floor(Math.random() * 500) + 1,
Â      imgfile: "product-images/" + oldProducts[i].replace(/\s/g, "").toLowerCase() + ".png",
Â      timestamp: new Date(Date.now() - Math.floor(Math.random() * 31536000000) - 7776000000),
Â      actualdateadded: new Date(Date.now()),
Â    };
Â    console.log("Adding (or updating) product in firestore: " + oldProduct.name);
Â    addOrUpdateFirestore(oldProduct);
Â  }
Â  // Add recent products
Â  const recentProducts = [
Â    "Parmesan Crisps",
Â    "Pineapple Kombucha",
Â    "Maple Almond Butter",
Â    "Mint Chocolate Cookies",
Â    "White Chocolate Caramel Corn",
Â    "Acai Smoothie Packs",
Â    "Smores Cereal",
Â    "Peanut Butter and Jelly Cups",
Â  ];
Â  for (let j = 0; j < recentProducts.length; j++) {
Â    const recent = {
Â      name: recentProducts[j],
Â      price: Math.floor(Math.random() * 10) + 1,
Â      quantity: Math.floor(Math.random() * 100) + 1,
Â      imgfile: "product-images/" + recentProducts[j].replace(/\s/g, "").toLowerCase() + ".png",
Â      timestamp: new Date(Date.now() - Math.floor(Math.random() * 518400000) + 1),
Â      actualdateadded: new Date(Date.now()),
Â    };
Â    console.log("Adding (or updating) product in firestore: " + recent.name);
Â    addOrUpdateFirestore(recent);
Â  }
Â  // Add recent products that are out of stock
Â  const recentProductsOutOfStock = ["Wasabi Party Mix", "Jalapeno Seasoning"];
Â  for (let k = 0; k < recentProductsOutOfStock.length; k++) {
Â    const oosProduct = {
Â      name: recentProductsOutOfStock[k],
Â      price: Math.floor(Math.random() * 10) + 1,
Â      quantity: 0,
Â      imgfile: "product-images/" + recentProductsOutOfStock[k].replace(/\s/g, "").toLowerCase() + ".png",
Â      timestamp: new Date(Date.now() - Math.floor(Math.random() * 518400000) + 1),
Â      actualdateadded: new Date(Date.now()),
Â    };
Â    console.log("Adding (or updating) out of stock product in firestore: " + oosProduct.name);
Â    addOrUpdateFirestore(oosProduct);
Â  }
}

// Helper - add Firestore doc if not exists, otherwise update
function addOrUpdateFirestore(product) {
Â  firestore
Â    .collection("inventory")
Â    .where("name", "==", product.name)
Â    .get()
Â    .then((querySnapshot) => {
Â      if (querySnapshot.empty) {
Â        firestore.collection("inventory").add(product);
Â      } else {
Â        querySnapshot.forEach((doc) => {
Â          firestore.collection("inventory").doc(doc.id).update(product);
Â        });
Â      }
Â    });
}
//Subscribe to https://www.youtube.com/@EduLinkUp/videos 
```
```bash
cd cymbal-superstore/functions
```
**âš ï¸Change `REGION` of below As per your lab Instruction**
```bash
gcloud functions deploy outofstock --runtime=nodejs20 --trigger-http --entry-point=outofstock --region=us-central1 --allow-unauthenticated
```
## Task-5 Create an `API Gateway` to expose the `outofstock Cloud Function`
Step 1: Set Environment Variables
```bash
export CONFIG_ID=outofstock-api-config
export API_ID=outofstock-api
export GATEWAY_ID=store
export OPENAPI_SPEC=outofstock.yaml
```
Step 2: Create the gateway Directory and OpenAPI Spec
```bash
mkdir gateway
cd gateway
touch outofstock.yaml
```
Step 3: Generate OpenAPI Specification
```bash
swagger: '2.0'
info:
  title: OutOfStock API
  version: 1.0.0
host: us-central1-yourproject.cloudfunctions.net
schemes:
  - https
paths:
  /outofstock:
    get:
      summary: Get out of stock products
      operationId: outofstock
      x-google-backend:
        address: https://us-central1-yourproject.cloudfunctions.net/outofstock
      responses:
        '200':
          description: Successful response
          schema:
            type: array
            items:
              type: object
security: []  # This allows unauthenticated access; or replace with proper API key security
```
**âš ï¸Replace `REGION-PROJECT_ID` with your actual project ID**
Step 4: Enable API Gateway Service
```bash
gcloud services enable apigateway.googleapis.com
```
Step 5: Create API and API Configuration
```bash
gcloud api-gateway apis create $API_ID --display-name="Out of Stock API"
gcloud api-gateway api-configs create $CONFIG_ID --api=$API_ID --openapi-spec=outofstock.yaml --display-name="Out of Stock API Config"
```
Step 6: Create API Gateway & Verify and Test
```bash
gcloud api-gateway gateways create $GATEWAY_ID --api=$API_ID --api-config=$CONFIG_ID --location=us-central1
gcloud api-gateway gateways describe $GATEWAY_ID --location=us-central1
```
**âš ï¸Change `LOCATION` of above As per your lab Instruction**

---

<div align="center">

## **Google Cloud Arcade Hub**

</div>

<p>
Discover the Google Cloud Arcade Hub - <b>Track progress with EduLinkUp's exclusive Arcade points calculator</b>, Skill Badges, Arcade Games and Arcade Trivia, explore lab-free courses, and join the Facilitator program for milestones, recognition, and swags.
</p>

<div align="center">

[![Arcade Hub](https://img.shields.io/badge/ðŸŽ®_Arcade_Hub-FF6F61?style=for-the-badge&logo=gamepad&logoColor=white)](https://edulinkup.dev/arcade-calculator)

</div>

<ul>
<li><strong>Arcade Points Calculator</strong>: Estimate points, plan goals, and see leaderboard impact.</li>
<li><strong>Badges & Games</strong>: Earn badges for achievements and play bite-sized learning games.</li>
<li><strong>Lab-Free Courses</strong>: Access curated, free learning paths and practice labs to achieve milestones in the Facilitaor Program.</li>
<li><strong>Facilitator Program</strong>: Guides, milestone tracking, community roles, and swags.</li>
</ul>

## ðŸ” Important Notice

<div align="center">

```mermaid
graph LR
    Start([Use This Resource?]) --> Question{What's Your Goal?}
    Question -->|Learn & Understand| Manual[ðŸ“š Study the Code]
    Question -->|Quick Review| Auto[âš¡ Use Automation]
    Question -->|Certification Prep| Both[ðŸŽ¯ Do Both]
    
    Manual --> Read[Read Script Line by Line]
    Read --> Understand[Understand Each Command]
    Understand --> Practice[Practice Manually First]
    
    Auto --> Review[Review Before Running]
    Review --> Execute[Execute Script]
    Execute --> Reflect[Reflect on Output]
    
    Both --> Manual
    Both --> Auto
    
    Practice --> Success([âœ… Deep Learning Achieved])
    Reflect --> Success
    
    style Start fill:#E3F2FD,stroke:#1976D2,color:#000
    style Success fill:#C8E6C9,stroke:#388E3C,color:#000
    style Manual fill:#FFF3E0,stroke:#F57C00,color:#000
    style Auto fill:#F3E5F5,stroke:#7B1FA2,color:#000
    style Both fill:#E0F2F1,stroke:#00796B,color:#000
```

</div>

<details>
<summary><b> âš ï¸ Disclaimer âš ï¸- ðŸ“– Educational Use Policy (Expand)</b></summary>

<br>

**Purpose**  
This repository provides learning resources to help you understand Google Cloud Platform services. The automation scripts are designed to demonstrate best practices and accelerate your learning journey.

<table>
<tr>
<td width="50%" valign="top">

### Google Cloud Skills Boost - Lab GSP527

- Study and understand the underlying Google Cloud operations
- Learn automation techniques for cloud infrastructure
- Prepare for certification or professional development
- Review concepts after manual completion

</td>
<td width="50%" valign="top">

### Google Cloud Skills Boost - Lab GSP527

- Comply with Google Cloud Skills Boost terms of service
- Use scripts for educational purposes only
- Complete manual labs first before using automation
- Give proper attribution if sharing or modifying

</td>
</tr>
</table>

**Ethical Considerations**  
We believe in learning through understanding. While our scripts save time, we strongly encourage you to:

<div align="center">

| Step | Action | Why It Matters |
|------|--------|----------------|
| 1ï¸âƒ£ | Read through the script code | Understand what will happen |
| 2ï¸âƒ£ | Complete labs manually first | Build foundational knowledge |
| 3ï¸âƒ£ | Understand each command | Learn the "why" not just "how" |
| 4ï¸âƒ£ | Use automation as a tool | Reinforce learning, don't replace it |

</div>

</details>

---

## ðŸ› ï¸ Troubleshooting

<div align="center">

```mermaid
graph LR
    Issue[âŒ Encountered Issue?] --> Type{Issue Type}
    
    Type -->|Permission| P1[Check IAM Roles]
    Type -->|API| A1[Verify API Enabled]
    Type -->|Authentication| Auth1[Re-authenticate]
    Type -->|Script| S1[Check Script Syntax]
    
    P1 --> P2[Add Required Permissions]
    A1 --> A2[Enable in Console]
    Auth1 --> Auth2[gcloud auth login]
    S1 --> S2[Review Error Output]
    
    P2 --> Retry[ðŸ”„ Retry Operation]
    A2 --> Retry
    Auth2 --> Retry
    S2 --> Retry
    
    Retry --> Success{Fixed?}
    Success -->|Yes| Done([âœ… Resolved])
    Success -->|No| Help[ðŸ“ž Seek Help]
    
    style Issue fill:#FFCDD2,stroke:#C62828,color:#000
    style Done fill:#C8E6C9,stroke:#388E3C,color:#000
    style Retry fill:#FFF9C4,stroke:#F9A825,color:#000
    style Help fill:#E1BEE7,stroke:#8E24AA,color:#000
```

</div>

<br>

Having issues? Here are quick solutions:

| Issue | Solution |
|-------|----------|
| Script won't run | Check execute permissions with `ls -la` |
| Authentication errors | Verify you're logged into the correct project |
| API not enabled | Enable required APIs in console |
| Timeout errors | Check your internet connection and retry |
| Permission denied | Ensure your account has proper IAM roles |

---

## **Join Our Growing Ecosystem**

[![Website](https://img.shields.io/badge/ðŸŒ_Website-edulinkup.dev-6C63FF?style=for-the-badge&logoColor=white)](https://edulinkup.dev) [![LinkedIn](https://img.shields.io/badge/LinkedIn_Page-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/company/edulinkup) [![YouTube](https://img.shields.io/badge/YouTube_Channel-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@EduLinkUp)

---

### Google Cloud Skills Boost - Lab GSP527

<div align="center">
<a href="https://www.linkedin.com/in/eccentricexplorer" target="_blank" rel="noopener noreferrer">
    <img src="/public/Sagnik.jpg" alt="Sagnik" width="96" style="border-radius:50%;margin-right:12px;"/>
</a> &nbsp;
<a href="https://www.linkedin.com/in/akshaykumar0611" target="_blank" rel="noopener noreferrer">
    <img src="/public/Akshay.jpg" alt="Akshay Kumar" width="96" style="border-radius:50%;margin-left:12px;"/>
</a>

<br/>

<p>
  <a href="https://www.linkedin.com/in/eccentricexplorer">
    <img src="https://img.shields.io/badge/Sagnik_-_LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="Sagnik - LinkedIn" width="96" />
  </a> &nbsp;
  <a href="https://www.linkedin.com/in/akshaykumar0611">
    <img src="https://img.shields.io/badge/Akshay_-_LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="Akshay - LinkedIn" width="96" />
  </a>
</p>

</div>

---

### Google Cloud Skills Boost - Lab GSP527

**Stay updated with everything happening in the EduLinkUp universe:**

[![WhatsApp Community](https://img.shields.io/badge/WhatsApp_Community-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](https://chat.whatsapp.com/HN5eOl0p5DBKBqTbIiOTgv)

</div>

---

<div align="center">

*This guide was crafted with care to enhance your Google Cloud learning experience.*  
*Remember: Understanding beats completion. Take your time and enjoy the journey.*

<sub>Last updated: January 2026 | Version 1.0</sub>

</div>


















