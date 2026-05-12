INSERT INTO states(state)
SELECT state FROM mixed
GROUP BY state
ORDER BY state
;

INSERT INTO districts (state_id, district)
SELECT s.id, m.district
FROM states s
JOIN mixed m ON s.state = m.state
GROUP BY s.id ,m.district
ORDER BY s.id, m.district;

INSERT INTO market(district_id, market)
SELECT d.id, m.market FROM districts d
JOIN mixed m ON d.district = m.district
GROUP BY d.id, m.market
ORDER BY d.id, m.market;

INSERT INTO commodity(commodity, commodity_group)
SELECT 
 m.commodity,
 case
  when commodity_group = 'Vegetables' THEN 'Veg'
  WHEN commodity_group = 'Fruits' THEN 'Fruts'
  END 
FROM mixed m
GROUP BY commodity, commodity_group
ORDER BY m.commodity, m.commodity_group
;


INSERT INTO market_data(state_id, district_id, market_id, commodity_id, date, arrival_quantity, arrival_unit, min_price, modal_price, max_price, price_unit)
SELECT 
  s.id,
  d.id,
  mk.id,
  c.id,
  CAST(m.date AS DATE),
  m.arrival_quantity,
  CASE
    WHEN m.arrival_unit = 'Metric Tonnes' THEN 'ton.'
    ELSE m.arrival_unit
  END,
  m.min_price,
  m.modal_price,
  m.max_price,
 CASE 
    WHEN m.price_unit = 'Rs./Quintal' THEN 'rs/q'
    ELSE m.price_unit
  END
FROM mixed m
JOIN states s ON m.state = s.state
JOIN districts d ON m.district = d.district
JOIN market mk ON m.market = mk.market
JOIN commodity c ON m.commodity = c.commodity
ORDER BY s.id,d.id,mk.id,c.id
;
