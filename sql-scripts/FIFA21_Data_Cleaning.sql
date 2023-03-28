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
