# Retail Demand Forecasting & Promotion Impact Analysis

Time-series forecasting and hypothesis testing on multi-year retail sales data to predict demand and quantify the true impact of promotions — using the Rossmann Store Sales dataset (Kaggle).

## Overview

This project builds an end-to-end pipeline — from raw transactional data in MySQL, through Python-based forecasting and statistical testing, to an interactive Power BI dashboard — to answer three questions for a retail stakeholder:

1. **How accurately can we forecast weekly store sales?**
2. **Do promotions actually increase sales, and by how much does that vary by season?**
3. **Does forecast accuracy differ across store types, and where should the business expect more uncertainty?**

## Dataset

- **Source:** [Rossmann Store Sales](https://www.kaggle.com/c/rossmann-store-sales) (Kaggle)
- **Files used:** `train.csv` (~1.02M daily sales records, 2013–2015) and `store.csv` (1,115 stores with type, assortment, and competition metadata)
- Raw CSVs are not included in this repo — download them directly from Kaggle (requires accepting competition rules).

## Pipeline

### 1. Data Loading (MySQL 8.0)
- Loaded `train.csv` and `store.csv` into MySQL using `LOAD DATA LOCAL INFILE`.
- Verified row counts (1,017,209 daily records; 1,115 stores).

### 2. SQL Feature Engineering
- Joined `train` and `store` on `Store`, excluding closed-store days.
- Aggregated daily records into a **weekly, per-store** view (`weekly_store_sales`) with engineered features: `WeeklySales`, `WeeklyCustomers`, `PromoShare`, `HadSchoolHoliday`, `HadStateHoliday`, `StoreType`, `Assortment`, `CompetitionDistance`.
- SQL definitions: [`sql/weekly_store_sales.sql`](sql/weekly_store_sales.sql)
- Output: 166,908 weekly store-records.

### 3. Data Cleaning (Python / pandas)
- Exported the SQL view to CSV and loaded into pandas.
- Identified and removed 1 corrupted row from the export; cast integer columns correctly.
- Final clean dataset: **166,759 rows, zero missing values**.

### 4. Forecasting (SARIMA)
- Seasonal decomposition (`statsmodels`) to inspect trend, yearly seasonality, and residual noise per store.
- Fit `SARIMAX(order=(1,1,1), seasonal_order=(1,1,1,52))` per store, holding out the final 8 weeks as a test set.
- Forecasted a **stratified random sample of 150 stores** (by `StoreType`/`Assortment`) rather than all 1,115, using `joblib` parallelization — full sequential forecasting was estimated at ~200 minutes; sampling + parallelization brought this to ~15 minutes while preserving representativeness across store categories.
- Notebook: [`notebooks/forecasting_and_hypothesis_testing.ipynb`](notebooks/forecasting_and_hypothesis_testing.ipynb)

**Result:** Mean MAPE of **17.7%** across 150 stores (range: 7.6%–45.7%), all model fits successful.

### 5. Hypothesis Testing
- **Promo effect:** Welch's t-test comparing promo vs. non-promo weeks → t = 143.08, **p < 0.001**, Cohen's d = 0.70 (medium–large effect). Monthly breakdown shows lift ranging from **4.7% (August)** to **100.4% (December)** — promotions are consistently positive but far more effective during the holiday season.
- **State holiday effect:** Sales average ₹50,479 on holiday weeks vs. ₹35,110 on non-holiday weeks (+44%), also highly significant (p < 0.001).

### 6. Dashboard (Power BI)
A 4-page interactive report:

| Page | Contents |
|---|---|
| **Overview** | Total weekly sales trend across all 1,115 stores, highlighting recurring weekly cycles and December seasonal peaks |
| **Forecast vs Actual** | Per-store forecast vs. actual sales line chart, with a store selector, for the 8-week test window |
| **Promo Impact** | Promo vs. non-promo sales by month, promo lift % by month, and supporting statistical significance metrics |
| **Store Segmentation** | Forecast accuracy (MAPE) broken down by `StoreType` and `Assortment`, plus a MAPE-vs-RMSE scatter across all sampled stores |

Dashboard file: [`dashboard/retail_forecasting_dashboard.pbix`](dashboard/retail_forecasting_dashboard.pbix)

## Key Findings

- SARIMA forecasts achieve a **mean MAPE of 17.7%** across a representative store sample — a solid result for weekly retail demand forecasting.
- Promotions produce a **statistically and practically significant sales lift** (p < 0.001, Cohen's d = 0.70), but the size of that lift varies dramatically by month — over 20x difference between the weakest (August) and strongest (December) months.
- State holidays independently drive a **~44% sales increase**.
- Forecast accuracy is **not uniform across store types** — Store Type D is consistently harder to predict than others, suggesting more volatile or less-structured demand patterns for that segment.

## Tech Stack

- **Database:** MySQL 8.0
- **Analysis:** Python (Pandas, NumPy, Statsmodels, SciPy, Scikit-learn, Joblib)
- **Visualization:** Power BI

## Scope Notes

- Forecasting was run on a stratified sample of 150 of the 1,115 stores (proportionally split by `StoreType` and `Assortment`) to keep runtime practical on limited compute; results are representative but not exhaustive across every individual store.
- Raw Kaggle CSVs are intentionally excluded from this repo — see the Dataset section above for the download link.

## Repository Structure

```
├── sql/
│   └── weekly_store_sales.sql          # View definitions for cleaning & aggregation
├── notebooks/
│   └── forecasting_and_hypothesis_testing.ipynb
├── dashboard/
│   └── retail_forecasting_dashboard.pbix
└── README.md
```
