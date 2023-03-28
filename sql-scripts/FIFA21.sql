-- USEFUL QUERIES FOR FAMILIARIZING THE TABLE THAT I CAN REUSE FROM TIME TO TIME

SELECT * FROM FIFA21..fifa21
ORDER BY ID 

-- Check Table Schema

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fifa21'

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'raw'

---------------------------------------------------------------------------------------
-- GOAL: CHECK DUPLICATES

ALTER TABLE FIFA21..fifa21
ADD countSimilarPlayer tinyint

-- Note: Consider a record as duplicate if another record contains
-- similar LongName, Age, and Nationality

WITH DuplicatesCTE AS(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY LongName, Age, Nationality ORDER BY ID) frequencyPlayer
FROM FIFA21..fifa21)

UPDATE FIFA21..fifa21
SET countSimilarPlayer = frequencyPlayer FROM DuplicatesCTE
						 WHERE DuplicatesCTE.ID = FIFA21..fifa21.ID

SELECT LongName, Nationality, Age, Club, Value, Wage, Height, Weight, countSimilarPlayer
FROM FIFA21..fifa21
WHERE countSimilarPlayer > 1

-- Findings: Duplicate entries where found for Players who shifted Clubs 

---------------------------------------------------------------------------------------
-- GOAL: DROP UNNECCESSARY COLUMNS

ALTER TABLE FIFA21..fifa21
DROP COLUMN photoUrl, playerUrl, Contract, Loan_Date_End,  Release_Clause

---------------------------------------------------------------------------------------
-- GOAL: CONVERT HEIGHTS TO CM

ALTER TABLE FIFA21..fifa21
ADD Is_height_in_cm VarChar(3),
	Height_cm tinyint

-- Check if there are instances where heights are not expressed in cm
UPDATE FIFA21..fifa21
SET Is_height_in_cm = CASE WHEN CHARINDEX('cm', Height) < 1 THEN 'No'
						   ELSE 'Yes'
						   END

