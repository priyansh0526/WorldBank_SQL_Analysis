SELECT * FROM world_bank_data_2025;

-- Top 10 countries by Average GDP
SELECT country_name,
       ROUND(AVG(`GDP (Current USD)`)/1000000000, 2) AS avg_gdp_billion
FROM world_bank_data_2025
GROUP BY country_name
ORDER BY avg_gdp_billion DESC
LIMIT 10;

-- Top 10 Countries by Average GDP Growth
SELECT country_name,
       ROUND(AVG(`GDP Growth (% Annual)`), 2) AS avg_gdp_growth
FROM world_bank_data_2025
GROUP BY country_name
ORDER BY avg_gdp_growth DESC
LIMIT 10;

-- GDP Growth trend For India
SELECT year, `GDP Growth (% Annual)`
FROM world_bank_data_2025
WHERE country_name = 'India'
ORDER BY year;


-- Inflation & Intrest Rates
-- Countries with highest average inflation 
SELECT country_name,
       ROUND(AVG(`Inflation (CPI %)`), 2) AS avg_inflation
FROM world_bank_data_2025
GROUP BY country_name
ORDER BY avg_inflation DESC
LIMIT 10;

-- Inflation vs Intrest rate
SELECT country_name,
       ROUND(AVG(`Inflation (CPI %)`), 2) AS avg_inflation,
       ROUND(AVG(`Interest Rate (Real, %)`), 2) AS avg_interest
FROM world_bank_data_2025
GROUP BY country_name
ORDER BY avg_inflation DESC;

-- Employement And Income
-- Countries with lowest average unemployement
SELECT country_name,
       ROUND(AVG(`Unemployment Rate (%)`), 2) AS avg_unemployment
FROM world_bank_data_2025
WHERE `Unemployment Rate (%)` IS NOT NULL
GROUP BY country_name
ORDER BY avg_unemployment ASC
LIMIT 10;

-- GDP per Capita vs Unemployement
SELECT country_name,
       ROUND(AVG(`GDP per Capita (Current USD)`), 2) AS avg_gdp_per_capita,
       ROUND(AVG(`Unemployment Rate (%)`), 2) AS avg_unemployment
FROM world_bank_data_2025
WHERE `Unemployment Rate (%)` IS NOT NULL
GROUP BY country_name;

-- Goverment Finance
-- Top 10 countries by TAX Revenue
SELECT country_name,
       ROUND(AVG(`Tax Revenue (% of GDP)`), 2) AS avg_tax_revenue
FROM world_bank_data_2025
WHERE `Tax Revenue (% of GDP)` IS NOT NULL
GROUP BY country_name
ORDER BY avg_tax_revenue DESC
LIMIT 10;

-- Countries with High Public Debt
SELECT country_name,
       ROUND(AVG(`Public Debt (% of GDP)`), 2) AS avg_public_debt
FROM world_bank_data_2025
WHERE `Public Debt (% of GDP)` IS NOT NULL
GROUP BY country_name
ORDER BY avg_public_debt DESC
LIMIT 10;

-- Goverment Expense vs Revenue
SELECT country_name,
       ROUND(AVG(`Government Expense (% of GDP)`), 2) AS avg_expense,
       ROUND(AVG(`Government Revenue (% of GDP)`), 2) AS avg_revenue,
       ROUND(AVG(`Government Revenue (% of GDP)` - `Government Expense (% of GDP)`), 2) AS fiscal_balance
FROM world_bank_data_2025
GROUP BY country_name
ORDER BY fiscal_balance DESC;

-- External Balance 
-- Top 10 Countries with Highest Current account surplus
SELECT country_name,
       ROUND(AVG(`Current Account Balance (% GDP)`), 2) AS avg_current_account
FROM world_bank_data_2025
WHERE `Current Account Balance (% GDP)` IS NOT NULL
GROUP BY country_name
ORDER BY avg_current_account DESC
LIMIT 10;

-- Top 10 Countries with Largest Deficits 
SELECT country_name,
       ROUND(AVG(`Current Account Balance (% GDP)`), 2) AS avg_current_account
FROM world_bank_data_2025
WHERE `Current Account Balance (% GDP)` IS NOT NULL
GROUP BY country_name
ORDER BY avg_current_account ASC
LIMIT 10;

-- Correlations
-- GDP Growth vs Inflation Over Years
SELECT year,
       ROUND(AVG(`GDP Growth (% Annual)`), 2) AS avg_gdp_growth,
       ROUND(AVG(`Inflation (CPI %)`), 2) AS avg_inflation
FROM world_bank_data_2025
GROUP BY year
ORDER BY year;

