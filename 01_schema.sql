CREATE TABLE IF NOT EXISTS states(
  "id" SERIAL,
  "state" VARCHAR NOT NULL UNIQUE,
  PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS districts(
  "id" SERIAL,
  "state_id" INT NOT NULL,
  "district" VARCHAR NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (state_id) REFERENCES states(id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS market(
  "id" SERIAL,
  "district_id" INT NOT NULL,
  "market" VARCHAR,
  PRIMARY KEY (id),
  FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS commodity(
  "id" SERIAL,
  "commodity" VARCHAR,
  "commodity_group" VARCHAR(15), -- only to max(5) characters like veg, frts
  PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS mixed(
  "id" SERIAL,
  "state" VARCHAR,
  "district" VARCHAR,
  "market" VARCHAR,
  "commodity_group" VARCHAR,
  "commodity" VARCHAR,
  "date" DATE,
  "MSP" NUMERIC DEFAULT NULL,
  "arrival_quantity" NUMERIC,
  "arrival_unit" VARCHAR,
  "min_price" NUMERIC,
  "modal_price" NUMERIC,
  "max_price" NUMERIC,
  "price_unit" VARCHAR,
  PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS market_data (
  "id" SERIAL,
  "state_id" INT,
  "district_id" INT,
  "market_id" INT,
  "commodity_id" INT,
  "date" DATE,
  "arrival_quantity" INT,
  "arrival_unit" VARCHAR,
  "min_price" NUMERIC(12,2),
  "modal_price" NUMERIC(12,2),
  "max_price" NUMERIC(12,2),
  "price_unit" VARCHAR,
  PRIMARY KEY (id),
  FOREIGN KEY (state_id) REFERENCES states(id)  ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (market_id) REFERENCES market(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (commodity_id) REFERENCES commodity(id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE INDEX market_index ON market(market);
CREATE INDEX idx_market_data_date ON market_data(date);

CREATE VIEW agri_market_data AS (
  SELECT
  md.id,
  s.state,
  d.district,
  m.market,
  c.commodity,
  c.commodity_group,
  md.date,
  md.arrival_quantity,
  md.arrival_unit,
  md.min_price,
  md.modal_price,
  md.max_price,
  md.price_unit
FROM market_data md
JOIN states s ON md.state_id = s.id
JOIN districts d ON md.district_id = d.id
JOIN market m ON md.market_id = m.id
JOIN commodity c ON md.commodity_id = c.id
ORDER BY md.state_id, md.district_id, md.market_id, md.commodity_id
);
