# Data dictionary

| Field | Description |
| --- | --- |
| transaction_id | Unique order identifier; one row per transaction |
| transaction_date | Order date, ISO format YYYY-MM-DD |
| customer_id | Synthetic customer key |
| product_id | Synthetic product key |
| product_name | Product label |
| category | Product category after normalization |
| region | Sales region after normalization; Unknown when missing |
| quantity | Units in the transaction; non-positive records removed |
| unit_price | Price per unit before discount, IDR |
| discount_pct | Discount fraction, from 0 to 0.20 |
| total_revenue | Net sales after discount, IDR |
| unit_cost | Synthetic product cost per unit, IDR |
| total_cost | Quantity multiplied by unit_cost, IDR |
| profit | total_revenue minus total_cost, IDR |
