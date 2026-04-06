-- ============================================================
-- QUERY 1: Complaint Volume by Product Category Over Time
-- ============================================================

-- BUSINESS QUESTION: Which product categories generate the most complaint volume,
-- and how has that trended over time?

-- PROMPT USED: "I have a PostgreSQL table called complaints with the following columns:
-- date_received, product, sub_product, issue, sub_issue, consumer_complaint_narrative,
-- company_public_response, company, state, zip_code, tags, consumer_consent_provided,
-- submitted_via, date_sent_to_company, company_response_to_consumer, timely_response,
-- consumer_disputed, complaint_id. Write a SQL query that shows total complaint volume
-- by product category, broken down by year, ordered by year descending and volume
-- descending. I want to see which products are generating the most complaints and
-- whether that is changing over time."

-- ITERATION NOTE: Output was reviewed for accuracy. Noted that product naming
-- conventions changed across years in the raw data (e.g. "Credit reporting, credit
-- repair services, or other personal consumer reports" consolidating into "Credit
-- reporting or other personal consumer reports" from 2024 onward). No query changes
-- were needed but this data quality observation is flagged for the summary doc.

-- INSIGHT: Credit reporting dominates complaint volume across all recent years,
-- reaching 88-90% of all complaints in 2024 and 2025. Debt collection is a distant
-- second at roughly 5%. The concentration in a single category suggests either a
-- systemic industry issue or a consumer awareness effect driving reporting behavior.

SELECT
    EXTRACT(YEAR FROM date_received)::INT   AS year,
    product,
    COUNT(*)                                AS total_complaints,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (PARTITION BY EXTRACT(YEAR FROM date_received)),
        2
    )                                       AS pct_of_year
FROM complaints
GROUP BY
    EXTRACT(YEAR FROM date_received),
    product
ORDER BY
    year        DESC,
    total_complaints DESC;

-- ============================================================
-- QUERY 2: Top 5 Issues by Product Category
-- ============================================================

-- BUSINESS QUESTION: Which issues within each product category are most frequently
-- reported, and where are specific pain points concentrated?

-- PROMPT USED: "I have a PostgreSQL table called complaints with the following columns:
-- date_received, product, sub_product, issue, sub_issue, consumer_complaint_narrative,
-- company_public_response, company, state, zip_code, tags, consumer_consent_provided,
-- submitted_via, date_sent_to_company, company_response_to_consumer, timely_response,
-- consumer_disputed, complaint_id. Write a SQL query that shows the most frequently
-- reported issues within each product category. I want to see the top 5 issues per
-- product, ranked by complaint volume, so I can identify where specific pain points
-- are concentrated within each product type."

-- ITERATION NOTE: Claude generated a CTE with a RANK window function and a secondary
-- window function to calculate percentage of complaints within each product. Output
-- was reviewed and accepted without modification -- the structure correctly partitions
-- by product and ranks by volume within each partition.

-- INSIGHT: Incorrect information on credit reports dominates the credit reporting
-- category at 56% of complaints, with improper use of reports at 25% and investigation
-- problems at 18% -- together accounting for 99% of all credit reporting complaints.
-- In debt collection, attempts to collect debt not owed represents 45% of complaints,
-- suggesting a systemic issue with debt verification processes. Checking accounts show
-- a more distributed pattern across account management, closures, and unauthorized
-- charges, indicating broader service failure points rather than a single dominant issue.

WITH issue_counts AS (
    SELECT
        product,
        issue,
        COUNT(complaint_id)                                    AS complaint_count,
        RANK() OVER (
            PARTITION BY product
            ORDER BY COUNT(complaint_id) DESC
        )                                                      AS issue_rank
    FROM complaints
    WHERE issue IS NOT NULL
    GROUP BY product, issue
)
SELECT
    product,
    issue_rank,
    issue,
    complaint_count,
    ROUND(
        100.0 * complaint_count / SUM(complaint_count) OVER (PARTITION BY product),
        1
    )                                                          AS pct_of_product_complaints
FROM issue_counts
WHERE issue_rank <= 5
ORDER BY product, issue_rank;

-- ============================================================
-- QUERY 3: Company Response Distribution by Product Category
-- ============================================================

-- BUSINESS QUESTION: What is the distribution of company responses across each
-- product category -- specifically what percentage are closed with relief, closed
-- without relief, closed with explanation, still in progress, or other response
-- types?

-- PROMPT USED: "I have a PostgreSQL table called complaints with the following columns:
-- date_received, product, sub_product, issue, sub_issue, consumer_complaint_narrative,
-- company_public_response, company, state, zip_code, tags, consumer_consent_provided,
-- submitted_via, date_sent_to_company, company_response_to_consumer, timely_response,
-- consumer_disputed, complaint_id. Write a SQL query that shows the distribution of
-- company responses across each product category. I want to see how complaints are
-- being resolved -- specifically what percentage are closed with relief, closed without
-- relief, closed with explanation, still in progress, or any other response type --
-- broken down by product. Order by product and response volume descending."

