<div align="center">

# 🚀 Full-Stack To-Do & Task Management Ecosystem
### Modern, Secure, Scalable, Dual-Language (TR/EN) and Statistics-Powered Platform

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/.NET_8-%23512BD4.svg?style=for-the-badge&logo=dotnet&logoColor=white" alt=".NET 8" />
  <img src="https://img.shields.io/badge/PostgreSQL-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/DataGrip-%23000000.svg?style=for-the-badge&logo=datagrip&logoColor=white" alt="DataGrip" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
</p>

*A next-generation full-stack application designed to optimize your daily workflow, efficiently manage tasks with built-in Turkish/English support, track productivity statistics, and receive daily motivation every time the app opens.*

</div>

---

## 🌟 Key Features

* **⚡ Fluid & Modern UI:** Developed with Flutter for a smooth, high-performance, and cross-platform user experience.
* **🇹🇷/🇬🇧 Dual-Language Support (TR/EN):** Fully localized interface allowing users to seamlessly switch between Turkish and English.
* **📊 Advanced Statistics Panel:** A dedicated statistics module that visualizes completed, pending, and overall task metrics to track productivity.
* **💡 Dynamic Motivation System:** A delightful UX feature that greets users with inspiring quotes tailored to their chosen language every time the app opens.
* **🎨 UI/UX Design & Modeling:** The frontend interface and workflow were designed using **Google Stitch** to ensure a user-centric and modern experience prior to implementation.
* **🛡️ Powerful Backend:** High-performance and secure RESTful services powered by .NET 8 Web API.
* **🐘 Reliable Data Storage:** Efficient relational data management utilizing PostgreSQL and DataGrip.
* **🔒 Environmental Security:** Sensitive database connection strings and credentials are completely isolated from the source code.

---

## 🛠️ Tech Stack & Architecture

| Layer | Technology / Tool | Purpose |
| :--- | :--- | :--- |
| **Frontend** | Flutter, Dart & Google Stitch | Cross-platform client application, localization, statistics, motivation flow, and visual design |
| **Backend** | .NET 8, C#, Entity Framework Core | RESTful API services, data processing, and business logic |
| **Database & Tool** | PostgreSQL & DataGrip | Relational database management and query optimization |
| **Version Control** | Git & GitHub | Source code management and repository hosting |

---

## 🏗️ Project Architecture & Setup

```text
TodoApp/
├── frontend/  # Flutter client codes (Interface, TR/EN localization files, statistics module, motivation service, state management)
│   └── Run: cd frontend && flutter pub get && flutter run
│
└── backend/   # .NET 8 Web API, layered architecture, and database contexts
    └── Run: cd backend && dotnet ef database update && dotnet run
