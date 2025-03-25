# Sports Retail Revenue Analysis and Optimization

Welcome to my repository for the Optimizing Online Sports Retail Revenue  project. This project demonstrates how to combine multiple data sources (Brands, Finance, Product Info, Reviews, and Traffic) into a unified dataset, perform data cleaning and exploratory analysis in SQL, and build interactive dashboards in PowerBI to derive business insights. The project uses a dataset from Kaggle, which contains data scraped from an online sports retail store like product name, description, brand, listing price, sale price, rating, and number of reviews.

## How to Use This Repository
- [**Github Pages**](https://ajaanek.github.io/Online-Retail-Sales-Analysis/): The complete project - including both the Kaggle Notebook and the interactive PowerBI Dashboards, is available in the deployed Github Page
- [**Kaggle Notebook**](https://www.kaggle.com/code/ajaanekanagasabai/sports-retail): Explore the complete data analysis and Python code in the Kaggle Notebook (ipynb also file provided in the repository).
- [**PowerBI**](https://app.powerbi.com/view?r=eyJrIjoiYTkzN2U3ZWItNmM2Yi00ZjVhLTg4YWEtZTNiMDEzODg3YWY1IiwidCI6IjY0ZDEyMDc0LTcyNmUtNDE4NS1hMmM1LTdkYjUyMmUwZmYwZiJ9): The dashboards created in PowerBI have been exported and are showcased via GitHub Pages. Visit the Deployed Dashboard for an interactive view. You can also view the dashboards on PowerBI. You can switch between the 2 dashboards created in the bottom right.
- You can connect to the database yourself and run the queries in the SQL folder yourself by connecting to the database.

  ## How to Connect to the Database
You can connect to the Azure SQL database using the following details:

- **Server:** `tcp:onlinesportsretail.database.windows.net,1433`
- **Database:** `Sports Retail Revenue`
- **Username:** `demo_user`
- **Password:** `ZsTBAjAD3(h1I`
- **Authentication:** SQL Server Authentication

### How to Connect:
1. Open Azure Data Studio or SSMS.
2. Use the connection details above.
3. Run the sample queries provided in the `/SQL` folder.

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
**SQL Data Cleaning & Transformation**:
- Joined all tables
- Removed duplicates using a ROW_NUMBER() approach.
- Standardized casing for brand, product names (Men's, Women's), and columns for decimal precision.
- Filtered out null rows or incomplete entries
- Converted data into proper types (e.g., dates and numbers).
- Created additional fields (e.g., gender) to facilitate analysis.

**Initial Exploratory Analysis**
- Percentile Calculations (PERCENTILE_CONT) for price points.
- Correlation Coefficient procedure CalculateCorrelation to find relationships (e.g., revenue vs. reviews).
- Gender Column to classify products as Men’s, Women’s, or Uncategorized.
- Identifying footwear items to compare footwear vs. clothing median revenue.


**Key Insights & Analysis in SQL**
Brand Comparison:
- Nike’s price tiers are significantly higher than Adidas’, yet the distribution across low/medium/high tiers is similar, suggesting different brand positioning but a similar product mix strategy.
- Nike’s price points are 200–260% higher than Adidas’ for each percentile tier.
Footwear vs. Clothing:
- 82.6% of the company’s products are footwear.
- Footwear median revenue is significantly higher than clothing.
Revenues vs. Reviews:
- Correlation between revenue and reviews is ~0.65 (moderately strong).
Gender vs. Revenue:
- Men’s footwear yields higher total revenue, but women’s footwear has a higher average revenue per product.
Discount Effectiveness:
- Many products have negative (sale_price - listing_price), indicating frequent discount usage.
- Some negative margins exist even without an explicit discount, possibly due to data entry or return policies.
Description Length vs. Reviews/Rating:
- The correlation is near zero, implying description length does not significantly impact ratings or reviews.


**Data Visualization with PowerBI**:

After preprocessing the data in SQL, I exported the cleaned dataset and built 2 interactive PowerBI dashboards. These dashboards include:

1. Overall Sales & Revenue Analysis
- KPIs: Average Revenue per Product, Average Rating, Total Number of Products.
- Charts:
  - Relationship Between Discount & Revenue
  - Total Revenue by Year
  - Bubble Chart for rating vs. reviews (size = revenue).
  - Gender Distribution & Revenue by Gender
2. Brand Comparison Dashboard
- Brand Performance (Revenue vs. % of Products)
- Average Rating by Brand
- Discount Percentage by Brand
- Revenue by Product and Brand

  
## Key Insights
- Improve Nike's product-to-revenue efficiency through targeted marketing and quality adjustments.
- Optimize Adidas’ product line by phasing out underperforming SKUs and increasing margins on best-sellers.
- Expand high-margin women’s products and refine product categorization.
- Leverage customer reviews to drive product improvements and boost customer confidence.


## Technical Skills Demonstrated
- **Data Cleaning & Transformation**: Efficiently managed and preprocessed data in SQL using SSMS.
- **PowerBI**: Built dynamic dashboards with interactive visualizations, including bar charts, scatter plots, and bubble charts.
- **Azure SQL Database**: Set up and managed a cloud-hosted Azure SQL database, importing data from SSMS via Azure Data Studio.
- **Analytical Thinking**: Derived actionable insights from the data, providing a comprehensive view of sales performance and customer behavior.

## Conclusion
This project demonstrates the value of combining SQL-based data analysis with interactive Power BI dashboards to uncover actionable insights in online retail. The analysis highlights key areas for improvement, such as optimizing Nike's product mix, refining Adidas’ pricing strategy, and enhancing product categorization to increase revenue efficiency.

Future improvements could include:
- Expanding the analysis to seasonal trends and customer segmentation.
- Incorporating real-time data to enable dynamic, real-world decision-making.
- Exploring sentiment analysis on product reviews to improve product development.
  
Overall, this project showcases the power of structured data analysis and visualization in driving business growth and strategic decision-making.
