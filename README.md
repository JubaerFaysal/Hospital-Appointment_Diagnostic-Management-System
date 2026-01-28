# 🏥 Hospital Appointment & Diagnostic Management System

A scalable, role-based digital healthcare management system designed to streamline **hospital appointments**, **diagnostic services**, and **user administration** through dedicated mobile applications and a centralized web-based admin panel.

This project demonstrates a **production-oriented full-stack architecture**, integrating cross-platform mobile development with a secure RESTful backend.

---

## 📌 Overview

The **Hospital Appointment & Diagnostic Management System** is a multi-platform healthcare solution that enables efficient interaction between patients, doctors, and hospital administrators. The system ensures structured appointment workflows, controlled access through role-based permissions, and centralized operational oversight.

The platform consists of:
- Two **Flutter mobile applications** (Patient & Doctor)
- One **Flutter Web admin panel**
- A **NestJS REST API backend**
- A **MySQL relational database**

---

## 🧩 System Components

### 👨‍⚕️ Patient Mobile Application
- Appointment booking with available doctors
- Diagnostic test scheduling
- Appointment history and status tracking
- Profile and personal information management

### 👩‍⚕️ Doctor Mobile Application
- View daily, upcoming, and historical appointments
- Access patient details (read-only)
- Track appointment lifecycle
- Manage personal profile and availability

### 🖥️ Admin Web Panel
- User and role management (Patients, Doctors, Admins)
- Appointment approval and status control
- Diagnostic service and booking management
- Operational monitoring through dashboards
- Role-based access control (RBAC)

---

## ✨ Core Features

### Patient Features
- Doctor appointment booking
- Diagnostic test scheduling
- Appointment history tracking
- Secure profile management

### Doctor Features
- Categorized appointment views
- Read-only patient medical data access
- Appointment status visibility
- Profile and availability management

### Administrative Features
- Full CRUD operations for system entities
- Appointment confirmation, rejection, and completion
- Diagnostic service oversight
- Role-based permission enforcement
- System activity monitoring

---

## 🛠️ Technology Stack

### Frontend (Cross-Platform)
- **Framework:** Flutter (Dart)
- **State Management:** GetX
- **Networking:** Dio
- **Local Storage:** GetStorage
- **Architecture:** MVC (Model–View–Controller)

### Backend
- **Framework:** NestJS (Node.js)
- **API Design:** RESTful APIs
- **Authentication:** JWT (JSON Web Tokens)
- **Architecture:** Domain-Driven Design (DDD)

### Database
- **Database Engine:** MySQL
- **ORM:** TypeORM

### Tooling & Utilities
- **IDE:** VS Code, Android Studio
- **Version Control:** Git & GitHub
- **API Testing:** Postman
- **UI/UX Design:** Figma

---

## 📁 Project Structure

```text
hospital-management-system/
│
├── patient_app/                 # Flutter Patient App
│   ├── lib/
│   │   ├── controllers/         # GetX Controllers
│   │   ├── models/              # Data Models
│   │   ├── views/               # UI Screens
│   │   ├── services/            # API Integration
│   │   └── utils/               # Shared Utilities
│   └── pubspec.yaml
│
├── doctor_app/                  # Flutter Doctor App
│   └── (similar structure)
│
├── admin_panel/                 # Flutter Web Admin Panel
│   └── (similar structure)
│
├── backend/                     # NestJS Backend
│   ├── src/
│   │   ├── modules/             # Feature-Based Modules
│   │   ├── entities/            # Database Entities
│   │   ├── controllers/         # REST Controllers
│   │   ├── services/            # Business Logic
│   │   └── middleware/          # Auth & Validation
│   └── package.json
│
└── database/                    # MySQL Database
    ├── schema.sql
    └── sample_data.sql
```
## 📸 Screenshots

### Patient Mobile App
![Patient App Home](screenshots/patient_home.png)
![Book Appointment](screenshots/patient_booking.png)

### Doctor Mobile App
![Doctor Schedule](screenshots/doctor_schedule.png)

### Admin Web Panel
![Admin Dashboard](screenshots/admin_dashboard.png)


## 🚀 Installation & Setup

### Prerequisites

Ensure the following tools are installed before proceeding:

- **Flutter SDK:** version 3.0.0 or higher  
- **Node.js:** version 16.x or higher  
- **MySQL:** version 8.0 or higher  
- **Git:** latest stable version  

These prerequisites are required to run the mobile applications, backend services, and database locally.

---

## 📊 Database Design

### Core Tables

The system uses a relational database schema designed to ensure data consistency, integrity, and scalability.

- `patients` – Patient profiles and authentication data  
- `doctors` – Doctor information, specialties, and availability  
- `appointments` – Appointment records with lifecycle status  
- `diagnostics` – Diagnostic test services  
- `diagnostic_bookings` – Diagnostic test booking records  
- `admins` – Administrative users with assigned roles  

Relational integrity is enforced using **foreign key constraints**, ensuring reliable associations between users, appointments, and diagnostic records.

---

## 🔑 Role-Based Access Control (RBAC)

| Action               | Patient | Doctor | Admin |
|----------------------|---------|--------|-------|
| Book Appointment     | ✅      | ❌     | ❌    |
| View Appointments    | ✅      | ✅     | ✅    |
| Confirm / Reject     | ❌      | ❌     | ✅    |
| Manage Doctors       | ❌      | ❌     | ✅    |
| Cancel Appointment   | ✅      | ❌     | ✅    |

Role-based permissions ensure secure access control and prevent unauthorized operations across the system.

---

## 📈 Future Enhancements

Planned improvements to enhance scalability and feature richness include:

- Telemedicine integration (video consultations)  
- Online payment gateway integration  
- Push notifications (Email and SMS reminders)  
- Laboratory system integration for automated test results  
- Multi-hospital and branch-level support  
- Advanced analytics and reporting dashboard  
- Dedicated mobile application for administrators  

---

## 👤 Author

**Jubaer Ahmed Faysal**  
Full-Stack Developer & Project Lead

