# Analysis Summary: CFPB Consumer Complaint Data (2011–2026)

**Project:** cfpb-banking-ops
**Dataset:** 14.3 million consumer complaints — US Consumer Financial Protection Bureau
**Workflow:** AI-augmented SQL analysis (PostgreSQL via DataGrip, Claude-assisted query development)
**Author:** Jordan Florence | [github.com/jordancflorence](https://github.com/jordancflorence)

---

## About This Analysis

This project examines 14.3 million consumer financial complaints filed with the US Consumer Financial Protection Bureau to surface operational patterns relevant to complaint management, resolution quality, and seasonal risk. The goal was to replicate the kind of structured complaint analysis an operations analyst would perform in a financial services environment, using an AI-augmented SQL workflow to accelerate query development while maintaining analytical rigour through validation and iteration. Claude generated initial query structures based on defined business questions, which were then validated, iterated, and refined to produce accurate insights. The analysis is intended to demonstrate applied operational thinking, not to serve as regulatory or compliance guidance.

Canadian market context references are drawn from the OBSI 2025 Annual Report (publicly available aggregate data). No independent analysis of Canadian complaint data was performed.

**Tools used:** PostgreSQL, DataGrip, Claude (query scaffolding and iteration), OBSI 2025 Annual Report (contextual reference)

---

## Data Notes

Two data quality observations were identified and flagged during the analysis:

**Product naming inconsistency:** Product category labels changed across years in the raw dataset. For example, "Credit reporting" appears under multiple naming conventions depending on the filing year. Queries were designed to account for this variation, but it represents a risk in any automated categorization workflow and would require normalization before use in production reporting.

**Incomplete response tracking:** Several product rows returned blank values in the company response field. This likely reflects gaps in how response outcomes were captured historically rather than actual non-response. Any resolution rate calculation should treat these blanks as missing data, not confirmed resolutions. Both observations are flagged for normalization in any downstream production use of this data.

---

## Key Findings

### 1. Credit Reporting Has Effectively Absorbed the Complaint System

Credit reporting complaints represent 88 to 90% of all complaints filed in recent years. Debt collection is the next largest category at approximately 5%. This concentration means that any system-wide metric, such as average resolution time or overall timely response rate, is almost entirely a reflection of credit reporting performance rather than the broader product landscape.

**Operational implication:** Benchmarks and SLAs built on aggregate complaint data will underrepresent problems in smaller product categories. Teams responsible for non-credit products should maintain separate performance baselines rather than measuring against system-wide averages.

**Canadian market parallel:** While Canadian complaint data does not show the same credit reporting concentration (credit bureaus are not directly subject to OBSI oversight), the principle holds: high-volume categories can mask deteriorating performance in lower-volume products that carry significant consumer impact.

---

### 2. Complaint Issues Concentrate Predictably Within Product Categories

Within credit reporting, a single issue type accounts for 56% of all complaints: incorrect information on a credit report. Within debt collection, 45% of complaints are tied to attempts to collect a debt not owed. Checking accounts are notably different, with complaints distributed more evenly across account management failures, closures, and unauthorized charges.

**Operational implication:** For high-concentration categories, a small number of process fixes could significantly reduce complaint volume. For checking accounts, the distributed failure pattern suggests systemic issues rather than a single root cause and would require a different remediation approach.

**Canadian market parallel:** This pattern is consistent with how OBSI categorizes banking complaint drivers. Fraud was the leading banking complaint issue in Canada in 2025 at 33% of all banking cases, with e-Transfer fraud as the top product, suggesting that like US debt collection, a specific failure mode dominates a broader category.

---

### 3. Monetary Relief Rates Signal Where Resolution Is Substantive vs. Procedural

Across nearly all product categories, the dominant resolution outcome is closed with explanation rather than monetary relief. Credit reporting closes only 0.02% of complaints with monetary relief. Prepaid cards are the exception at 23%. Student loan complaints show monetary relief rates as low as 2.23% across tens of thousands of complaints, and money transfer fraud resolves with relief at only 4.04% despite nearly 69,000 complaints.

By contrast, credit card late fee complaints resolve with monetary relief at 63%, suggesting that product type is a stronger predictor of resolution outcome than complaint volume alone.

**Operational implication:** Low relief rates in high-volume categories are not automatically a problem, but the gap between categories like money transfer fraud (4.04% relief, 69,000 complaints) and late fee complaints (63% relief) warrants investigation. Where resolution outcomes are structurally capped by policy or product design, consumer expectations will consistently exceed what the system can deliver.

**Canadian market parallel:** OBSI's monetary relief rate for banking cases was 25% in 2025, serving as a useful reference point. The CFPB figures for money transfer fraud and student loans are significantly below this threshold, which may reflect the nature of those complaint types rather than process failure, but the gap is notable.

---

### 4. January Represents a Consistent, Predictable Risk Period

January is consistently elevated across nearly all product categories. Most striking is the money transfer category, where January alone accounts for 34.3% of annual complaint volume before dropping sharply in February. This pattern is consistent with post-holiday fraud and scam activity. Q1 to Q2 shows a consistent de-escalation pattern across most categories.

**Operational implication:** January volume is not random variation. Operations teams with complaint handling responsibilities should plan staffing and escalation capacity around this window, particularly for fraud-adjacent products.

**Canadian market parallel:** This seasonal pattern has a direct Canadian equivalent. OBSI's 2025 Annual Report identified fraud as the leading banking complaint issue, with e-Transfer fraud as the top product. The January spike in the CFPB data is consistent with holiday fraud activity as a cross-border seasonal driver.

---

### 5. The Three Credit Bureaus Operate at a Different Scale Than Every Other Company

The three major credit bureaus each exceed 3.3 million complaints individually, nearly 20 times higher than the next highest company in the dataset. Among traditional deposit institutions, Bank of America carries both the highest complaint volume (approximately 175,000 complaints) and the lowest timely response rate in the top 20 at 97.5%, a combination that represents the highest operational risk profile in that peer group.

**Operational implication:** Any benchmarking that groups credit bureaus with deposit institutions will produce misleading results. The bureaus and traditional banks are not comparable on complaint volume and should be analyzed and reported separately. Within deposit institutions, a 97.5% timely response rate looks strong in isolation but ranks last in a peer group that exceeds 99% across the board.

---

## Process Improvement Implications

Based on the patterns identified across all six business questions, three areas warrant prioritized operational attention:

- **Separate reporting by product cluster, not product name.** Credit reporting's dominance masks meaningful variation in other categories. Any complaint management dashboard should isolate credit reporting performance from deposit, lending, and payment product performance to give operations teams an accurate picture of where deterioration is occurring.

- **Build seasonal capacity planning into complaint workflows.** The January spike is consistent, predictable, and disproportionately tied to fraud-adjacent products. Teams that treat January as normal operating volume will be consistently under-resourced during the highest-risk period of the year.

- **Investigate low-relief, high-volume categories as candidates for systemic review.** Money transfer fraud at 4.04% relief across 69,000 complaints and mortgage struggling to pay at 3.1% relief across nearly 59,000 complaints are not outliers. They are patterns. Whether the root cause is policy design, product limitations, or process gaps, these combinations represent the highest concentration of unresolved consumer harm in the dataset and the strongest candidates for structured remediation review.

---

[View the full project](https://github.com/jordancflorence/cfpb-banking-ops)
