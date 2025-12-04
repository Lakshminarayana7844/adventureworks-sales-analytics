# AdventureWorks – Sales Analytics (Power BI)

This project analyzes AdventureWorks sales data using SQL and Power BI.  
The main goal is to understand revenue, orders, customers and regional trends.

## Dataset

- Source: AdventureWorks sample data (multiple CSV tables)
- Tables used:
  - fact_sales – all sales transactions (2020–2022)
  - dim_product – product details and prices
  - dim_customer – customer demographics and income
  - dim_territory – regions and countries
  - fact_returns – product returns

## Tools

- MySQL / SQL Workbench – data loading, cleaning, modeling
- Power BI – data model, measures and dashboard
- DAX – calculations for revenue and KPIs

## Data Model

- fact_sales linked to:
  - dim_product on ProductKey
  - dim_customer on CustomerKey
  - dim_territory on TerritoryKey
  - fact_returns on ProductKey + TerritoryKey
- Created extra columns:
  - Year, Month, Month Number (for time analysis)
  - Age, Age Group, Income Group (for customers)

## Key Measures (DAX examples)

- Total Revenue = SUMX(fact_sales, fact_sales[OrderQuantity] * RELATED(dim_product[ProductPrice]))
- Total Orders = DISTINCTCOUNT(fact_sales[OrderNumber])
- Total Customers = DISTINCTCOUNT(fact_sales[CustomerKey])
- Total Quantity = SUM(fact_sales[OrderQuantity])

## Report Pages

### 1. Sales Overview

Main KPIs and visuals:
- Cards: Total Orders, Total Quantity, Total Customers, Total Revenue
- Line chart: Sales trend by month
- Bar chart: Sales by region
- Bar chart: Category sales
- Models chart: top bike models
- Donut: returns overview

(You can add a small image of the dashboard here.)

## How to Use

1. Download the `.pbix` file from `/powerbi`.
2. Open it in Power BI Desktop (version X or newer).
3. Use slicers (Year, Region, Category) to explore the report.

## What I Learned

- Building a star schema from multiple CSV tables
- Writing SQL to clean and combine sales data
- Creating DAX measures for KPIs in Power BI
- Designing a clean and interactive dashboard layout
