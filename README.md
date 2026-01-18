<!-- Hero: Google Cloud styled badges -->
<div align="center">

# Google Cloud Arcade Lab Solutions by EduLinkUp

![Google Cloud](https://img.shields.io/badge/Google%20Cloud-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white) ![Arcade](https://img.shields.io/badge/Arcade-6C63FF?style=for-the-badge&logo=github&logoColor=white) ![Learning](https://img.shields.io/badge/Labs-Learn%20By%20Doing-green?style=for-the-badge&logo=google)&nbsp;

</div>

Welcome to the Arcade Google Cloud Labs - a curated, hands-on collection of challenge labs, quick-starts, and worked solutions for learning Google Cloud services through real exercises.

---

## Visual Roadmap

```mermaid
flowchart LR
    A[Pick a Lab] --> B[Read `EduLinkUp.md`]
    B --> C{Run Script?}
    C -->|Yes| D[Review Script + Run]
    C -->|No| E[Run Commands Manually]
    D --> F[Learn & Tweak]
    E --> F
    F --> G[Share Feedback]
    style A fill:#4285F4,stroke:#1967D2,color:#fff
    style G fill:#34A853,stroke:#188038,color:#fff
```

---

## How to use this repo

1. Open a lab folder under the repo root.
2. Read the `EduLinkUp.md` for context, Quick Start commands, and troubleshooting.
3. Inspect any script files before execution. Example (Cloud Shell):

---

## Safety & best practices

- Review any script before running. These are educational scripts and may modify cloud resources.
- Use a dedicated test project and monitor quotas and billing.
- Revoke unnecessary service account permissions after experiments.

---
## 🔐 Important Notice

<div align="center">

```mermaid
graph LR
    Start([Use This Resource?]) --> Question{What's Your Goal?}
    Question -->|Learn & Understand| Manual[📚 Study the Code]
    Question -->|Quick Review| Auto[⚡ Use Automation]
    Question -->|Certification Prep| Both[🎯 Do Both]
    
    Manual --> Read[Read Script Line by Line]
    Read --> Understand[Understand Each Command]
    Understand --> Practice[Practice Manually First]
    
    Auto --> Review[Review Before Running]
    Review --> Execute[Execute Script]
    Execute --> Reflect[Reflect on Output]
    
    Both --> Manual
    Both --> Auto
    
    Practice --> Success([✅ Deep Learning Achieved])
    Reflect --> Success
    
    style Start fill:#E3F2FD,stroke:#1976D2,color:#000
    style Success fill:#C8E6C9,stroke:#388E3C,color:#000
    style Manual fill:#FFF3E0,stroke:#F57C00,color:#000
    style Auto fill:#F3E5F5,stroke:#7B1FA2,color:#000
    style Both fill:#E0F2F1,stroke:#00796B,color:#000
```

</div>

<details>
<summary><b> ⚠️ Disclaimer ⚠️- 📖 Educational Use Policy (Expand)</b></summary>

<br>

**Purpose**  
This repository provides learning resources to help you understand Google Cloud Platform services. The automation scripts are designed to demonstrate best practices and accelerate your learning journey.

<table>
<tr>
<td width="50%" valign="top">

### ✅ Intended Use

- Study and understand the underlying Google Cloud operations
- Learn automation techniques for cloud infrastructure
- Prepare for certification or professional development
- Review concepts after manual completion

</td>
<td width="50%" valign="top">

### 📜 Terms of Service

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
| 1️⃣ | Read through the script code | Understand what will happen |
| 2️⃣ | Complete labs manually first | Build foundational knowledge |
| 3️⃣ | Understand each command | Learn the "why" not just "how" |
| 4️⃣ | Use automation as a tool | Reinforce learning, don't replace it |

</div>

</details>

---

## 🛠️ Troubleshooting

<div align="center">

```mermaid
graph LR
    Issue[❌ Encountered Issue?] --> Type{Issue Type}
    
    Type -->|Permission| P1[Check IAM Roles]
    Type -->|API| A1[Verify API Enabled]
    Type -->|Authentication| Auth1[Re-authenticate]
    Type -->|Script| S1[Check Script Syntax]
    
    P1 --> P2[Add Required Permissions]
    A1 --> A2[Enable in Console]
    Auth1 --> Auth2[gcloud auth login]
    S1 --> S2[Review Error Output]
    
    P2 --> Retry[🔄 Retry Operation]
    A2 --> Retry
    Auth2 --> Retry
    S2 --> Retry
    
    Retry --> Success{Fixed?}
    Success -->|Yes| Done([✅ Resolved])
    Success -->|No| Help[📞 Seek Help]
    
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

<div align="center">

[![Website](https://img.shields.io/badge/🌍_Website-edulinkup.dev-6C63FF?style=for-the-badge&logoColor=white)](https://edulinkup.dev) [![LinkedIn](https://img.shields.io/badge/LinkedIn_Page-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/company/edulinkup) [![YouTube](https://img.shields.io/badge/YouTube_Channel-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@EduLinkUp)

---

### 🌱 **Join the Developer Community**

**Stay updated with everything happening in the EduLinkUp universe:**

[![WhatsApp Community](https://img.shields.io/badge/WhatsApp_Community-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](https://chat.whatsapp.com/HN5eOl0p5DBKBqTbIiOTgv)

---

### 📩 **Let's Connect Personally**

<div align="center">
<a href="https://www.linkedin.com/in/eccentricexplorer" target="_blank" rel="noopener noreferrer">
    <img src="/public/Sagnik.jpg" alt="Sagnik" width="96" style="border-radius:50%;margin-right:12px;"/>
</a>
<a href="https://www.linkedin.com/in/akshaykumar0611" target="_blank" rel="noopener noreferrer">
    <img src="/public/Akshay.jpg" alt="Akshay Kumar" width="96" style="border-radius:50%;margin-left:12px;"/>
</a>

<br/>

[![Sagnik - LinkedIn](https://img.shields.io/badge/Sagnik_-_LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/eccentricexplorer) [![Akshay - LinkedIn](https://img.shields.io/badge/Akshay_-_LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/akshaykumar0611)

</div>

</div>

---

<div align="center">

*This guide was crafted with care to enhance your Google Cloud learning experience.*  
*Remember: Understanding beats completion. Take your time and enjoy the journey.*

<sub>Last updated: January 2026 | Version 1.0</sub>

</div>

---

## Issue Creation ✴
Report bugs and  issues or propose improvements through our GitHub repository.

## Contribution Guidelines 📑

<div align="center">
  <img src="https://user-images.githubusercontent.com/74038190/212284145-bf2c01a8-c448-4f1a-b911-996024c84606.gif" alt="Animated contribution guidelines divider" width="400">
</div>

- Firstly Star(⭐) the Repository
- Fork the Repository and create a new branch for any updates/changes/issue you are working on.
- Start Coding and do changes.
- Commit your changes
- Create a Pull Request which will be reviewed and suggestions would be added to improve it.
- Add Screenshots and updated website links to help us understand what changes is all about.

- Check the [CONTRIBUTING.md](CONTRIBUTING.md) for detailed steps...
    
## Contributing is fun🧡

We welcome all contributions and suggestions!
Whether it's a new feature, design improvement, or a bug fix — your voice matters 💜

Your insights are invaluable to us. Reach out to us team for any inquiries, feedback, or concerns.

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

Feel free to reach out with any questions or feedback\! Thanks for reading, here's a cookiepookie:

![Cat](https://github.com/XevenTech/xeventech/blob/main/cat.gif?raw=true "Thank You")











