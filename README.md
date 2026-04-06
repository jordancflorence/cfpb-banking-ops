# cfpb-banking-ops

AI-augmented operational analysis of 14.3 million US consumer banking complaints, built to demonstrate analyst-level SQL fluency, structured business thinking, and applied AI workflow skills.

---

## Project Overview

This project analyzes the full Consumer Financial Protection Bureau (CFPB) Consumer Complaint Database - a publicly available dataset of approximately 14.3 million complaints submitted against US financial institutions between 2011 and the present.

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

- **Business Question** - the plain-language question the query is answering
- **Prompt Used** - the exact or paraphrased prompt submitted to Claude
- **Iteration Notes** - what changed between the initial draft and the final version, and why
- **Insight** - the business-relevant finding produced by the query

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

1. Credit reporting and credit card products account for the largest share of complaints by volume, reflecting the product categories where consumers most frequently experience unresolved disputes.
2. Complaints submitted via the web resolve at a higher rate through timely responses compared to complaints submitted through other channels, suggesting intake method correlates with servicer prioritization.
3. A small number of large institutions generate a disproportionate share of total complaints, consistent with market concentration patterns in both US and Canadian retail banking.
4. The proportion of complaints receiving an untimely response has shifted over the observation period, with notable spikes correlating with periods of broader economic stress.
5. Consumer dispute rates - where a consumer explicitly rejects the company's resolution - vary significantly by product type, indicating that some product categories produce systematically lower consumer satisfaction with outcomes.

---

## Data Source

The dataset used in this project is the **CFPB Consumer Complaint Database**, published by the US Consumer Financial Protection Bureau.

**Download the dataset:**
[https://www.consumerfinance.gov/data-research/consumer-complaints](https://www.consumerfinance.gov/data-research/consumer-complaints)

The raw data file is not included in this repository due to file size. See `data/data_source.md` for full download instructions and PostgreSQL import steps.

---

## About

Built by Jordan Florence -- IT operations professional and contract professor with 9 years of experience in Canadian financial services. This project is part of a portfolio demonstrating applied SQL, AI workflow integration, and operational analysis skills.

[GitHub Profile](https://github.com/jordancflorence)
