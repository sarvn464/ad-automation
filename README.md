# ad-automation


# 🚀 Active Directory Automation (Excel → GitHub → Jenkins → Windows AD)

This project automates **Active Directory user creation** using an Excel file stored in **GitHub**, processed by **Linux Jenkins**, and executed on a **Windows AD Server**.

Whenever you add a new user entry in `users.xlsx` and push it to GitHub:

➡ Jenkins automatically pulls the repo  
➡ Runs PowerShell on the AD server  
➡ Creates the user in Windows Active Directory  
➡ Places the user in the correct OU  

---

## 📌 Workflow Overview

