# E-commerce Delivery & Sales Performance Analysis

## Project status
Portfolio practice project built with a **simulated dataset**. The data does not represent a real company or actual customer transactions.

## Objective
Analyse order activity, delivered sales, product-category performance, cancellations, returns and delivery times for a fictional Nigerian e-commerce business.

## Dataset
- File: `data/ecommerce_orders.csv`
- Records: 5,000 simulated orders
- Period: 1 January 2025 to 31 December 2025
- Currency: Nigerian naira (NGN)
- Fields include order/customer IDs, dates, category, product, quantity, order value, payment method, city, status and delivery duration.

## Tools
- Python (pandas, matplotlib) for data checks, analysis and visualisation
- SQL for business questions (next project stage)
- Excel and Power BI planned for reporting and dashboarding

## Initial Python findings
These figures are calculated from this generated practice dataset and should not be presented as real-world business results.

| Metric | Result |
|---|---:|
| Total orders | 5,000 |
| Delivered orders | 3,859 |
| Cancelled orders | 444 |
| Returned orders | 273 |
| Delivered revenue | ₦199,661,784.61 |
| Average delivered order value | ₦51,739.25 |
| Cancellation rate | 8.88% |
| Average delivery time for delivered orders | 3.54 days |

## Repository structure
```text
ecommerce_delivery_sales_project/
├── data/
│   └── ecommerce_orders.csv
├── outputs/
│   ├── key_metrics.json
│   ├── revenue_by_category.csv
│   ├── delivery_by_city.csv
│   ├── monthly_sales.csv
│   └── revenue_by_category.png
├── scripts/
│   └── analyze_ecommerce.py
└── README.md
```

## Run the analysis
Install dependencies:
```bash
pip install pandas numpy matplotlib
```

From the project root, run:
```bash
python scripts/analyze_ecommerce.py
```

## Important note
The dataset is synthetic and generated for learning and portfolio demonstration. Findings are illustrative only. No real customer information is included.
Power BI Dashboard

This project includes Power BI preparation files for building an interactive e-commerce sales and delivery performance dashboard.

Included files:

- "measures.dax" – DAX measures for key performance indicators.
- "dashboard_build_guide.md" – Step-by-step dashboard development guide.

Planned dashboard insights:

- Total orders and revenue
- Sales performance by product category
- Delivery performance by city
- Order status analysis
- Monthly sales trends

Note: This is a simulated portfolio project created for learning and demonstration purposes.
