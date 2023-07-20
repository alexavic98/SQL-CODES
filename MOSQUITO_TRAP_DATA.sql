CREATE DATABASE SQL_PRACTICE;
USE SQL_PRACTICE;

CREATE TABLE MOSQUITO_TRAP_DATA (
  SAMPLEID INTEGER PRIMARY KEY AUTO_INCREMENT,
  TRAP_DATE DATE,
  GENUS TEXT,
  SPECIES TEXT,
  TYPE TEXT,
  GENDER TEXT,
  RURALNORTHWEST INTEGER,
  RURALNORTHEAST INTEGER,
  RURALSOUTHEAST INTEGER,
  RIVERVALLEYEAST INTEGER,
  RIVERVALLEYWEST INTEGER,
  RESIDENTIALNORTH INTEGER,
  RURALSOUTHWEST INTEGER,
  LAGOON INTEGER,
  GOLFCOURSE INTEGER,
  INDUSTRIALPARK INTEGER,
  RESIDENTIALSOUTH INTEGER,
  TOTAL INTEGER
);

INSERT INTO MOSQUITO_TRAP_DATA (TRAP_DATE, GENUS, SPECIES, TYPE, GENDER, RURALNORTHWEST,
  RURALNORTHEAST, RURALSOUTHEAST, RIVERVALLEYEAST, RIVERVALLEYWEST, RESIDENTIALNORTH,
  RURALSOUTHWEST, LAGOON, GOLFCOURSE, INDUSTRIALPARK, RESIDENTIALSOUTH, TOTAL)
VALUES ('2023-07-20', 'Culex', 'pipiens', 'Brown legs', 'Male', 5, 2, 3, 1, 0, 0, 2, 0, 1, 0, 0, 14);

INSERT INTO MOSQUITO_TRAP_DATA (TRAP_DATE, GENUS, SPECIES, TYPE, GENDER, RURALNORTHWEST,
  RURALNORTHEAST, RURALSOUTHEAST, RIVERVALLEYEAST, RIVERVALLEYWEST, RESIDENTIALNORTH,
  RURALSOUTHWEST, LAGOON, GOLFCOURSE, INDUSTRIALPARK, RESIDENTIALSOUTH, TOTAL)
VALUES ('2023-07-20', 'Anopheles', 'quadrimaculatus', 'White legs', 'Female', 3, 1, 2, 0, 1, 0, 0, 0, 0, 0, 1, 8);

INSERT INTO MOSQUITO_TRAP_DATA (TRAP_DATE, GENUS, SPECIES, TYPE, GENDER, RURALNORTHWEST,
  RURALNORTHEAST, RURALSOUTHEAST, RIVERVALLEYEAST, RIVERVALLEYWEST, RESIDENTIALNORTH,
  RURALSOUTHWEST, LAGOON, GOLFCOURSE, INDUSTRIALPARK, RESIDENTIALSOUTH, TOTAL)
VALUES ('2023-07-20', 'Aedes', 'albopictus', 'Black legs', 'Female', 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 3);
INSERT INTO MOSQUITO_TRAP_DATA (TRAP_DATE, GENUS, SPECIES, TYPE, GENDER, RURALNORTHWEST,
  RURALNORTHEAST, RURALSOUTHEAST, RIVERVALLEYEAST, RIVERVALLEYWEST, RESIDENTIALNORTH,
  RURALSOUTHWEST, LAGOON, GOLFCOURSE, INDUSTRIALPARK, RESIDENTIALSOUTH, TOTAL)
VALUES ('2023-07-20', 'Culex', 'quinquefasciatus', 'Brown legs', 'Male', 10, 5, 8, 3, 2, 1, 5, 0, 0, 1, 2, 37);

INSERT INTO MOSQUITO_TRAP_DATA (TRAP_DATE, GENUS, SPECIES, TYPE, GENDER, RURALNORTHWEST,
  RURALNORTHEAST, RURALSOUTHEAST, RIVERVALLEYEAST, RIVERVALLEYWEST, RESIDENTIALNORTH,
  RURALSOUTHWEST, LAGOON, GOLFCOURSE, INDUSTRIALPARK, RESIDENTIALSOUTH, TOTAL)
VALUES ('2023-07-20', 'Anopheles', 'arabiensis', 'White legs', 'Female', 2, 3, 1, 0, 1, 0, 0, 0, 0, 0, 0, 7);

INSERT INTO MOSQUITO_TRAP_DATA (TRAP_DATE, GENUS, SPECIES, TYPE, GENDER, RURALNORTHWEST,
  RURALNORTHEAST, RURALSOUTHEAST, RIVERVALLEYEAST, RIVERVALLEYWEST, RESIDENTIALNORTH,
  RURALSOUTHWEST, LAGOON, GOLFCOURSE, INDUSTRIALPARK, RESIDENTIALSOUTH, TOTAL)
VALUES ('2023-07-20', 'Aedes', 'aegypti', 'Banded legs', 'Male', 1, 2, 0, 0, 1, 1, 0, 0, 0, 0, 1, 6);

SELECT SPECIES, SUM(TOTAL) AS TotalCount
FROM MOSQUITO_TRAP_DATA
GROUP BY SPECIES;

SELECT GENUS, GENDER, SUM(TOTAL) AS TotalCount
FROM MOSQUITO_TRAP_DATA
GROUP BY GENUS, GENDER;

SELECT TRAP_DATE, MAX(TOTAL) AS MaxCount
FROM MOSQUITO_TRAP_DATA;

SELECT SPECIES, SUM(TOTAL) AS TotalCount
FROM MOSQUITO_TRAP_DATA
GROUP BY SPECIES
ORDER BY TotalCount DESC
LIMIT 5;

SELECT
    TRAP_DATE,
    SUM(RURALNORTHWEST + RURALNORTHEAST + RURALSOUTHEAST + RIVERVALLEYEAST +
        RIVERVALLEYWEST + RESIDENTIALNORTH + RURALSOUTHWEST + LAGOON +
        GOLFCOURSE + INDUSTRIALPARK + RESIDENTIALSOUTH) AS TotalCount
FROM MOSQUITO_TRAP_DATA
GROUP BY TRAP_DATE;

UPDATE MOSQUITO_TRAP_DATA
SET GENDER = 'Male'
WHERE SAMPLEID IN (1,3,5,7);

DELETE FROM
MOSQUITO_TRAP_DATA WHERE
GENDER = "female";
