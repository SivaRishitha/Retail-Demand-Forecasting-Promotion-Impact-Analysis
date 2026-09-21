# Retail Demand Forecasting & Promotion Impact Analysis

Time-series forecasting and statistical impact analysis on multi-year retail sales data — quantifying seasonal demand patterns and the true lift from promotional campaigns, built on the [Rossmann Store Sales Dataset](https://www.kaggle.com/c/rossmann-store-sales) (Kaggle).

![Status](https://img.shields.io/badge/status-in--progress-yellow) ![Python](https://img.shields.io/badge/python-3.x-blue) ![SQL](https://img.shields.io/badge/SQL-PostgreSQL%2FMySQL-orange) ![Power BI](https://img.shields.io/badge/Power%20BI-dashboard-yellow) ![License](https://img.shields.io/badge/license-MIT-lightgrey)

---

## Overview

Retail businesses need to answer two recurring questions: *how much will we sell next week/month*, and *did that promotion actually work, or would sales have risen anyway?* This project answers both using over 1,000 stores' worth of multi-year sales data — building a demand forecasting model and running formal hypothesis tests to isolate the true effect of promotions from seasonal and holiday trends.

## Business Questions Answered

- What will weekly/monthly sales look like for a given store over the next forecast horizon?
- Do promotions cause a statistically significant lift in sales, or is the increase explained by seasonality alone?
- Do holiday weeks differ significantly from regular weeks in sales volume?
- Which stores/categories are hardest to forecast, and why?

## Dataset

**Source:** [Rossmann Store Sales](https://www.kaggle.com/c/rossmann-store-sales) (Kaggle)

Includes daily sales records across 1,000+ stores with fields for promotions, holidays, store type, assortment, and competition distance — spanning multiple years, enabling proper trend/seasonality decomposition.

## Pipeline

```
Raw CSVs (Kaggle)
   → SQL: load, clean, aggregate sales by store/week/month; engineer time-based features
   → Python: seasonal decomposition (trend, seasonality, residuals)
   → Forecasting model (SARIMA / Prophet) → weekly sales forecast per store
   → Hypothesis testing (t-test / Mann-Whitney U) → promo lift, holiday effect significance
   → Power BI: forecast vs. actual, promo-lift by category, seasonal trend dashboard
```

## What Was Done

**1. Data Cleaning & Feature Engineering (SQL)**
Aggregated daily sales into weekly/monthly store-level series; engineered time-based features (week-of-year, month, holiday flags, promo flags) using SQL rather than doing all transformation in Pandas, to keep analysis reproducible at the database layer.

**2. Time-Series Forecasting**
- Decomposed sales into trend, seasonality, and residual components
- Built a SARIMA and/or Prophet model to forecast weekly sales per store
- Evaluated forecast accuracy using MAPE and RMSE on a held-out test period

**3. Hypothesis Testing**
- Tested whether promotional periods produce a statistically significant sales lift (t-test / Mann-Whitney U depending on distribution), controlling for seasonal effects
- Tested whether holiday weeks differ significantly from non-holiday weeks
- Reported p-values and effect sizes rather than raw percentage differences

**4. Power BI Dashboard**
Built a dashboard visualizing forecasted vs. actual sales, promotion-lift by store category, and seasonal trend decomposition for stakeholder review.

## Repository Structure

```
├── data/                  # Raw and cleaned datasets (or data-loading scripts, if raw files are excluded)
├── sql/                   # SQL scripts — cleaning, aggregation, feature engineering
├── notebooks/             # Decomposition, forecasting model, hypothesis testing notebooks
├── dashboard/              # Power BI (.pbix) file and/or exported screenshots
└── README.md
```

## Tech Stack

Python (Pandas, Statsmodels, Prophet, SciPy) · SQL · Power BI

## Future Improvements

- Extend forecasting to a multi-store hierarchical model
- Add external regressors (weather, local events) to improve forecast accuracy
- Deploy the forecast model behind a simple API for on-demand store-level predictions

## License

MIT
