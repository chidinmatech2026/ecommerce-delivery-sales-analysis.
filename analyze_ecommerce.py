"""
E-commerce Delivery & Sales Performance Analysis
Run from the project root:
    python scripts/analyze_ecommerce.py
Dependencies: pandas, numpy, matplotlib
"""
from pathlib import Path
import json
import pandas as pd
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "ecommerce_orders.csv"
OUT = ROOT / "outputs"
OUT.mkdir(exist_ok=True)

df = pd.read_csv(DATA, parse_dates=["order_date", "shipped_date", "delivered_date"])

# Basic data-quality checks
print("Rows:", len(df))
print("Duplicate order IDs:", df["order_id"].duplicated().sum())
print("Missing values by column:")
print(df.isna().sum())

# Core business metrics
delivered = df[df["order_status"] == "Delivered"].copy()
metrics = {
    "total_orders": int(len(df)),
    "delivered_orders": int((df["order_status"] == "Delivered").sum()),
    "cancelled_orders": int((df["order_status"] == "Cancelled").sum()),
    "returned_orders": int((df["order_status"] == "Returned").sum()),
    "delivered_revenue_ngn": round(float(delivered["order_amount_ngn"].sum()), 2),
    "average_delivered_order_value_ngn": round(float(delivered["order_amount_ngn"].mean()), 2),
    "cancellation_rate_pct": round(float((df["order_status"] == "Cancelled").mean() * 100), 2),
    "average_delivery_days": round(float(delivered["delivery_days"].mean()), 2),
}
(OUT / "key_metrics.json").write_text(json.dumps(metrics, indent=2))

# Revenue by category
category = (delivered.groupby("product_category")
            .agg(orders=("order_id", "count"),
                 revenue_ngn=("order_amount_ngn", "sum"),
                 avg_order_value_ngn=("order_amount_ngn", "mean"))
            .sort_values("revenue_ngn", ascending=False)
            .reset_index())
category.to_csv(OUT / "revenue_by_category.csv", index=False)

# Delivery performance by city
city = (df.groupby("delivery_city")
        .agg(total_orders=("order_id", "count"),
             delivered_orders=("order_status", lambda x: (x == "Delivered").sum()),
             cancelled_orders=("order_status", lambda x: (x == "Cancelled").sum()))
        .reset_index())
city["cancellation_rate_pct"] = (
    city["cancelled_orders"] / city["total_orders"] * 100
).round(2)
city.to_csv(OUT / "delivery_by_city.csv", index=False)

# Monthly delivered sales
monthly = delivered.assign(month=delivered["order_date"].dt.to_period("M").astype(str))
monthly = monthly.groupby("month").agg(
    delivered_orders=("order_id", "count"),
    revenue_ngn=("order_amount_ngn", "sum")
).reset_index()
monthly.to_csv(OUT / "monthly_sales.csv", index=False)

# Revenue chart
plt.figure(figsize=(9, 5))
plt.bar(category["product_category"], category["revenue_ngn"])
plt.title("Delivered Revenue by Product Category")
plt.xlabel("Product category")
plt.ylabel("Revenue (NGN)")
plt.xticks(rotation=20, ha="right")
plt.tight_layout()
plt.savefig(OUT / "revenue_by_category.png", dpi=160)
plt.close()

print("\\nKey metrics")
print(json.dumps(metrics, indent=2))
print("\\nAnalysis complete. See the outputs folder.")
