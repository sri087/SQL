-- Create TEMP table to hold raw data
-- Load one year's data into the temp table, clean it and load into permanent table
-- Repeat until all years' data is cleaned and loaded. 

DROP TABLE IF EXISTS raw_data_temp;

CREATE TABLE raw_data_temp (

    region smallint, 
    irs_dist text,
    county_fips_code text,
    license_type_code text,
    license_exp_date text, 
    license_seq text, 
    licensee_name text,
    business_name text, 
    bus_street text, 
    bus_city text, 
    bus_state text, 
    bus_zipcode text,
    mail_street text, 
    mail_city text, 
    mail_state text, 
    mail_zipcode text,
    phone text
    
);

COPY raw_data_temp(region, irs_dist,county_fips_code,license_type_code,license_exp_date,
                   license_seq,licensee_name,business_name,bus_street,bus_city,bus_state,bus_zipcode,
                   mail_street,mail_city,mail_state,mail_zipcode,phone)
FROM '/home/sri/Documents/SQL/data_cleaning_projects/ATF/raw_data/0118-ffl-list.csv'
WITH (FORMAT CSV, HEADER);


-- BACKUP LOADED DATA
CREATE TABLE raw_data_temp_backup AS SELECT * FROM raw_data_temp;


-- CLEAN DATA

-- We intend to clean only the business address
-- The mail address will be discarded while loading into the permanent table

-- Remove rows where the license_exp_date is not of the format [number][letter]
DELETE FROM raw_data_temp 
WHERE (left(license_exp_date,1) ~* '[A-Z]') is true OR (right(license_exp_date,1) ~* '[0-9]') is true

-- The raw import has created 'NULL' strings instead of empty business names
-- Set Business name to licensee name if NULL
UPDATE raw_data_temp 
SET business_name = licensee_name
WHERE business_name = 'NULL' OR busines_name IS NULL;

-- Check if we have different lengths of zip code
SELECT length(bus_zipcode), count(*) AS length_count
FROM raw_data_temp 
GROUP BY 1
ORDER BY 1 ASC;

-- We dont need more than the first 5 digits of zip code, so truncate it
UPDATE raw_data_temp 
SET bus_zipcode = substr(bus_zipcode,1,5);

-- Extract license expiry month from the exp date into a separate column
ALTER TABLE raw_data_temp ADD COLUMN lic_exp_month char(1);

UPDATE raw_data_temp
SET lic_exp_month = right(license_exp_date,1);


-- LOAD DATA

-- Load all cleaned columns into permanent table
-- Mark the rows with the year 

-- Normalization is achieved through the CONSTRAINTS  

DROP TABLE IF EXISTS atf_licenses_2018

CREATE TABLE atf_licenses_2018 (

    id bigint GENERATED ALWAYS AS IDENTITY,
    data_year numeric(4) NOT NULL,
    region_id smallint NOT NULL,
    irs_dist_code text, 
    fips_county_code text,
    licensee_type_code char(2) NOT NULL, 
    license_exp_date_code char(2),
    license_exp_month_code char(1), 
    license_seq_num text NOT NULL,
    licensee_name text,
    business_name text, 
    business_street text, 
    business_city text, 
    business_state_code char(2) NOT NULL, 
    business_zipcode text,

    CONSTRAINT atf_license_key PRIMARY KEY (id),
    CONSTRAINT region_fkey FOREIGN KEY(region_id) REFERENCES regions(region_id),
    CONSTRAINT licensee_type_fkey FOREIGN KEY(licensee_type_code) REFERENCES licensee_types(licensee_type_id),
    CONSTRAINT license_exp_month_code_fkey FOREIGN KEY(license_exp_month_code) REFERENCES license_exp_month(license_exp_mth_code),
    CONSTRAINT business_state_code_fkey FOREIGN KEY(business_state_code) REFERENCES usa_states(state_code)

);


INSERT INTO atf_licenses_2018 (
    data_year,region_id,irs_dist_code,fips_county_code,licensee_type_code,license_exp_date_code,license_exp_month_code, 
    license_seq_num,licensee_name,business_name,business_street,business_city,business_state_code,business_zipcode
)
SELECT 2018, region,irs_dist,county_fips_code,license_type_code,license_exp_date,lic_exp_month,
       license_seq,licensee_name,business_name,bus_street,bus_city,bus_state,bus_zipcode
FROM raw_data_temp;


-- COMPARE COUNTS OF BOTH TABLES
select count(*) from raw_data_temp;
select count(*) from atf_licenses_2018;