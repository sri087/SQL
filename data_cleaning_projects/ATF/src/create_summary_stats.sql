-- After the raw data is loaded , we have data per year in tables atf_licenses_<YYYY> from 2018 to 2022
-- containing the following columns
--
-- id	data_year	region_id	irs_dist_code	fips_county_code	licensee_type_code	license_exp_date_code	license_exp_month_code	license_seq_num	licensee_name	business_name	business_street	business_city	business_state_code	business_zipcode

-- Determine the percent change in the number of licensees year to year
--

-- Helper function to compute percent change

CREATE OR REPLACE FUNCTION pct_change(old_number numeric, new_number numeric, no_of_decimals integer DEFAULT 1) 
RETURNS numeric AS
   'SELECT round(((new_number - old_number) / old_number) * 100,no_of_decimals);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL on NULL INPUT;


-- -- per region

        CREATE VIEW st_region_2018 AS
        SELECT region_id,count(*) AS count_2018 FROM atf_licenses_2018 GROUP BY region_id ORDER BY 2 DESC;
   
        CREATE VIEW st_region_2019 AS
        SELECT region_id,count(*) AS count_2019 FROM atf_licenses_2019 GROUP BY region_id ORDER BY 2 DESC;

        CREATE VIEW st_region_2020 AS
        SELECT region_id,count(*) AS count_2020 FROM atf_licenses_2020 GROUP BY region_id ORDER BY 2 DESC;

        CREATE VIEW st_region_2021 AS
        SELECT region_id,count(*) AS count_2021 FROM atf_licenses_2021 GROUP BY region_id ORDER BY 2 DESC;

        CREATE VIEW st_region_2022 AS
        SELECT region_id,count(*) AS count_2022 FROM atf_licenses_2022 GROUP BY region_id ORDER BY 2 DESC;

        CREATE TABLE atf_licensee_summary_by_region AS
            SELECT reg.region_name, a.count_2018, b.count_2019,c.count_2020,d.count_2021,e.count_2022,
                pct_change(a.count_2018, b.count_2019,3) as pct_change_1819,
                pct_change(b.count_2019, c.count_2020,3) as pct_change_1920,
                pct_change(c.count_2020, d.count_2021,3) as pct_change_2021,
                pct_change(d.count_2021, e.count_2022,3) as pct_change_2022
            FROM st_region_2018 a 
                INNER JOIN st_region_2019 b 
                ON a.region_id  = b.region_id
                INNER JOIN st_region_2020 c
                ON b.region_id  = c.region_id
                INNER JOIN st_region_2021 d
                ON c.region_id  = d.region_id
                INNER JOIN st_region_2022 e
                ON d.region_id  = e.region_id
                INNER JOIN regions reg
                ON e.region_id = reg.region_id

            ORDER BY reg.region_id ASC;
        
        -- remove views
        DROP VIEW st_region_2018;
        DROP VIEW st_region_2019;
        DROP VIEW st_region_2020;
        DROP VIEW st_region_2021;
        DROP VIEW st_region_2022;


-- -- per state

        CREATE VIEW st_state_2018 AS
        SELECT business_state_code,count(*) AS count_2018 FROM atf_licenses_2018 GROUP BY business_state_code ORDER BY 2 DESC;
   
        CREATE VIEW st_state_2019 AS
        SELECT business_state_code,count(*) AS count_2019 FROM atf_licenses_2019 GROUP BY business_state_code ORDER BY 2 DESC;

        CREATE VIEW st_state_2020 AS
        SELECT business_state_code,count(*) AS count_2020 FROM atf_licenses_2020 GROUP BY business_state_code ORDER BY 2 DESC;

        CREATE VIEW st_state_2021 AS
        SELECT business_state_code,count(*) AS count_2021 FROM atf_licenses_2021 GROUP BY business_state_code ORDER BY 2 DESC;

        CREATE VIEW st_state_2022 AS
        SELECT business_state_code,count(*) AS count_2022 FROM atf_licenses_2022 GROUP BY business_state_code ORDER BY 2 DESC;


        CREATE TABLE atf_licensee_summary_by_state AS
            SELECT a.business_state_code,usa_states.state_name, a.count_2018, b.count_2019,c.count_2020,d.count_2021,e.count_2022,
                pct_change(a.count_2018, b.count_2019,3) as pct_change_1819,
                pct_change(b.count_2019, c.count_2020,3) as pct_change_1920,
                pct_change(c.count_2020, d.count_2021,3) as pct_change_2021,
                pct_change(d.count_2021, e.count_2022,3) as pct_change_2022
            FROM st_state_2018 a 
                INNER JOIN st_state_2019 b 
                ON a.business_state_code  = b.business_state_code
                INNER JOIN st_state_2020 c
                ON b.business_state_code  = c.business_state_code
                INNER JOIN st_state_2021 d
                ON c.business_state_code  = d.business_state_code
                INNER JOIN st_state_2022 e
                ON d.business_state_code  = e.business_state_code
                INNER JOIN usa_states
                ON e.business_state_code = usa_states.state_code

            ORDER BY a.business_state_code ASC;
        
        -- remove temporary tables
        DROP VIEW st_state_2018;
        DROP VIEW st_state_2019;
        DROP VIEW st_state_2020;
        DROP VIEW st_state_2021;
        DROP VIEW st_state_2022;