-- ITERATION NOTE: Claude used a window function to calculate product-level totals
-- inline rather than requiring a separate subquery or CTE. Output was reviewed and
-- accepted without modification -- partitioning by product correctly calculates
-- percentages within each category rather than across the full dataset.

-- INSIGHT: Across almost all product categories, complaints are overwhelmingly closed
-- with explanation rather than monetary relief. Credit reporting stands out -- 44% of
-- complaints are closed with non-monetary relief, and only 0.02% result in monetary
-- relief, suggesting systemic resolution gaps where consumers receive acknowledgment
-- but little tangible outcome. Prepaid cards are a notable exception with 23% of
-- complaints resulting in monetary relief, the highest rate across all categories.
-- Untimely responses appear consistently across all products, indicating a widespread
-- SLA compliance issue rather than an isolated one.

SELECT
    product,
    company_response_to_consumer,
    COUNT(*)                                                        AS response_count,
    SUM(COUNT(*)) OVER (PARTITION BY product)                       AS product_total,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (PARTITION BY product),
        2
    )                                                               AS pct_of_product
FROM complaints
GROUP BY
    product,
    company_response_to_consumer
ORDER BY
    product,
    response_count DESC;

-- ============================================================
-- QUERY 4: Top 20 Companies by Complaint Volume and Timely Response Rate
-- ============================================================

-- BUSINESS QUESTION: Which companies generate the highest complaint volumes, and
-- are high volume companies also struggling with timely responses?

-- PROMPT USED: "I have a PostgreSQL table called complaints with the following columns:
-- date_received, product, sub_product, issue, sub_issue, consumer_complaint_narrative,
-- company_public_response, company, state, zip_code, tags, consumer_consent_provided,
-- submitted_via, date_sent_to_company, company_response_to_consumer, timely_response,
-- consumer_disputed, complaint_id. Write a SQL query that shows the top 20 companies
-- by total complaint volume, and for each company calculate their response rate --
-- specifically what percentage of their complaints received a timely response. Order
-- by total complaint volume descending so I can see which high volume companies are
-- also struggling with timely responses."

-- ITERATION NOTE: Claude used a CASE WHEN expression to convert the string timely_response
-- flag to binary 1/0 values before aggregating, avoiding the need for a subquery.
-- Claude also noted that COUNT(*) includes nulls in the denominator -- accepted this
-- approach as appropriate for the analysis. Output accepted without modification.

-- INSIGHT: The three credit bureaus -- Equifax, TransUnion, and Experian -- dominate
-- complaint volume by a significant margin, each exceeding 3.3 million complaints,
-- nearly 20x the volume of the next highest company. All three report near-perfect
-- timely response rates, suggesting complaint volume alone is not an indicator of
-- response quality. Bank of America is the notable outlier among traditional banks
-- with a 97.5% timely response rate -- the lowest in the top 20 -- combined with
-- 175,000 complaints, making it the highest operational risk profile among deposit
-- institutions in this dataset.

