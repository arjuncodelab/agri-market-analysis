-- Q1 Which state contributed highest total arrival_quantity of Onion in 2024?
-- Answer Rank 1 Maha, 2 UP, 3 KR
------------------------------------------------------------------------------------------------------------------
SELECT
  s.state,
  SUM(md.arrival_quantity) "Total_arrival_quantity",
  RANK() OVER(ORDER BY SUM(md.arrival_quantity) DESC) AS "rnk"
FROM market_data md
JOIN states s ON md.state_id = s.id
JOIN commodity c ON md.commodity_id = c.id
WHERE extract(YEAR FROM md.date) = '2024' AND c.commodity = 'Onion'
GROUP BY s.state
;

------------------------------------------------------------------------------------------------------------------
-- Q2 Which Month did 'Onion' reach its Highes modal_price in Karnataka?
-- Highest Modal price was in Nov 2023, and as for seasonal pattern we can see Onion hace higher price in winters 
-- than other months
------------------------------------------------------------------------------------------------------------------
SELECT
  DENSE_RANK() OVER(PARTITION BY EXTRACT(YEAR FROM md.date) ORDER BY SUM(md.modal_price) DESC) AS "rnk",
  SUM(md.modal_price) AS "highest_modal_price",
  EXTRACT(MONTH FROM md.date) AS "month",
  EXTRACT(YEAR FROM md.date) AS "year"
FROM market_data md
JOIN states s ON md.state_id = s.id
JOIN commodity c ON md.commodity_id = c.id
WHERE c.commodity = 'Onion' AND s.state = 'Karnataka'
GROUP BY EXTRACT(YEAR FROM md.date), EXTRACT(MONTH FROM md.date)
ORDER BY year, rnk;

------------------------------------------------------------------------------------------------------------------
-- Q3 Spread between min_price and max_price for tomatoes in maharashtra, district wise most unstable price_unit?
-- Top 2 repeater districts with highest spreads for tomato in maharashtra are: Sholapur, Nashik. Other Top contenders are Chattraoati Sambhajinagar, Kolhapur, Ahmednagar
------------------------------------------------------------------------------------------------------------------
WITH CET AS (
  SELECT
    ROUND(AVG(max_price - min_price),2) AS "spread",
    d.district,
    EXTRACT(YEAR FROM md.date) AS "year",
    EXTRACT(MONTH FROM md.date) AS "month",
    DENSE_RANK() OVER(PARTITION BY EXTRACT(YEAR FROM md.date) ORDER BY AVG(max_price - min_price) DESC) AS "rank"
  FROM market_data md
  JOIN states s ON md.state_id = s.id
  JOIN districts d ON md.district_id = d.id
  JOIN commodity c ON md.commodity_id = c.id
  WHERE s.state = 'Maharashtra' AND c.commodity = 'Tomato'
  GROUP BY d.district, year, month
  ORDER BY year,month,rank
)
SELECT * FROM CET
WHERE rank <= 5
ORDER BY year,rank; 
------------------------------------------------------------------------------------------------------------------
-- Q4 Does highest arrival_quantity of Potatoes in UP actually lead to a lower modal_price?
-- we see a that Arrival Quantity do lead to lower modal price, But it isn't consistant. We high rise in price espically in mansoon seaon
-- even if supply stay consistent. But can't say anything solid as data get it show rise in price and arrival quantity in 2025 Q4 - 2026 Q1 and then there sudden rise in arrival quantity from 426.53 ton. in Jan 2026 to 1654 Feb and then 3202 next month.  
------------------------------------------------------------------------------------------------------------------
SELECT
  EXTRACT(YEAR FROM md.date) AS "year",
  EXTRACT(MONTH FROM md.date) AS "month",
  ROUND(AVG(md.arrival_quantity),2) AS "arrival_quantity",
  ROUND(AVG(md.modal_price),2) AS "modal_price"
FROM market_data md
JOIN states s ON md.state_id = s.id
JOIN commodity c ON md.commodity_id = c.id
WHERE s.state = 'Uttar Pradesh' AND c.commodity = 'Potato'
GROUP BY EXTRACT(YEAR FROM md.date), EXTRACT(MONTH FROM md.date)
ORDER BY year,month,arrival_quantity DESC;

------------------------------------------------------------------------------------------------------------------
-- Q5 Which specific market recorded the most frequent entries(number_days) for 3 ('Onion', 'Potato', 'Tomato') commodities combined?
--I partition by year and state, so we can check entries of all state's market for each year for comparison. UP Topped each year followed by MH, then KA
------------------------------------------------------------------------------------------------------------------
WITH CET AS (
  SELECT
    s.state,
    EXTRACT(YEAR FROM md.date) AS "year",
    m.market,
    COUNT(*) AS "entries",
    DENSE_RANK() OVER(PARTITION BY EXTRACT(YEAR FROM md.date), s.state ORDER BY COUNT(*) DESC) AS "rank"
  FROM market_data md
  JOIN states s ON md.state_id = s.id
  JOIN commodity c ON md.commodity_id = c.id
  JOIN market m ON md.market_id = m.id
  WHERE c.commodity IN ('Onion', 'Potato', 'Tomato') 
  GROUP BY s.state, EXTRACT(YEAR FROM md.date),  m.market
)  
SELECT * FROM CET
WHERE rank <= 3
ORDER BY year,entries DESC, rank
;

