-- DATA EXPLORATION

---------------------------------------------------------------------------------------
--GOAL: QUERY THE INDIVIDUAL SALARY AND OVA RATING OF ALL PLAYERS

SELECT LongName, Wage_euro, OVA
FROM FIFA21..fifa21
WHERE countSimilarPlayer = 1 AND
	  Wage_euro != 0
ORDER BY OVA DESC


---------------------------------------------------------------------------------------
-- GOAL: FIND THE TOP 10 PLAYERS BASED ON THEIR OVA

SELECT TOP (10) LongName, Club, Best_Position, OVA, Wage_euro
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
-- GOAL 1: ASSIGN TAPPROPRIATE GROUP TO EACH POSITION 
--         LB, LWB, CB, SW, RB, and RWB are Defenders
--		   LM, CM, CDM, CAM, CM, RM are Midfielders
--         LW, ST, CF, ST, RW are Forwards
--		   GK = Goalkeeper
-- GOAL2 : DETERMINE THE RANKING OF POSITION GROUPS IN TERMS OF EARNING CAPACITY

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
-- GOAL 1: CATAEGORIZE INDIVIDUAL AGES INTO AGE GROUPS
-- GOAL 2: DETERMINE DISTRIBUTION OF WAGE ACCROSS AGE PER POSITION GROUP

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

/*
-- GOAL: RANK THE CLUBS BASED ON THE TOTAL STATS OF THEIR PLAYERS

SELECT Club, SUM(Total_Stats) Club_Total_Stats
FROM FIFA21..fifa21
WHERE Club != '' AND 
	  countSimilarPlayer = 1
	  AND Wage_euro != 0
GROUP BY Club
ORDER BY Club_Total_Stats DESC
*/