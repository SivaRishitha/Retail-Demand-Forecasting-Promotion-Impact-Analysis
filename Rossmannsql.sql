CREATE OR REPLACE VIEW daily_clean AS
SELECT
    s.Store,
    s.Date,
    s.Sales,
    s.Customers,
    s.Promo,
    s.StateHoliday,
    s.SchoolHoliday,
    st.StoreType,
    st.Assortment,
    st.CompetitionDistance,
    YEAR(s.Date)  AS Yr,
    WEEK(s.Date, 3) AS WeekNum,
    MONTH(s.Date) AS Mo
FROM train s
JOIN store st ON s.Store = st.Store
WHERE s.Open = 1;

CREATE OR REPLACE VIEW daily_clean AS
SELECT
    s.Store,
    s.Date,
    s.Sales,
    s.Customers,
    s.Promo,
    s.StateHoliday,
    s.SchoolHoliday,
    st.StoreType,
    st.Assortment,
    st.CompetitionDistance,
    YEAR(s.Date)  AS Yr,
    WEEK(s.Date, 3) AS WeekNum,
    MONTH(s.Date) AS Mo
FROM train s
JOIN store st ON s.Store = st.Store
WHERE s.Open = 1;

CREATE OR REPLACE VIEW weekly_store_sales AS
SELECT
    Store,
    Yr,
    WeekNum,
    MIN(Date) AS WeekStartDate,
    SUM(Sales) AS WeeklySales,
    SUM(Customers) AS WeeklyCustomers,
    AVG(Promo) AS PromoShare,
    MAX(SchoolHoliday) AS HadSchoolHoliday,
    MAX(CASE WHEN StateHoliday != '0' THEN 1 ELSE 0 END) AS HadStateHoliday,
    StoreType,
    Assortment,
    CompetitionDistance,
    Mo
FROM daily_clean
GROUP BY Store, Yr, WeekNum, StoreType, Assortment, CompetitionDistance, Mo;

SELECT * FROM weekly_store_sales
ORDER BY Store, Yr, WeekNum
LIMIT 20;

SELECT COUNT(*) FROM weekly_store_sales;

SELECT * FROM weekly_store_sales ORDER BY Store, Yr, WeekNum; 