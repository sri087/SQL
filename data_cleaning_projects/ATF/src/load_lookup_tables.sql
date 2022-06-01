-- SQL to load lookup/reference tables

-- Lookup data is sourced from 'https://www.atf.gov/resource-center/fact-sheet/fact-sheet-federal-firearms-and-explosives-licenses-types' 
--                        and  'https://rocketffl.com/ffl-number/'

-- REGIONS

DROP TABLE IF EXISTS regions;

CREATE TABLE regions (
    region_id smallint,
    region_name text,

    CONSTRAINT region_key PRIMARY KEY(region_id)
);

INSERT INTO regions VALUES
    (1,'Southeast'),
    (3,'Midwest'),
    (4,'Central'),
    (5,'Southwest'),
    (6,'North Atlantic'),
    (8,'Mid Atlantic'),
    (9,'Western');


-- FEDERAL FIREARM LICENSEE TYPES

DROP TABLE IF EXISTS licensee_types;

CREATE TABLE licensee_types (
    licensee_type_id char(2), 
    licensee_type_desc text,

    CONSTRAINT licensee_type_key PRIMARY KEY(licensee_type_id)
);

INSERT INTO licensee_types VALUES
    ('01','Dealer in Firearms Other Than Destructive Devices (Includes Gunsmiths)'),
    ('02','Pawnbroker in Firearms Other Than Destructive Devices'),
    ('03','Collector of Curios and Relics'),
    ('06','Manufacturer of Ammunition for Firearms'),
    ('07','Manufacturer of Firearms Other Than Destructive Devices'),
    ('08','Importer of Firearms Other Than Destructive Devices'),
    ('09','Dealer in Destructive Devices'),
    ('10','Manufacturer of Destructive Devices'),
    ('11','Importer of Destructive Devices');



-- FEDERAL FIREARM LICENSE EXPIRATION DATE

-- The expiration date of the FFL represented in two characters
-- The first character is the last number of the year the FFL expires. Therefore a 9 means that the FFL expires in 2019. 
-- There isn’t a risk of not knowing which decade the number refers to because FFLs are only valid for 3 years.

-- The second character is a letter representing the month of the year the FFL expires. The months and their corresponding letters (“I” is skipped) are:
-- A – January  B – February  C – March  D – April  E – May  F – June  G – July  H – August  J – September  K – October  L – November   M – December

DROP TABLE IF EXISTS license_exp_month;

CREATE TABLE license_exp_month (
    license_exp_mth_code char(1), 
    license_exp_mth text,
    
    CONSTRAINT license_exp_mth_code_key PRIMARY KEY(license_exp_mth_code)
);

INSERT INTO license_exp_month VALUES
    ('A','January'),
    ('B','February'),
    ('C','March'),
    ('D','April'),
    ('E','May'),
    ('F','June'),
    ('G','July'),
    ('H','August'),
    ('J','September'),
    ('K','October'),
    ('L','November'),
    ('M','December');


-- STATE CODES and NAMES

DROP TABLE IF EXISTS usa_states;

CREATE TABLE usa_states (
    state_code char(2), 
    state_name text,

    CONSTRAINT state_key PRIMARY KEY(state_code)
);

INSERT INTO licensee_types VALUES
    ('AL','Alabama'),
    ('AK','Alaska'),
    ('AZ','Arizona'),
    ('AR','Arkansas'),
    ('CA','California'),
    ('CO','Colorado'),
    ('CT','Connecticut'),
    ('DE','Delaware'),
    ('DC','District of Columbia'),
    ('FL','Florida'),
    ('GA','Georgia'),
    ('HI','Hawaii'),
    ('ID','Idaho'),
    ('IL','Illinois'),
    ('IN','Indiana'),
    ('IA','Iowa'),
    ('KS','Kansas'),
    ('KY','Kentucky'),
    ('LA','Louisiana'),
    ('ME','Maine'),
    ('MD','Maryland'),
    ('MA','Massachusetts'),
    ('MI','Michigan'),
    ('MN','Minnesota'),
    ('MS','Mississippi'),
    ('MO','Missouri'),
    ('MT','Montana'),
    ('NE','Nebraska'),
    ('NV','Nevada'),
    ('NH','New Hampshire'),
    ('NJ','New Jersey'),
    ('NM','New Mexico'),
    ('NY','New York'),
    ('NC','North Carolina'),
    ('ND','North Dakota'),
    ('OH','Ohio'),
    ('OK','Oklahoma'),
    ('OR','Oregon'),
    ('PA','Pennsylvania'),
    ('RI','Rhode Island'),
    ('SC','South Carolina'),
    ('SD','South Dakota'),
    ('TN','Tennessee'),
    ('TX','Texas'),
    ('UT','Utah'),
    ('VT','Vermont'),
    ('WA','Washington'),
    ('WV','West Virginia'),
    ('WI','Wisconsin'),
    ('WY','Wyoming')
    ;

SELECT * from usa_states;
SELECT * from regions;
SELECT * from licensee_types;
SELECT * from license_exp_month;