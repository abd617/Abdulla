CREATE university_professor table 
CREATE TABLE university_professor (
    firstname VARCHAR(200),
    lastname VARCHAR(200),
    university VARCHAR(200),
    university_shortname VARCHAR(200),
    university_city VARCHAR(200),
    function VARCHAR(200),
    organization VARCHAR(200),
    organization_sector VARCHAR(200)
);

-- Importing data into the university_professor table
COPY university_professor(firstname, lastname, university, university_shortname, university_city, function, organization, organization_sector)
FROM 'D:\uni\university_professor.csv'
DELIMITER ','
CSV HEADER;

-- Check data in the university_professor table
SELECT * FROM university_professor;

-- Normalization to 2NF

-- Step 1: Create the universities table 
CREATE TABLE universities (
    university_id SERIAL PRIMARY KEY,
    university VARCHAR(200) UNIQUE NOT NULL,
    university_shortname VARCHAR(200),
    university_city VARCHAR(200)
);

-- Step 2: Create the organizations table
CREATE TABLE organizations (
    organization_id SERIAL PRIMARY KEY,
    organization VARCHAR(200) UNIQUE NOT NULL,
    organization_sector VARCHAR(200)
);

-- Normalization to 3NF

-- Step 3: Create the professors table to store professor and function details
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    university_id INT REFERENCES universities(university_id) ON DELETE CASCADE,
    function VARCHAR(255),
    organization_id INT REFERENCES organizations(organization_id) ON DELETE CASCADE
);

-- Step 4: Insert unique universities into the universities table
INSERT INTO universities (university, university_shortname, university_city)
SELECT DISTINCT university, university_shortname, university_city
FROM university_professor;

-- Check data in the universities table
SELECT * FROM universities;

-- Step 5: Insert unique organizations into the organizations table
INSERT INTO organizations (organization, organization_sector)
SELECT DISTINCT organization, organization_sector
FROM university_professor;

-- Check data in the organizations table
SELECT * FROM organizations;

-- Step 6: Insert professor details into the professors table
INSERT INTO professors (firstname, lastname, university_id, function, organization_id)
SELECT 
    t.firstname,
    t.lastname,
    u.university_id,
    t.function,
    o.organization_id
FROM university_professor t
JOIN universities u ON t.university = u.university
JOIN organizations o ON t.organization = o.organization;

-- Check data in the professors table
SELECT * FROM professors;