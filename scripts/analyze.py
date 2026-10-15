"""Rebuild a core project result using Python standard library only."""
import csv, json
from collections import defaultdict
from datetime import date
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
DATA=ROOT/"data"
AS_OF=date(2025,12,31)
def load(name):
    with (DATA/name).open(newline="",encoding="utf-8-sig") as f: return list(csv.DictReader(f))
rows=load("transaksi_retail_clean.csv")
cats=defaultdict(lambda:{"orders":0,"revenue":0.0,"profit":0.0})
months=defaultdict(lambda:{"orders":0,"revenue":0.0,"profit":0.0})
for r in rows:
    rev,profit=float(r["total_revenue"]),float(r["profit"])
    for g in (cats[r["category"]],months[r["transaction_date"][:7]]):
        g["orders"]+=1;g["revenue"]+=rev;g["profit"]+=profit
summary={"orders":len(rows),"customers":len({r["customer_id"] for r in rows}),
 "revenue":sum(float(r["total_revenue"]) for r in rows),"profit":sum(float(r["profit"]) for r in rows),
 "categories":dict(cats),"months":dict(sorted(months.items()))}
(DATA/"analysis_summary_rebuilt.json").write_text(json.dumps(summary,indent=2),encoding="utf-8")
print(f"Rebuilt summary: {summary['orders']:,} orders, {summary['customers']:,} customers")
