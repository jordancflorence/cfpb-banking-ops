# CFPB Banking Operations Analysis

![Status](https://img.shields.io/badge/status-complete-brightgreen)
![SQL](https://img.shields.io/badge/tool-PostgreSQL-336791?logo=postgresql&logoColor=white)
![AI Workflow](https://img.shields.io/badge/AI--assisted-Claude%20%28Anthropic%29-blueviolet)
![Dataset](https://img.shields.io/badge/dataset-14.3M%20records-blue)

> Analyst-level exploration of 14.3 million US consumer banking complaints -- structured SQL, documented AI workflow, and Canadian market context. Built as a portfolio demonstration of operational analysis and applied AI skills.

---

## Project Overview

This project analyzes the full Consumer Financial Protection Bureau (CFPB) Consumer Complaint Database -- a publicly available dataset of approximately 14.3 million complaints submitted against US financial institutions between 2011 and the present.

The analytical goal is to simulate the kind of operational review a financial services analyst might conduct when assessing complaint trends, product risk, resolution patterns, and service gaps. Business questions were defined first, then answered through structured SQL queries built using an AI-assisted workflow.

---

## Methodology

All SQL queries were developed using an AI-assisted workflow with Claude (Anthropic) as a drafting and iteration tool.

The process for each query followed this pattern:

1. A specific business question was defined in plain English before any query was written.
2. That question was used to prompt Claude to generate an initial query structure.
3. The generated query was reviewed, tested in DataGrip against the actual dataset, and revised based on real output.
4. Iteration notes and insight statements were added as inline annotations directly in the SQL file.

Each query block in `analysis/complaint_analysis.sql` is annotated with four fields:

- **Business Question** -- the plain-language question the query is answering
- **Prompt Used** -- the exact or paraphrased prompt submitted to Claude
- **Iteration Notes** -- what changed between the initial draft and the final version, and why
- **Insight** -- the business-relevant finding produced by the query

This approach treats AI as a drafting accelerator, not a replacement for analytical judgment. The human-in-the-loop validation step is documented for every query.

---

## Tools and Environment

| Tool | Purpose |
|------|---------|
| PostgreSQL | Database engine for querying the CFPB dataset |
| DataGrip | SQL client used for query execution and iteration |
| Claude (Anthropic) | AI assistant used for initial query drafting and prompt-driven iteration |
| CFPB Consumer Complaint Database | Primary dataset (14.3 million records) |

---

## Canadian Market Context

Findings from this analysis were reviewed against the **OBSI 2025 Annual Report** (Ombudsman for Banking Services and Investments), accessed directly as a published primary source.

OBSI references in the analysis summary are drawn from aggregate figures and trend data reported in that document. This project does not include independent analysis of raw Canadian complaint data. The comparison is used to contextualize patterns observed in the US dataset against publicly reported Canadian banking complaint trends.

---

## Key Findings

1. Credit reporting dominates complaint volume at 88 to 90% of all complaints in recent years, meaning system-wide metrics are almost entirely a reflection of credit reporting performance rather than the broader product landscape.
2. Complaint issues concentrate predictably within product categories -- incorrect information accounts for 56% of credit reporting complaints and attempts to collect debt not owed accounts for 45% of debt collection complaints -- suggesting targeted process fixes could significantly reduce volume in high-concentration categories.
3. Monetary relief rates vary dramatically by product type, with money transfer fraud resolving with relief at only 4.04% across nearly 69,000 complaints compared to 63% for credit card late fee complaints, indicating that product type is a stronger predictor of resolution outcome than complaint volume.
4. January complaint volume is consistently elevated across nearly all product categories, with money transfer complaints spiking to 34.3% of annual volume in January alone, confirming a predictable seasonal risk window tied to post-holiday fraud activity.
5. The three major credit bureaus each exceed 3.3 million complaints individually -- nearly 20 times higher than the next highest company -- making any benchmarking that groups them with deposit institutions analytically misleading.

---

## Data Source

The dataset used in this project is the **CFPB Consumer Complaint Database**, published by the US Consumer Financial Protection Bureau.

**Download the dataset:**
[https://www.consumerfinance.gov/data-research/consumer-complaints](https://www.consumerfinance.gov/data-research/consumer-complaints)

The raw data file is not included in this repository due to file size. See `data/data_source.md` for full download instructions and PostgreSQL import steps.

---

## If I Extended This Project

- Replicate the complaint concentration analysis against Canadian FCAC complaint data when it becomes publicly available
- Build a lightweight Power BI dashboard on top of the SQL output to demonstrate reporting-layer skills
- Add a Python-based data loading script to make the PostgreSQL import reproducible for anyone cloning the repo

---

## About

Built by Jordan Florence -- operations analyst with 9 years of experience in Canadian financial services at TD Canada Trust, currently teaching mobile app development as a contract professor at St. Clair College. This project is part of a portfolio demonstrating applied SQL, AI workflow integration, and operational analysis skills.

[GitHub Profile](https://github.com/jordancflorence)
