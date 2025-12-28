📌 Project Overview
This project focuses on analyzing real-world manufacturing service and complaint data. The dataset contains free-text fields like Complaint, Cause, and Correction, along with structured columns related to components, failures, and fixes. The goal is to clean the data, generate meaningful tags, and extract insights that can help improve product quality and reduce repeat failures.

🛠 Tools & Technologies
Python (Pandas, NumPy)
Matplotlib
Excel 
Jupyter Notebook

📊 What I Did in This Project
Performed column-wise analysis to understand data types, missing values, and distributions
Cleaned the dataset by handling null values and standardizing categorical fields
Generated failure-related tags from free-text columns using logical rules
Identified key columns important for quality and engineering teams
Created visualizations to highlight common failures, components, and fixes
Documented assumptions and handled ambiguous cases carefully

🏷 Tags / Features Generated
Failure Type (Leak, Error Code, Not Working, etc.)
Affected Component
Root Cause Category
Fix Action Type
Sensor-related / Hydraulic-related flags

📈 Key Insights
Many issues are related to factory-level problems like parts not tightened or not installed
Hydraulic leaks and O-ring failures appear frequently
Sensor and error-code issues are common across multiple records
Several cases involve diagnosis without final repair, indicating scope for better first-time fixes

📁 Files in This Repository
cleaned_data.csv – cleaned and tagged dataset

analysis.ipynb – Python notebook with EDA, cleaning, and visualizations

report.pdf – summary report with insights and observations