SELECT
    company,
    COUNT(*)                                                        AS total_complaints,
    SUM(CASE WHEN timely_response = 'Yes' THEN 1 ELSE 0 END)       AS timely_responses,
    ROUND(
        SUM(CASE WHEN timely_response = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        1
    )                                                               AS timely_response_pct
FROM complaints
GROUP BY company
ORDER BY total_complaints DESC
LIMIT 20;

-- ============================================================
-- QUERY 5: Monthly Complaint Volume Trends by Product Category
-- ============================================================

-- BUSINESS QUESTION: Are there seasonal or cyclical patterns in complaint volume --
-- specifically whether certain months consistently generate higher complaint volumes
-- than others across product types?

-- PROMPT USED: "I have a PostgreSQL table called complaints with the following columns:
-- date_received, product, sub_product, issue, sub_issue, consumer_complaint_narrative,
-- company_public_response, company, state, zip_code, tags, consumer_consent_provided,
-- submitted_via, date_sent_to_company, company_response_to_consumer, timely_response,
-- consumer_disputed, complaint_id. Write a SQL query that shows monthly complaint
-- volume trends across the full dataset, broken down by product category. I want to
-- identify whether there are seasonal or cyclical patterns in complaint volume --
-- specifically whether certain months consistently generate higher complaint volumes
-- than others across product types. Aggregate by month number and product, and order
-- by product and month."

-- ITERATION NOTE: Claude added a 5-row centered rolling average window function
-- (rolling_3mo_avg) that was not explicitly requested. This was reviewed and retained
-- because it adds legitimate analytical value -- smoothing noise while preserving
-- seasonal signal. Claude also added a pct_of_product_annual calculation to normalize
-- volume across products with very different complaint scales, enabling apples-to-apples
-- seasonal comparison. Both additions were accepted as improvements to the original
-- prompt scope.

-- INSIGHT: January is a consistently elevated complaint month across nearly all product
-- categories -- checking accounts show 13.4% of annual volume in January against an
-- expected 8.3%, student loans show 12.6%, and payday loans show 12.4%. This likely
-- reflects post-holiday financial stress and year-end billing disputes hitting resolution
-- queues simultaneously. Money transfer complaints show the most extreme January spike
-- at 34.3% of annual volume, dropping sharply to 8.3% in February, suggesting a
-- concentrated event-driven pattern rather than a gradual seasonal one -- consistent
-- with holiday fraud and scam activity. Q1 through Q2 represents a consistent
-- de-escalation period across most categories, with volumes stabilizing in Q3 and
-- beginning to rise again in Q4.

SELECT
    product,
    EXTRACT(MONTH FROM date_received)          AS month_number,
    TO_CHAR(DATE_TRUNC('month', date_received), 'Mon') AS month_name,
    COUNT(complaint_id)                        AS total_complaints,
    ROUND(COUNT(complaint_id) * 100.0
        / SUM(COUNT(complaint_id)) OVER (PARTITION BY product), 2)
                                               AS pct_of_product_annual,
    ROUND(AVG(COUNT(complaint_id))
        OVER (
            PARTITION BY product
            ORDER BY EXTRACT(MONTH FROM date_received)
            ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING
        ), 1)                                  AS rolling_3mo_avg
FROM
    complaints
WHERE
    date_received IS NOT NULL
GROUP BY
    product,
    EXTRACT(MONTH FROM date_received),
    TO_CHAR(DATE_TRUNC('month', date_received), 'Mon')
ORDER BY
    product,
    month_number;

-- ============================================================
-- QUERY 6: Worst Resolution Rates by Product and Issue Combination
-- ============================================================

-- BUSINESS QUESTION: Which product and issue combinations have the worst resolution
-- rates relative to their complaint volume? Where are consumers experiencing high
-- complaint frequency but receiving the least tangible relief?

-- PROMPT USED: "I have a PostgreSQL table called complaints with the following columns:
-- date_received, product, sub_product, issue, sub_issue, consumer_complaint_narrative,
-- company_public_response, company, state, zip_code, tags, consumer_consent_provided,
-- submitted_via, date_sent_to_company, company_response_to_consumer, timely_response,
-- consumer_disputed, complaint_id. Write a SQL query that identifies which product
-- and issue combinations have the worst resolution rates relative to their complaint
-- volume. Define resolution as a complaint being closed with monetary or non-monetary
-- relief. Use a CTE or subquery to first calculate the total complaint count and relief
-- rate per product and issue combination, then rank those combinations by complaint
-- volume and filter to only show combinations with significant volume -- at least 1000
-- complaints. Order the final output by relief rate ascending so the worst performing
-- combinations appear first."

-- ITERATION NOTE: Claude used ILIKE '%relief%' to capture both monetary and
-- non-monetary relief responses in a single pass rather than two separate CASE
-- conditions -- a cleaner approach than the query structure anticipated. Claude also
-- added a RANK() window function to show each combination's relative volume rank
-- alongside the relief rate, enabling volume and resolution quality to be read
-- together. Both additions were accepted. Claude flagged that ILIKE handles
-- case-insensitivity but recommended verifying exact field values in the data --
-- results confirmed the pattern matched correctly.

-- INSIGHT: Student loan complaints show catastrophically low relief rates across
-- every issue type -- improper use of report at 2.23%, investigation problems at
-- 2.46%, and struggling to repay at 3.19% -- despite tens of thousands of complaints.
-- This suggests student loan servicers are closing complaints procedurally rather
-- than substantively. Mortgage struggles to pay ranks third worst at 3.1% despite
-- 58,616 complaints, indicating that consumers in financial distress are receiving
-- explanations rather than meaningful intervention. Money transfer fraud complaints
-- show a 4.04% relief rate across nearly 69,000 complaints -- the highest volume
-- low-relief combination in the dataset -- pointing to a systemic gap between
-- fraud reporting and actual consumer recovery. In contrast, credit card late fees
-- and interest rate complaints resolve with relief at 63% and 47% respectively,
-- suggesting product type and issue category are stronger predictors of resolution
-- outcome than complaint volume alone.

WITH resolution_stats AS (
    SELECT
        product,
        issue,
        COUNT(*)                                                            AS total_complaints,
        SUM(
            CASE
                WHEN company_response_to_consumer ILIKE '%relief%'
                THEN 1
                ELSE 0
            END
        )                                                                   AS relief_count,
        ROUND(
            SUM(
                CASE
                    WHEN company_response_to_consumer ILIKE '%relief%'
                    THEN 1
                    ELSE 0
                END
            )::NUMERIC / COUNT(*) * 100,
            2
        )                                                                   AS relief_rate_pct
    FROM complaints
    GROUP BY product, issue
)

SELECT
    product,
    issue,
    total_complaints,
    relief_count,
    relief_rate_pct,
    RANK() OVER (ORDER BY total_complaints DESC)                            AS volume_rank
FROM resolution_stats
WHERE total_complaints >= 1000
ORDER BY relief_rate_pct ASC;