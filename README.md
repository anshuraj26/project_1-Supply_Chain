📦 DC Supply Chain Analytics & Business Optimization Project
📌 Project Overview

This project presents an end-to-end business analysis and data analytics solution focused on supply chain optimization, profitability improvement, and risk mitigation.
It combines data engineering (Python) with advanced SQL analytics to transform raw operational data into actionable business insights.

The project simulates a real-world business analyst / data analyst workflow, from problem definition to strategic recommendations.

🎯 Business Problem Statement

The organization faces misalignment between logistics efficiency and net profitability, impacting sustainable growth.
This analysis addresses three core business objectives:

Logistics Reliability – Identify shipping delays by comparing scheduled vs. actual delivery timelines.

Profitability Assurance – Detect categories and markets where high sales volume fails to generate profit.

Risk Mitigation – Uncover suspected fraud patterns and operational risks during peak demand periods. 

🏗️ Project Architecture

The solution is structured into two analytical phases:

Phase I: Data Engineering (Python)

Raw CSV ingestion using Pandas

Data cleaning, normalization, and feature engineering

Removal of PII for privacy and performance

Creation of derived logistics metrics (e.g., delivery delay variance)

Migration to PostgreSQL using SQLAlchemy

Phase II: Data Analysis (SQL)

Advanced SQL queries for:

Logistics performance

Financial health assessment

Customer segmentation & lifetime value

Fraud risk analysis

Time-series growth and seasonality trends 

DC Supply Chain - Report

🔍 Key Analytical Insights
🚚 Logistics & Operations

Certain European cities exhibit high delivery unpredictability

First Class shipping shows extremely poor on-time performance

Same Day shipping is the most reliable, but still inconsistent

💰 Financial Performance

US & Canada market leads in profit margin

Fan Shop is the highest revenue department

Some categories act as loss leaders, generating sales but minimal profit

👥 Customer & Risk Analysis

Revenue is dominated by the Consumer segment

Top 1% customers contribute disproportionately to total sales

Specific cities show elevated suspected fraud rates

📈 Time-Series Trends

Significant sales and profit decline observed in late 2017–early 2018

October emerges as the strongest sales month, indicating seasonality

🛠️ Tools & Technologies

Python (Pandas, SQLAlchemy)

PostgreSQL

SQL (Advanced analytics & window functions)

Jupyter Notebook

GitHub for version control

📂 Repository Structure
├── DCSC.ipynb                # Data cleaning & ETL pipeline
├── DC Supply Chain.sql       # Advanced SQL analytical queries
├── DCSupplyChainDataset.csv # Raw dataset
├── Report.pdf               # Technical & analytical findings
└── README.md                # Project documentation

📊 Use Case Relevance

This project is suitable for demonstrating skills in:

Business Analysis

Data Analytics

Supply Chain Analytics

SQL & Python for Analytics

Real-world decision-driven insights

📌 Conclusion

The project showcases a production-ready analytical framework that converts raw supply chain data into meaningful business insights.
It highlights operational bottlenecks, financial inefficiencies, and risk areas, enabling data-driven strategic decision-making.
