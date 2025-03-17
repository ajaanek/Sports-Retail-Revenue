# Optimizing Online Sports Retail Revenue

Welcome to my repository for the Optimizing Online Sports Retail Revenue  project. This project demonstrates how to combine multiple data sources (Brands, Finance, Product Info, Reviews, and Traffic) into a unified dataset, perform data cleaning and exploratory analysis in SQL, and build interactive dashboards in Power BI to derive business insights. The project uses a dataset from Kaggle, which contains data scraped from an online sports retail store like product name, description, brand, listing price, sale price, rating, and number of reviews.

## How to Use This Repository
- [**Github Pages**](https://ajaanek.github.io/Online-Retail-Sales-Analysis/): The complete project - including both the Kaggle Notebook and the interactive PowerBI Dashboards, is available in the deployed Github Page
- [**Kaggle Notebook**](https://www.kaggle.com/code/ajaanekanagasabai/online-retail-sales-analysis): The project’s complete data analysis, including Python code for data cleaning and transformation, is available in the Kaggle Notebook (file provided in the repository).
- **Tableau Visualizations**: The dashboards created in Tableau have been exported and are showcased via GitHub Pages. Visit the Deployed Dashboard for an interactive view. You can also view the dashboards on Tableau.
  - [Tableau Sales Dashboard](https://public.tableau.com/app/profile/ajaane.kanagasabai/viz/OnlineRetailSalesAnalysis_17332491897690/SalesDashboard)
  - [Tableau Sales Analysis](https://public.tableau.com/app/profile/ajaane.kanagasabai/viz/OnlineRetailSalesAnalysis_17332491897690/SalesAnalysis?publish=yes)

## Project Overview
This repository focuses on optimizing online sports retail revenue by analyzing product details, pricing, discounts, reviews, ratings, and website traffic. We joined multiple tables in SQL Server, cleaned and standardized the data, and built Power BI dashboards to uncover patterns and actionable insights.

Key Questions Addressed:
- How do the price points of Nike and Adidas differ?
- Is there a difference in the amount of discount offered between the brands?
- Does the length of a product’s description influence its rating and reviews?
- Which brand/gender segment contributes the most to revenue, and how does average revenue differ?
- What is the correlation between revenue and reviews/rating?


## Data Source
The analysis uses the Optimizing Online Sports Retail Revenue Dataset from [Kaggle](https://www.kaggle.com/datasets/irenewidyastuti/datacamp-optimizing-online-sports-retail-revenue?select=finance.csv). The dataset includes:
- **Brands** – Contains product IDs and brand information (Adidas, Nike).
- **Finance** – Lists listing price, sale price, discount, and total revenue.
- **Product Info** – Includes product name, description, etc.
- **Reviews** – Stores rating (out of 5) and number of reviews for each product.
- **Traffic** – Contains timestamps (last_visited) or other engagement metrics.

## Project Workflow
**Data Cleaning & Querying with SQL**:
- 
- Converted data into proper types (e.g., dates and numbers).
- Handled missing values and normalized product details.
- Created additional fields (e.g., quarters and sales periods) to facilitate analysis.

**Data Visualization with Tableau**:

After preprocessing the data in Python, I exported the cleaned dataset and built 2 interactive Tableau dashboards. These dashboards include:
- Sales Volume vs. Unit Price: To analyze product pricing and stocking strategies.
- Pareto Analysis for Items & Customers: To identify which products and customers contribute the most to revenue.
- Regional sales distribution and quarterly comparisons (including year-over-year insights).
- Customer segmentation analysis based on recency, frequency, and average spend.

  
## Key Insights
**Product Insights**:
The analysis revealed that the top 20 products by sales volume are not the same as the top 20 by revenue. This suggests that products with high sales frequency tend to be lower-priced, everyday items, while higher-priced, premium items-though sold less frequently-drive a significant portion of the revenue.

**Regional Performance**:
A significant concentration of sales is observed in the UK, highlighting an opportunity to either expand in other regions or further optimize operations within the UK.

**Seasonal Trends**:
Seasonal analysis helped identify peak sales periods, which can guide inventory planning and targeted promotions.

**Customer Segmentation**:
By segmenting customers based on their purchase frequency, recency, and average spend, the project highlights opportunities for targeted marketing and personalized customer retention strategies.

## Technical Skills Demonstrated
- **Data Cleaning & Transformation**: Efficiently managed and preprocessed data in Python.
- **Tableau**: Built dynamic dashboards with interactive visualizations, including bar charts, scatter plots, and Pareto analyses.
- **Analytical Thinking**: Derived actionable insights from the data, providing a comprehensive view of sales performance and customer behavior.

## Conclusion
This project exemplifies a data-driven approach to solving real-world business challenges in online retail. By integrating Python for data cleaning and querying with advanced Tableau visualizations, I have derived actionable insights to optimize sales strategies, enhance customer segmentation, and improve inventory management.
