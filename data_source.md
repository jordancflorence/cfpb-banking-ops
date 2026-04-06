# Data Source: CFPB Consumer Complaint Database

## Source Name

Consumer Financial Protection Bureau (CFPB) Consumer Complaint Database

---

## Download URL

[https://www.consumerfinance.gov/data-research/consumer-complaints](https://www.consumerfinance.gov/data-research/consumer-complaints)

Select **"Download the data"** on that page. The full dataset is available as a CSV file. No account or registration is required.

---

## Dataset Description

This is a publicly available database of consumer complaints submitted to the CFPB against financial institutions operating in the United States. Records span from 2011 to the present and cover complaints related to products including mortgages, credit cards, student loans, auto loans, checking and savings accounts, credit reporting, debt collection, and more.

Each record includes the following fields (among others):

- Date received and date sent to company
- Product and sub-product type
- Issue and sub-issue category
- Company name
- State and ZIP code
- Submission channel (web, phone, referral, etc.)
- Company response type and timeliness
- Whether the consumer disputed the resolution
- A consumer narrative (where consent to publish was provided)

The dataset contains approximately **14.3 million records** as of the time this project was built.

---

## Approximate File Size

- CSV download: approximately **3.5 to 4.5 GB** depending on the version and whether consumer narratives are included

---

## Download Format

- CSV (comma-separated values)
- UTF-8 encoded
- Single flat file, no relational tables

---

## Importing into PostgreSQL

### Step 1: Create the target table

Run the following DDL in your PostgreSQL client before importing. Adjust column lengths if needed based on the version of the dataset you download.
```sql
CREATE TABLE cfpb_complaints (
    date_received           DATE,
    product                 TEXT,
    sub_product             TEXT,
    issue                   TEXT,
    sub_issue               TEXT,
    consumer_complaint_narrative TEXT,
    company_public_response TEXT,
    company                 TEXT,
    state                   VARCHAR(2),
    zip_code                VARCHAR(10),
    tags                    TEXT,
    consumer_consent_provided TEXT,
    submitted_via           TEXT,
    date_sent_to_company    DATE,
    company_response_to_consumer TEXT,
    timely_response         VARCHAR(3),
    consumer_disputed       VARCHAR(3),
    complaint_id            BIGINT PRIMARY KEY
);
```

### Step 2: Import the CSV

Using `psql`, run the following COPY command. Replace the file path with your actual local path.
```sql
\COPY cfpb_complaints FROM '/your/local/path/complaints.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    QUOTE '"',
    ENCODING 'UTF8'
);
```

On large files, this import may take several minutes depending on hardware. No indexes are required before import; add them after the load completes for better performance.

### Step 3: Add indexes (recommended)
```sql
CREATE INDEX idx_product ON cfpb_complaints (product);
CREATE INDEX idx_company ON cfpb_complaints (company);
CREATE INDEX idx_date_received ON cfpb_complaints (date_received);
CREATE INDEX idx_state ON cfpb_complaints (state);
```

---

## Notes

- The raw CSV is not included in this repository due to file size constraints.
- The dataset is updated regularly by the CFPB. The version used for this analysis was downloaded in early 2025.
- Consumer narratives are included in the full download but are not required for any queries in this project.