-- Actual Conversion of heights
UPDATE FIFA21..fifa21
SET Height_cm = CASE WHEN Is_height_in_cm = 'Yes' THEN CAST(REPLACE(Height, 'cm', '') AS tinyint)
					 ELSE CAST(SUBSTRING(Height, 1, CHARINDEX('''', Height) - 1) AS tinyint) * 30.48 + 
						  CAST(SUBSTRING(Height, CHARINDEX('''', Height) + 1, LEN(Height) - CHARINDEX('''', Height) - 1) AS tinyint) * 2.54
					 END

---------------------------------------------------------------------------------------
-- GOAL: CONVERT WEIGHTS TO KG

ALTER TABLE FIFA21..fifa21
ADD Is_weight_in_kg VarChar(3),
	Weight_kg tinyint

-- Check if there are instances where weights are not expressed in kg
UPDATE FIFA21..fifa21
SET Is_weight_in_kg = CASE WHEN CHARINDEX('kg', Weight) > 0 THEN 'Yes'
						   ELSE 'No'
						   END 

-- Actual Conversion of weights to kg
UPDATE FIFA21..fifa21
SET Weight_kg = CASE WHEN Is_weight_in_kg = 'Yes' THEN CAST(REPLACE(Weight, 'kg', '') AS tinyint)
					 ELSE CAST(REPLACE(Weight, 'lbs', '') AS tinyint) * 0.45359237
					 END

---------------------------------------------------------------------------------------
-- GOAL: CONVERT VALUE FROM VARCHAR to FLOAT

ALTER TABLE FIFA21..fifa21
ADD Value_Num float,
	Value_No_Curr VarChar(10)


UPDATE FIFA21..fifa21
SET Value_No_Curr = REPLACE(Value, '€', '');


UPDATE FIFA21..fifa21
SET Value_Num = CASE WHEN RIGHT(Value, 1) = 'M' THEN CAST(REPLACE(Value_No_Curr, 'M','') AS float)*1000000
					 WHEN RIGHT(Value, 1) = 'K' THEN CAST(REPLACE(Value_No_Curr, 'K','') AS float)*1000
					 ELSE CAST(0 as float)
					 END 


---------------------------------------------------------------------------------------
-- GOAL: CONVERT WAGE TO FLOAT

ALTER TABLE FIFA21..fifa21
ADD Wage_Num float,
	Wage_No_Curr VarChar(10)

UPDATE FIFA21..fifa21
SET Wage_No_Curr = REPLACE(Wage, '€', '')

UPDATE FIFA21..fifa21
SET	Wage_Num = CASE WHEN RIGHT(WAGE, 1) = 'K' THEN CAST(REPLACE(Wage_No_Curr, 'K', '') AS float) * 1000
					WHEN RIGHT(WAGE, 1) = '0' THEN CAST(0 AS float)
					END

---------------------------------------------------------------------------------------
-- GOAL: DROP THE STAR SYMBOL IN THE W_F, SM, AND IR entries

UPDATE FIFA21..fifa21
SET W_F = LEFT(W_F, LEN(W_F)-1),
	SM = LEFT(SM, LEN(SM)-1),
	IR = LEFT(IR, LEN(IR)-1)

UPDATE FIFA21..fifa21
SET W_F = CAST(W_F AS tinyint),
	SM = CAST(SM AS tinyint),
	IR = CAST(IR AS tinyint)

---------------------------------------------------------------------------------------
-- GOAL: FOR PLAYERS NOT ASSOCIATED WITH CLUBS, CHANGE 'No Club' to NULL

UPDATE FIFA21..fifa21
SET Club = CASE WHEN Club = 'No Club' THEN ''
				ELSE Club
				END
---------------------------------------------------------------------------------------
-- GOAL 1: REMOVE UNNECESSARY COLUMNS
-- GOAL 2: RENAME Wage_num and Value_num

SELECT * FROM FIFA21..fifa21

ALTER TABLE FIFA21..fifa21
DROP COLUMN Height, Weight, Is_height_in_cm, Is_weight_in_kg, Wage_No_Curr, Wage, Value, Value_No_Curr

EXEC sp_rename 'dbo.fifa21.Wage_num', 'Wage_euro', 'COLUMN'
EXEC sp_rename 'dbo.fifa21.Value_num', 'Value_euro', 'COLUMN'


---------------------------------------------------------------------------------------
-- DATA EXPLORATION

-- GOAL: RANK THE CLUBS BASED ON THE TOTAL STATS OF THEIR PLAYERS

SELECT Club, SUM(Total_Stats) Club_Total_Stats
FROM FIFA21..fifa21
WHERE Club != '' AND 
	  countSimilarPlayer = 1
	  AND Wage_euro != 0
GROUP BY Club
ORDER BY Club_Total_Stats DESC

---------------------------------------------------------------------------------------

-- GOAL: FIND THE TOP 10 PLAYERS BASED ON THEIR OVA

SELECT TOP (10) LongName, Club, Best_Position, OVA, Total_Stats, Wage_euro
FROM FIFA21..fifa21
WHERE countSimilarPlayer = 1 AND
	  Wage_euro != 0
ORDER BY OVA DESC

---------------------------------------------------------------------------------------

-- GOAL: FIND THE MEDIAN WAGE OF PLAYERS

SELECT MIN(Wage_euro) Median FROM(
	SElECT TOP 50 PERCENT LongName, Wage_euro
	FROM FIFA21..fifa21
	WHERE countSimilarPlayer = 1 AND
		  Wage_euro != 0
	ORDER BY Wage_euro DESC
)subquery

---------------------------------------------------------------------------------------

-- GOAL: FIND THE AVERAGE WAGE OF PLAYERS

SELECT ROUND(AVG(Wage_euro),0)  Average_Wage
FROM FIFA21..fifa21
WHERE countSimilarPlayer = 1
AND Wage_euro != 0

---------------------------------------------------------------------------------------

-- GOAL: DETERMINE WHICH POSITIONS ARE PAID THE MOST

ALTER TABLE FIFA21..fifa21
ADD Position_Group varchar(15)

UPDATE FIFA21..fifa21
SET Position_Group  = CASE WHEN Best_Position IN ('LB', 'LWB', 'CB', 'SW', 'RB', 'RWB') THEN 'Defenders'
						   WHEN Best_Position IN ('LM', 'CM', 'CDM', 'CAM', 'CM', 'RM') THEN 'Midfielders'
						   WHEN Best_Position IN ('LW', 'ST', 'CF', 'ST', 'RW') THEN 'Forwards'
						   WHEN Best_Position IN ('GK') THEN 'Goalkeeper'
						   ELSE NULL
						   END

SELECT DISTINCT Best_Position,
Position_Group,
ROUND(AVG(Wage_Euro) OVER(PARTITION BY Best_Position),0) Pos_Mean_Wage,
COUNT(Best_Position) OVER(PARTITION BY Best_Position) Pos_Quantity
FROM FIFA21..fifa21
WHERE countSimilarPlayer = 1 AND
	  Wage_Euro != 0
ORDER BY Pos_Mean_Wage DESC

-- Findings: 1) Generally, forwards are paid highest, followed by midfielders and then defenders. 
--              Goalkeepers are paid the least
-- Findings: 2) The highest paid positions (forwards) have the least number of players across the league

---------------------------------------------------------------------------------------

-- GOAL: DETERMINE DISTRIBUTION OF WAGE ACCROSS AGE PER POSITION

WITH AgeGroupCTE AS(
	SELECT Position_Group, Wage_Euro, 
	(CASE WHEN Age BETWEEN 15 AND 20 THEN '15 - 20'
		 WHEN Age BETWEEN 20 AND 25 THEN '20 - 25'
		 WHEN Age BETWEEN 25 AND 30 THEN '25 - 30'
		 WHEN Age BETWEEN 30 AND 35 THEN '30 - 35'
		 WHEN Age BETWEEN 35 AND 40 THEN '35 - 40'
		 WHEN Age BETWEEN 40 AND 45 THEN '40 - 45'
		 END) Age_Group
	FROM FIFA21..fifa21
	WHERE countSimilarPlayer = 1 AND
		  Wage_euro != 0
)

SELECT DISTINCT
Position_Group, 
Age_Group,
ROUND(AVG(Wage_Euro) OVER(PARTITION BY Position_Group, Age_Group),0) Mean_Wage_Per_Age_Group
FROM AgeGroupCTE
ORDER BY Position_Group, Age_Group

---------------------------------------------------------------------------------------
/* SELECT LongName, Age, OVA, Club, Wage_euro     -- Findings: The 20K average salary for Defenders with age 40-45
FROM FIFA21..fifa21											   is an outlier (not reliable) since the sample size is
WHERE (Age BETWEEN 40 AND 45) AND								only 1
	   Position_Group = 'Defenders' AND
	   Wage_euro != 0
*/

Select * FROM FIFA21..raw
WHERE Height NOT LIKE '%cm%'