------------------------------------------------------------------------------------------------------------------
-- Q6 What is the average modal_price of Onions In MH vs KA for the same month?
------------------------------------------------------------------------------------------------------------------
SELECT
  EXTRACT(YEAR FROM md.date) AS "year",
  EXTRACT(MONTH FROM md.date) AS "month",
  ROUND(AVG(CASE WHEN s.state = 'Maharashtra' AND c.commodity = 'Onion' THEN modal_price END),2) AS "MH_modal_price",
  ROUND(AVG(CASE WHEN s.state = 'Karnataka' AND c.commodity = 'Onion' THEN modal_price END),2) AS "KA_modal_price"
FROM market_data md
JOIN states s ON md.state_id = s.id
JOIN commodity c ON md.commodity_id = c.id
WHERE s.state IN ('Maharashtra', 'Karnataka') AND c.commodity = 'Onion'
GROUP BY EXTRACT(YEAR FROM md.date), EXTRACT(MONTH FROM md.date)
ORDER BY year, month;

------------------------------------------------------------------------------------------------------------------
-- Q7 How much money moved by commodity in state monthly?
------------------------------------------------------------------------------------------------------------------
SELECT
  EXTRACT(YEAR FROM md.date) AS "year",
  EXTRACT(MONTH FROM md.date) AS "month",
  s.state,
  c.commodity,
  TO_CHAR(
  ROUND(SUM(md.arrival_quantity * 10 * modal_price),2), '999,999,999,999.99') AS "total_market_value"
FROM market_data md
JOIN states s ON md.state_id = s.id
JOIN commodity c ON md.commodity_id = c.id
GROUP BY EXTRACT(YEAR FROM md.date), EXTRACT(MONTH FROM md.date), s.state, c.commodity
ORDER BY year, month, state, total_market_value DESC;

------------------------------------------------------------------------------------------------------------------
Q8 Identify any dates where the modal_price of Tomatoes dropped by more than 30% compared to previous week in any market 
------------------------------------------------------------------------------------------------------------------
WITH CET AS (
  SELECT
    EXTRACT(YEAR FROM md.date) AS "year",
    EXTRACT(WEEK FROM md.date) AS "current_week",
    AVG(modal_price) AS "amount",
    s.state,
    m.market
  FROM market_data md
  JOIN states s ON md.state_id = s.id
  JOIN commodity c ON md.commodity_id = c.id
  JOIN market m ON md.market_id = m.id
  WHERE c.commodity = 'Tomato'
  GROUP BY EXTRACT(YEAR FROM md.date), EXTRACT(WEEK FROM md.date), s.state, m.market
  ORDER BY year, current_week
),
CET2 AS (
  SELECT 
    current_week,
    state,
    market,
    year,
    amount,
    LAG(amount, 1) OVER(partition by state, market order by year, current_week) AS "prv_week"
FROM CET
)
SELECT 
  current_week,
  year,
  state,
  market
FROM CET2
WHERE amount < (0.7 * prv_week)
;

------------------------------------------------------------------------------------------------------------------
Q9 Identifying Low - Competition Market
------------------------------------------------------------------------------------------------------------------
SELECT
  s.state,
  d.district,
  m.market,
  COUNT(*) AS "static_days"
FROM market_data md
JOIN states s ON md.state_id = s.id
JOIN districts d ON md.district_id = d.id
JOIN market m ON md.market_id = m.id
JOIN commodity c ON md.commodity_id = c.id
WHERE md.min_price = md.max_price
GROUP BY s.state, d.district,m.market, c.commodity
ORDER BY static_days DESC;

------------------------------------------------------------------------------------------------------------------
-- Q10 Are there any rows where min_price is actually greater than modal_price?
------------------------------------------------------------------------------------------------------------------
SELECT 
  s.state,
  d.district,
  m.market,
  EXTRACT(YEAR FROM md.date) AS "year",
  EXTRACT(MONTH FROM md.date) AS "month",
  ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM md.date) ORDER BY EXTRACT(MONTH FROM md.date)) AS "date",
  COUNT(md.*) AS "anomaly",
  SUM(md.min_price - md.modal_price) AS "price_diff"
FROM market_data md
JOIN states s ON md.state_id = s.id
JOIN districts d ON md.district_id = d.id
JOIN market m ON md.market_id = m.id
WHERE md.modal_price < md.min_price
GROUP BY EXTRACT(MONTH FROM md.date),EXTRACT(YEAR FROM md.date), m.market, d.district, s.state
ORDER BY date;
