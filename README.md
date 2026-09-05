# SQL Data Warehouse Project

## 📌 Project Overview

This project demonstrates the development of a **SQL Data Warehouse** using a structured approach to transform raw data into clean, organized, and analysis-ready information.

The project covers the complete data warehousing workflow, from understanding the source dataset and designing the architecture to data loading, cleaning, transformation, modeling, and validation.

---

## 🏗️ Data Architecture

The project follows a **Medallion Architecture** consisting of three layers:

```text
                         SOURCE DATASET
                               │
                               ▼
                    ┌─────────────────────┐
                    │    BRONZE LAYER     │
                    │                     │
                    │     Raw Data        │
                    │  No / Minimal       │
                    │   Transformation    │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    SILVER LAYER     │
                    │                     │
                    │   Cleaned Data      │
                    │ Standardized Data   │
                    │  Data Validation    │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │     GOLD LAYER      │
                    │                     │
                    │ Business-Ready Data │
                    │ Fact & Dimension    │
                    │      Tables         │
                    └──────────┬──────────┘
                               │
                               ▼
                     ANALYSIS & REPORTING
```

### 🥉 Bronze Layer

The Bronze layer stores the data from the source dataset in its raw form. Minimal transformations are performed at this stage to preserve the original source information.

### 🥈 Silver Layer

The Silver layer contains cleaned and standardized data. Data quality issues such as duplicates, missing values, inconsistent formats, and invalid records are addressed here.

### 🥇 Gold Layer

The Gold layer contains business-ready data designed for analytical queries and reporting. The data is organized using **fact and dimension tables** based on dimensional modeling principles.

---

## 🛠️ Tools & Technologies

| Tool                   | Purpose                                              |
| ---------------------- | ---------------------------------------------------- |
| **SQL Server Express** | Database engine used to build the data warehouse     |
| **SSMS**               | Database development, SQL scripting, and management  |
| **SQL**                | Data loading, cleaning, transformation, and analysis |
| **Draw.io**            | Data architecture and database diagrams              |
| **Git & GitHub**       | Version control and project repository               |
| **Notion**             | Project planning, task management, and documentation |
| **Source Dataset**     | Raw data used for the project                        |

---

## 📋 Project Steps

The project workflow and tasks were planned and tracked using **Notion**.

### 1. Project Planning

* Defined project objectives
* Identified project requirements
* Created project tasks and milestones
* Organized the complete workflow in Notion

### 2. Understanding the Dataset

* Reviewed the source dataset
* Examined tables, columns, and data types
* Identified relationships between data
* Identified potential data quality issues

### 3. Data Architecture

* Designed the overall data warehouse architecture
* Defined Bronze, Silver, and Gold layers
* Created architecture diagrams using Draw.io

### 4. Database & Schema Setup

* Created the SQL Server database
* Created schemas for the different warehouse layers
* Prepared the environment for data ingestion

### 5. Data Ingestion

* Loaded the source dataset into the Bronze layer
* Preserved the original source data structure
* Created SQL scripts for data loading

### 6. Data Cleaning & Transformation

* Handled missing values
* Removed duplicate records where required
* Standardized data formats
* Corrected inconsistent values
* Applied SQL transformations

### 7. Data Modeling

* Designed fact and dimension tables
* Defined primary and foreign keys
* Established relationships between tables
* Applied dimensional modeling principles

### 8. Gold Layer Development

* Created business-ready tables and views
* Structured data for analytical queries
* Prepared the final datasets for reporting

### 9. Data Quality & Validation

* Checked data completeness
* Validated relationships
* Tested transformations
* Performed consistency and quality checks

### 10. Documentation & Version Control

* Documented project steps and progress in Notion
* Created architecture diagrams using Draw.io
* Maintained SQL scripts and project files using Git
* Published the project repository on GitHub

---

## 📊 SQL Concepts Used

* SELECT & Filtering
* JOINs
* GROUP BY & Aggregations
* CASE Statements
* Subqueries
* CTEs
* Window Functions
* Views
* Data Cleaning
* Data Transformation
* Data Validation
* Primary & Foreign Keys

---

## 📁 Repository Structure

```text
SQL-Data-Warehouse/
│
├── datasets/
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── docs/
│   └── data_architecture/
│
├── tests/
│
├── README.md
│
└── .gitignore
```

---

## 🎯 Project Objectives

* Build a structured SQL Data Warehouse.
* Understand Bronze, Silver, and Gold architecture.
* Practice SQL-based ETL processes.
* Clean and transform raw data.
* Apply dimensional modeling concepts.
* Create analysis-ready datasets.
* Practice database documentation and project planning.
* Use Git and GitHub for version control.

---

## 🚀 Project Outcome

The final data warehouse provides a structured and organized foundation for **data analysis and reporting**. This project helped develop practical experience with SQL, data warehousing, ETL processes, dimensional modeling, documentation, and version control.

---

## 👨‍💻 Author

**Ankul Chaudhary**

This project is part of my learning journey in **SQL, Data Warehousing, and Data Analytics**, with a focus on building practical skills through hands-on projects.
