# Project Overview
This Project focuses on the architecture and analysis of agricultural commodity trends (Onions, Potatos, Tomatoes,
Lemons) across Maharashtra, Uttar Pradesh, and Karnataka.
Using a custom-built **ETL(Extract, Transform, Load) pipeline**. I processed over _600K+_ rows of volatile market
data to identify pricing anomalies and supply-chain "tipping points."
### Key Technical Features
- **Database Architecture:**
  Implemented a _3rd Normal Form (3NF)_ relation schema in PostgreSQL to ensure data integrity and reduce redundancy.
- **ETL Pipeline:**
  Developed a multi-stage loading process using a "Landing/Mixed Table" strategy to clean, validate, and normalize raw
  market data.
- **Performance Optimization:**
  Utilized _B-Tree Indexing_ on date and market column and created _Complex Views_ to simplify high-frequency
  analytical queries.
- **Data Cleaning:**
  Implemented logic to handle unit normalization (Quintals to Tonnes) and outlier detection for commercial-scale
  transactions 
#### ER Diagram
<img width="975" height="506" alt="supabase-schema-gyofdcpszegayjdlpmvj(1)" src="https://github.com/user-attachments/assets/0b56c12f-e4ed-49de-9786-0a92e8d84aa9" />

### Key Business Insights:
- **Regional Procurement Strategy:**
  Maharashtra holds the dominant supply volume for *Onions*, while *Uttar Pradesh* exhibits the highest overall market activity across all major commodities, dictating optimal regions for logistics investment or cold storage warehouse.
- **Volatility & Risk Mapping:**
 Sholapur & Nashik was consistently identified as the higest_risk market for *Tomatoes* in Maharashtra over 3 year. And other strong markets that also show high volatility are Chattraoati Sambhajinagar, Kolhapur, Ahmednagar.
- **Supply-Price Elasticity Limitations:**
  While higher arrival quantities generally drive prices down, historical data *(e.g. Uttar Pradesh Potatoes)* proves that extreme weather events *(Monsoon season)* aggressively inflate prices regardless of steady supply levels.
- **Automated Crash Deteaction:**
  Successfully isolated hyper_specific market windows where commodity prices crashed by >30% week-over-week, providing actionable data models for rapid, low-cost procurement opportunites.
- **Market Competition Audits:**
  Identified "Static Markets" where the minimum and maximum daily prices were identical, flagging refions with either zero vendor competition or poor data reporting standards, advising buyers to avoid these zone.
- **Data Integrity & Edge-Case Auditing:**
  Successfully isolated a rare logical anomaly where min_price in *Karnataka* across 3 specific locations: *Gundlupet APMC(**Chamarajanagar**),Hubil (Amaragol) APMC (**Dharwad**), and Nanjangud APMC (**Mysore**)*. But occurring rarely (only 1-2 times a year), capturing these precise anomalies demonstrartes an auditor's mindset, showcasing the pipeline's capability to flag human data-entry errors to local APMC yards before they corrupt downstream exeutive reporting. 

