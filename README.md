# Zach's Data Engineering Bootcamp — Solutions

This repository contains my solutions and notes for Zach Wilson's Data Engineering Bootcamp.  
Each module folder includes: a problem description, my approach, environment setup, code, and results.

## Repo Map
```
modules/
  01-sessionization-sql/
  02-docker-basics/
  03-flink-sessionization/
  04-spark-iceberg/
  05-data-modeling-sql/
  06-pipeline-orchestration/
scripts/
.github/workflows/
```
> Replace or extend modules as needed.

## Quick Start
1. Clone this repo  
   ```bash
   git clone <your-repo-url>
   cd de-bootcamp-zach-wilson-solutions
   ```
2. Create a Python virtual environment (optional)  
   ```bash
   python3 -m venv .venv && source .venv/bin/activate
   pip install -r requirements.txt
   ```
3. Open a module folder and follow its README.

## Modules
- **01 — Sessionization with SQL**: Window functions and time gaps.
- **02 — Docker Basics**: Containerizing small data apps.
- **03 — Flink Sessionization**: Streaming session windows with a 5-minute gap.
- **04 — Spark + Iceberg**: Batch processing, table formats, partitioning.
- **05 — Data Modeling with SQL**: Dimensional models, facts/dims, SCD.
- **06 — Pipeline Orchestration**: Glue/ Airflow-like orchestration basics.

## Disclaimer
These are my personal solutions for learning purposes.