-- GDP per Capita vs Public Debt
SELECT country_name,
       ROUND(AVG(`GDP per Capita (Current USD)`), 2) AS avg_gdp_per_capita,
       ROUND(AVG(`Public Debt (% of GDP)`), 2) AS avg_public_debt
FROM world_bank_data_2025
WHERE `Public Debt (% of GDP)` IS NOT NULL
GROUP BY country_name;

-- In Country Level Trend Example
-- Economic Overveiw Of India   
SELECT year,
       `GDP (Current USD)`,
       `GDP Growth (% Annual)`,
       `Inflation (CPI %)`,
       `Public Debt (% of GDP)`
FROM world_bank_data_2025
WHERE country_name = 'India'
ORDER BY year
limit 16; 

-- Economic Stability Index
-- Countries with stable economies(low inflation, steady growth, low unemployment)
SELECT country_name,
       ROUND(STDDEV(`GDP Growth (% Annual)`), 2) AS gdp_growth_volatility,
       ROUND(STDDEV(`Inflation (CPI %)`), 2) AS inflation_volatility,
       ROUND(STDDEV(`Unemployment Rate (%)`), 2) AS unemployment_volatility
FROM world_bank_data_2025
WHERE `GDP Growth (% Annual)` IS NOT NULL
  AND `Inflation (CPI %)` IS NOT NULL
  AND `Unemployment Rate (%)` IS NOT NULL
GROUP BY country_name
ORDER BY (gdp_growth_volatility + inflation_volatility + unemployment_volatility) ASC
LIMIT 10;

-- Debt Efficiency Ration
SELECT country_name,
       ROUND(AVG(`GDP Growth (% Annual)`)/NULLIF(AVG(`Public Debt (% of GDP)`),0), 4) AS debt_efficiency_ratio
FROM world_bank_data_2025
WHERE `Public Debt (% of GDP)` IS NOT NULL
GROUP BY country_name
ORDER BY debt_efficiency_ratio DESC
LIMIT 10;

-- Top Performing Economies by Growth Consistency
-- Countries with high average growth and low volatility:
SELECT country_name,
       ROUND(AVG(`GDP Growth (% Annual)`), 2) AS avg_growth,
       ROUND(STDDEV(`GDP Growth (% Annual)`), 2) AS growth_stability,
       ROUND(AVG(`GDP Growth (% Annual)`)/NULLIF(STDDEV(`GDP Growth (% Annual)`),0), 2) AS consistency_score
FROM world_bank_data_2025
WHERE `GDP Growth (% Annual)` IS NOT NULL
GROUP BY country_name
HAVING COUNT(year) > 5
ORDER BY consistency_score DESC
LIMIT 10;

-- Fiscal Health Index
-- Governments that balance spending, revenue, and debt well:
SELECT country_name,
       ROUND(AVG(`Government Revenue (% of GDP)`), 2) AS avg_revenue,
       ROUND(AVG(`Government Expense (% of GDP)`), 2) AS avg_expense,
       ROUND(AVG(`Public Debt (% of GDP)`), 2) AS avg_debt,
       ROUND((AVG(`Government Revenue (% of GDP)`) - AVG(`Government Expense (% of GDP)`)) 
             / NULLIF(AVG(`Public Debt (% of GDP)`),0), 4) AS fiscal_health_index
FROM world_bank_data_2025
GROUP BY country_name
ORDER BY fiscal_health_index DESC
LIMIT 10;

-- Resilience Score
-- Economies that grow despite high inflation and debt:
SELECT country_name,
       ROUND(AVG(`GDP Growth (% Annual)`), 2) AS avg_growth,
       ROUND(AVG(`Inflation (CPI %)`), 2) AS avg_inflation,
       ROUND(AVG(`Public Debt (% of GDP)`), 2) AS avg_debt,
       ROUND(AVG(`GDP Growth (% Annual)`) / (AVG(`Inflation (CPI %)`) + AVG(`Public Debt (% of GDP)`)/10), 4) AS resilience_score
FROM world_bank_data_2025
WHERE `GDP Growth (% Annual)` IS NOT NULL
GROUP BY country_name
ORDER BY resilience_score DESC
LIMIT 10;

-- Global Trend Insight (Year-wise)
-- Average global values per year — for dashboards: 
SELECT year,
       ROUND(AVG(`GDP Growth (% Annual)`), 2) AS world_gdp_growth,
       ROUND(AVG(`Inflation (CPI %)`), 2) AS world_inflation,
       ROUND(AVG(`Public Debt (% of GDP)`), 2) AS world_debt
FROM world_bank_data_2025
GROUP BY year
ORDER BY year;
