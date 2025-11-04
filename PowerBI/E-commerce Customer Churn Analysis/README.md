**E-commerce Customer Churn Analysis**
This project contains SQL-based data cleaning and a Power BI dashboard created to analyze customer churn patterns in an e-commerce business.
The dataset was cleaned, transformed, and prepared using SQL, and visualized in Power BI.

Files Included: 
E-commerce Customer Churn Dashboard.pbix – Final Power BI dashboard,
SQL Queries.sql – SQL scripts used to clean and transform the dataset,
E-Commerce Customer churn db.sql – Base dataset used after cleaning

Project Summary: 
The dashboard provides key insights into customer churn, including churn rates, customer satisfaction, payment mode behavior, tenure groups, device usage, city tier, and more.
SQL was used to clean and standardize the raw dataset before loading it into Power BI.

Dashboard Features: 
Total customers, churned customers & churn rate,
Churn rate by warehouse distance,
Churn rate by payment mode,
Churn rate by tenure group,
Churn rate by devices registered,
Churn by satisfaction score,
Churned customers by city tier and gender,
Slicers for gender, order category, complaint status, and marital status

 Data Cleaning (SQL Steps):
Imputed mean values for numeric missing data,
Imputed mode values for categorical missing data,
Removed outliers (e.g., WarehouseToHome > 100),
Standardized inconsistent values (login device, order category, payment mode),
Renamed columns for consistency,
Created new columns (ComplaintReceived, ChurnStatus),
Dropped unnecessary columns (Churn, Complain),

Tools Used: 
SQL (MySQL),
Power BI,
Power Query (minor transformations),
Data Modeling & Measures (DAX).
