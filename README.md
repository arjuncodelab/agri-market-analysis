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
#### Business Insights 
