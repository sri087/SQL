# Summarize Alcohol Tobacco and Firearms (ATF) publicly available licenses data

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

## Description

SQL Code to clean, enrich and summarize ATF license data into tables which can be exported for further analysis or visualization.

## Goals
1. Normalize the raw data into SQL tables
2. Enrich the data by JOIN-ing it with related tables
3. Generate summary statistics

---

- Normalize raw data

  The base data is available at the [ATF site](https://www.atf.gov/firearms/listing-federal-firearms-licensees). 
  Files in .xlsx or .txt format can be downloaded from this site; each file will contain licensee data per month every year, with the following fields. 

  Fields:
    - LIC_REGN: one of the nine US regions the license holder belongs to
    - LIC_DIST: the IRS district code of the license holder location
    - LIC_CNTY: the FIPS county code of the license holder location
    - LIC_TYPE: type of the Firearm license - check [this](https://www.atf.gov/resource-center/fact-sheet/fact-sheet-federal-firearms-and-explosives-licenses-types)
    - LIC_XPRDTE: license expiry date encoded as two characters - check [this](https://rocketffl.com/ffl-number/) for more info
    - LIC_SEQN: license sequence number
    - LICENSE_NAME: Name of individual or business holding the license
    - BUSINESS_NAME: Business name of the firm holding the license
    - PREMISE_STREET: Location of the business
    - PREMISE_CITY: Location of the business
    - PREMISE_STATE: 2-char state code of location of the business
    - PREMISE_ZIP_CODE: Location of the business (3 to 10 digits)
    - MAIL_STREET: Mailing location of the business
    - MAIL_CITY: Mailing location of the business
    - MAIL_STATE: Mailing location of the business
    - MAIL_ZIP_CODE: Mailing location of the business
    - VOICE_PHONE: Phone number


  Sample Data
  ![sample data](raw_data/Screenshot%20from%202022-06-03%2014-47-15.png)
  
  
  Only the business address fields are used for normalization and the mail fields are ignored. 
  The raw data is cleaned and loaded into a table per year of data with the name : atf_licenses_YYYY as in atf_licenses_2019 etc. 

  Each table will contain the same columns listed below:
     - data_year  : 4 digit year representing the year the data belongs to
     - region_id : 1 digit region code
     - irs_dist_code  : 3 digit IRS district code
     - fips_county_code : 3 digit FIPS county code
     - licensee_type_code : 2 character license type code
     - license_exp_date_code : 2 character license expiry date code
     - license_exp_month_code : 1 character license expiry month code (GENERATED)
     - license_seq_num : license seq num
     - licensee_name 
     - business_name 
     - business_street  
     - business_city 
     - business_state_code
     - business_zipcode
---
- Enrich the data 

  Four 'Lookup' tables are added each providing an additional tidbit of info to the raw data:

  - regions : region code and description
  - licensee_types : license_type code and description of the type
  - license_exp_month: exp_month code and the month to which it is mapped to (check [this](https://rocketffl.com/ffl-number/))
  - usa_states: state code with state names

---
- Summary Stats
  - Changes of number of fire arm licenses by year along with percentage of change between each year

    State
    ![state](https://drive.google.com/file/d/16P1tENwlKc3kYBXBL6lPRmIVEgjOJpQO/view?usp=sharing)

    Region
    ![region](raw_data/summary-stats-2.png)
  - Top 10 states per year with highest number of firearm licenses
  
    ![top10](raw_data/summary-stats-3.png)

  - Distribution of license types
  
    ![dist](raw_data/summary-stats-4.png)

---
## References

- ATF site : https://www.atf.gov
- Explanation of license fields : https://rocketffl.com/ffl-number/



## LICENSE

MIT License

Copyright (c)   2022    Srikanth Susarapu