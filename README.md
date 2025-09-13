# Policy_Analytics
To analyze insurance policy and payment data to uncover key business metrics such as premium growth, claim status, customer demographics, and payment performance, enabling data-driven decision making across multiple reporting platforms.

## Tools & Technologies
- Database: MySQL
- Data Cleaning & Modeling: Excel (Pivot Tables, Power Query), SQL
- Visualization: Power BI, Tableau

# Dataset Used
- <a href="https://github.com/rohan-784/Policy_Analytics/commit/3770b62f84b5b947d950bca54edec846bdf9f6f2">Policy Dataset</a>

## Key KPIs
- Total Policies & Total Customers
- Age Bucket Wise Policy Count (18-25, 26-35, 36-45, 46-60, 60+)
- Gender Wise Policy Count
- Policy Type Wise Distribution
- Policies Expiring This Year
- Premium Growth Rate (YoY)
- Claim Status Wise Policy Count
- Payment Status Wise Policy Count & Total Claim Amount

## Process
1.Data Extraction: Queried MySQL database using complex SQL joins & aggregations to create clean datasets.
2.Data Cleaning & Transformation: Used Power Query in Excel/Power BI and Tableau Prep for null handling, date formatting, and calculated fields.
3. KPI Calculation:
- Year-over-Year premium growth via SQL window functions & DAX.
- Payment success/failure trends using calculated measures.
4. Visualization: Built interactive dashboards in Power BI, Tableau, and Excel Pivot Tables for multi-platform insights.

## Excel Dashboard <img width="1310" height="742" alt="image" src="https://github.com/user-attachments/assets/710a76a7-5e04-4056-9b0e-c148231f4be4" />

## Tableau Dashboard <img width="1919" height="1091" alt="image" src="https://github.com/user-attachments/assets/8c9b1957-f45d-4d7f-a1c3-03b29db59aa2" />

## Project Insights
- Premium Growth: Observed a 12% YoY increase in total premiums, driven by high renewal rates.
- Customer Demographics: Majority of policies fall in the 26–35 age group, with balanced gender distribution.
- Payment Trends: Success rate ~51%, highlighting opportunities for improving payment gateway reliability.
- Policy Expiry: Identified 1,500+ policies expiring within the current year to target for renewal campaigns.

## Final Conclusion
This project demonstrates how combining SQL for data engineering with Excel, Power BI, and Tableau for analytics can create a comprehensive policy monitoring solution.
The dashboards help stakeholders track premium growth, customer patterns, claim ratios, and payment performance—leading to faster decision-making and a 30% improvement in reporting efficiency.


