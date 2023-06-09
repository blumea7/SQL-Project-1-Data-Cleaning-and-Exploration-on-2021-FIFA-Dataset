# SQL-Project-1-Data-Cleaning-and-Exploration-on-2021-FIFA-Dataset

### Raw File
__________________________________________________________________________________________________________________________________________________________
The file containing the messy and raw 2021 FIFA Dataset can be downloaded [here](https://www.kaggle.com/datasets/yagunnersya/fifa-21-messy-raw-dataset-for-cleaning-exploring).

Here's a preview of the raw dataset:

| ID   | Name            | LongName             | photoUrl                                         | playerUrl                                                  | Nationality | Height | Weight | Wage | Value | Age | OVA | POT | Club        | Contract    | Positions | Preferred_Foot | BOV | Best_Position | Joined     | Loan_Date_End | Release_Clause | Attacking | Crossing | Finishing | Heading_Accuracy | Short_Passing | Volleys | Skill | Dribbling | Curve | FK_Accuracy | Long_Passing | Ball_Control | Movement | Acceleration | Sprint_Speed | Agility | Reactions | Balance | Power | Shot_Power | Jumping | Stamina | Strength | Long_Shots | Mentality | Aggression | Interceptions | Positioning | Vision | Penalties | Composure | Defending | Marking | Standing_Tackle | Sliding_Tackle | Goalkeeping | GK_Diving | GK_Handling | GK_Kicking | GK_Positioning | GK_Reflexes | Total_Stats | Base_Stats | W_F | SM | A_W    | D_W    | IR  | PAC | SHO | PAS | DRI | DEF | PHY | Hits |
|------|-----------------|----------------------|--------------------------------------------------|------------------------------------------------------------|-------------|--------|--------|------|-------|-----|-----|-----|-------------|-------------|-----------|----------------|-----|---------------|------------|---------------|----------------|-----------|----------|-----------|------------------|---------------|---------|-------|-----------|-------|-------------|--------------|--------------|----------|--------------|--------------|---------|-----------|---------|-------|------------|---------|---------|----------|------------|-----------|------------|---------------|-------------|--------|-----------|-----------|-----------|---------|-----------------|----------------|-------------|-----------|-------------|------------|----------------|-------------|-------------|------------|-----|----|--------|--------|-----|-----|-----|-----|-----|-----|-----|------|
| 41   | Iniesta         | Andrés Iniesta Luján | https://cdn.sofifa.com/players/000/041/21_60.png | http://sofifa.com/player/41/andres-iniesta-lujan/210006/   | Spain       | 171cm  | 68kg   | €12K | €8M   | 36  | 81  | 81  | Vissel Kobe | 2018 ~ 2021 | CM, CAM   | Right          | 82  | CAM           | 16/07/2018 | NULL          | €7.2M          | 367       | 75       | 69        | 54               | 90            | 79      | 408   | 85        | 80    | 70          | 83           | 90           | 346      | 61           | 56           | 79      | 75        | 75      | 297   | 67         | 40      | 58      | 62       | 70         | 370       | 58         | 70            | 78          | 93     | 71        | 89        | 181       | 68      | 57              | 56             | 45          | 6         | 13          | 6          | 13             | 7           | 2014        | 420        | 4 ★ | 4★ | High   | Medium | 4 ★ | 58  | 70  | 85  | 85  | 63  | 59  | 130  |
| 1179 | G. Buffon       | Gianluigi Buffon     | https://cdn.sofifa.com/players/001/179/21_60.png | http://sofifa.com/player/1179/gianluigi-buffon/210006/     | Italy       | 192cm  | 92kg   | €41K | €3.4M | 42  | 82  | 82  | Juventus    | 2019 ~ 2021 | GK        | Right          | 82  | GK            | 04/07/2019 | NULL          | €3.6M          | 95        | 13       | 15        | 13               | 37            | 17      | 122   | 26        | 20    | 13          | 35           | 28           | 251      | 37           | 30           | 55      | 80        | 49      | 243   | 56         | 71      | 34      | 69       | 13         | 150       | 38         | 28            | 12          | 50     | 22        | 70        | 35        | 13      | 11              | 11             | 396         | 77        | 76          | 74         | 91             | 78          | 1292        | 429        | 2 ★ | 1★ | Medium | Medium | 4 ★ | 77  | 76  | 74  | 78  | 33  | 91  | 131  |
| 2147 | M. Stekelenburg | Maarten Stekelenburg | https://cdn.sofifa.com/players/002/147/21_60.png | http://sofifa.com/player/2147/maarten-stekelenburg/210006/ | Netherlands | 197cm  | 92kg   | €6K  | €250K | 37  | 72  | 72  | Ajax        | 2020 ~ 2021 | GK        | Right          | 72  | GK            | 05/08/2020 | NULL          | €455K          | 93        | 18       | 11        | 14               | 39            | 11      | 106   | 12        | 13    | 13          | 37           | 31           | 192      | 30           | 36           | 30      | 69        | 27      | 224   | 54         | 55      | 27      | 77       | 11         | 142       | 41         | 26            | 12          | 40     | 23        | 59        | 38        | 9       | 15              | 14             | 355         | 69        | 71          | 72         | 73             | 70          | 1150        | 388        | 4 ★ | 1★ | Medium | Medium | 2 ★ | 69  | 71  | 72  | 70  | 33  | 73  | 23   |

### SQL Techniques & Skills used in this Project
__________________________________________________________________________________________________________________________________________________________

    1. Altered tables by making use of ADD and DROP functions
      
    2. Updated values in columns using UPDATE function in combination with CASE WHEN logic 
      
    3. Modified string values using functions such as CHARINDEX, CAST, SUBSTRING, REPLACE, RIGHT and LEFT.
      
    4. Utilized WITH clause and Subqueries to perform complex queries
      
    5. Utilized Aggregate and Window functions to perform data explorations


### Data Cleaning
__________________________________________________________________________________________________________________________________________________________
See data cleaning SQL script [here](https://github.com/blumea7/SQL-Project-1-Data-Cleaning-and-Exploration-on-2021-FIFA-Dataset/blob/main/sql-scripts/FIFA21_Data_Cleaning.sql). 

The following steps were performed to clean the data:


    1. Check duplicate entries (A row instance is considered duplicate when it has similar 
       LongName, Age, and Nationality values with another row instance).
       
    2. Drop unnecessary columns (photoUrl, playerUrl, Contract, Loan_Date_End,  Release_Clause were dropped as they
       will not be beneficial for our data cleaning and data exploration agenda).
        
    3. Express all heights in cm and convert data type to tinyint (Originally, Some heights are expressed in 
       ft-in and the column datatype is nvarchar).
    
    4. Express all weights in kg and convert data type to tinyint (Originally, Some weights are expressed in 
       lbs and the column datatype is nvarchar).
    
    5. Convert values in Wage and Value columns from varchar to float
    
    6. Drop the star symbol in W_F, SM and IR entries

    7. For players not associated with clubs, change 'No club' to NULL 
    
    
Here's a snippet of the cleaned data:
| ID   | Name            | LongName             | Nationality | Height_cm | Weight_kg | Wage_euro | Value_euro | Age | OVA | POT | Club        | Positions | Preferred_Foot | BOV | Best_Position | Joined     | Attacking | Crossing | Finishing | Heading_Accuracy | Short_Passing | Volleys | Skill | Dribbling | Curve | FK_Accuracy | Long_Passing | Ball_Control | Movement | Acceleration | Sprint_Speed | Agility | Reactions | Balance | Power | Shot_Power | Jumping | Stamina | Strength | Long_Shots | Mentality | Aggression | Interceptions | Positioning | Vision | Penalties | Composure | Defending | Marking | Standing_Tackle | Sliding_Tackle | Goalkeeping | GK_Diving | GK_Handling | GK_Kicking | GK_Positioning | GK_Reflexes | Total_Stats | Base_Stats | W_F | SM | A_W    | D_W    | IR | PAC | SHO | PAS | DRI | DEF | PHY | Hits | countSimilarPlayer | Position_Group |
|------|-----------------|----------------------|-------------|-----------|-----------|-----------|------------|-----|-----|-----|-------------|-----------|----------------|-----|---------------|------------|-----------|----------|-----------|------------------|---------------|---------|-------|-----------|-------|-------------|--------------|--------------|----------|--------------|--------------|---------|-----------|---------|-------|------------|---------|---------|----------|------------|-----------|------------|---------------|-------------|--------|-----------|-----------|-----------|---------|-----------------|----------------|-------------|-----------|-------------|------------|----------------|-------------|-------------|------------|-----|----|--------|--------|----|-----|-----|-----|-----|-----|-----|------|--------------------|----------------|
| 41   | Iniesta         | Andrés Iniesta Luján | Spain       | 171       | 68        | 12000     | 8000000    | 36  | 81  | 81  | Vissel Kobe | CM, CAM   | Right          | 82  | CAM           | 16/07/2018 | 367       | 75       | 69        | 54               | 90            | 79      | 408   | 85        | 80    | 70          | 83           | 90           | 346      | 61           | 56           | 79      | 75        | 75      | 297   | 67         | 40      | 58      | 62       | 70         | 370       | 58         | 70            | 78          | 93     | 71        | 89        | 181       | 68      | 57              | 56             | 45          | 6         | 13          | 6          | 13             | 7           | 2014        | 420        | 4   | 4  | High   | Medium | 4  | 58  | 70  | 85  | 85  | 63  | 59  | 130  | 1                  | Midfielders    |
| 1179 | G. Buffon       | Gianluigi Buffon     | Italy       | 192       | 92        | 41000     | 3400000    | 42  | 82  | 82  | Juventus    | GK        | Right          | 82  | GK            | 04/07/2019 | 95        | 13       | 15        | 13               | 37            | 17      | 122   | 26        | 20    | 13          | 35           | 28           | 251      | 37           | 30           | 55      | 80        | 49      | 243   | 56         | 71      | 34      | 69       | 13         | 150       | 38         | 28            | 12          | 50     | 22        | 70        | 35        | 13      | 11              | 11             | 396         | 77        | 76          | 74         | 91             | 78          | 1292        | 429        | 2   | 1  | Medium | Medium | 4  | 77  | 76  | 74  | 78  | 33  | 91  | 131  | 1                  | Goalkeeper     |
| 2147 | M. Stekelenburg | Maarten Stekelenburg | Netherlands | 197       | 92        | 6000      | 250000     | 37  | 72  | 72  | Ajax        | GK        | Right          | 72  | GK            | 05/08/2020 | 93        | 18       | 11        | 14               | 39            | 11      | 106   | 12        | 13    | 13          | 37           | 31           | 192      | 30           | 36           | 30      | 69        | 27      | 224   | 54         | 55      | 27      | 77       | 11         | 142       | 41         | 26            | 12          | 40     | 23        | 59        | 38        | 9       | 15              | 14             | 355         | 69        | 71          | 72         | 73             | 70          | 1150        | 388        | 4   | 1  | Medium | Medium | 2  | 69  | 71  | 72  | 70  | 33  | 73  | 23   | 1                  | Goalkeeper     |
 

### Data Exploration
__________________________________________________________________________________________________________________________________________________________
See data exploration SQL script [here](https://github.com/blumea7/SQL-Project-1-Data-Cleaning-and-Exploration-on-2021-FIFA-Dataset/blob/main/sql-scripts/FIFA21_Data_Exploration.sql)

1. Find the Top 10 players based on OVA
 
      | LongName                     | Club                    | Best_Position | OVA | Total_Stats | Wage_euro |
      |------------------------------|-------------------------|---------------|-----|-------------|-----------|
      | Lionel Messi                 |     FC Barcelona        | RW            | 93  | 2231        | 560000    |
      | C. Ronaldo dos Santos Aveiro |     Juventus            | ST            | 92  | 2221        | 220000    |
      | Robert Lewandowski           |     FC Bayern München   | ST            | 91  | 2195        | 240000    |
      | Neymar da Silva Santos Jr.   |     Paris Saint-Germain | LW            | 91  | 2175        | 270000    |
      | Kevin De Bruyne              |     Manchester City     | CAM           | 91  | 2304        | 370000    |
      | Jan Oblak                    |     Atlético Madrid     | GK            | 91  | 1413        | 125000    |
      | Virgil van Dijk              |     Liverpool           | CB            | 90  | 2112        | 210000    |
      | Marc-André ter Stegen        |     FC Barcelona        | GK            | 90  | 1442        | 260000    |
      | Kylian Mbappé                |     Paris Saint-Germain | ST            | 90  | 2147        | 160000    |
      | Alisson Ramses Becker        |     Liverpool           | GK            | 90  | 1389        | 160000    |


2. Find the median wage of players (Findings: Median = 4000 Euro)
3. Find the average wage of players (Findings: Average = 11332 Euro)

4. Determine which positions are paid the most. Also, create a new column that would assign the correct position group to each position.
    - Forwards: LW, ST, CF, ST, RW
    - Midfielders: LM, CM, CDM, CAM, CM, RM
    - Defenders: LB, LWB, CB, SW, RB, RWB
    - Goalkeeper: GK

   Findings: 
   
   - Generally, forwards are paid highest, followed by midfielders and then defenders. 
                Goalkeepers are paid the least
   - The highest paid positions (forwards) have the least number of players across the league
    
      | Best_Position | Position_Group | Pos_Mean_Wage | Pos_Quantity |
      |---------------|----------------|---------------|--------------|
      | CF            | Forwards       | 28045         | 67           |
      | LW            | Forwards       | 19109         | 156          |
      | RW            | Forwards       | 18113         | 248          |
      | CM            | Midfielders    | 15977         | 884          |
      | CAM           | Midfielders    | 11886         | 1793         |
      | CDM           | Midfielders    | 11832         | 1170         |
      | ST            | Forwards       | 11360         | 2201         |
      | RB            | Defenders      | 11248         | 862          |
      | LM            | Midfielders    | 10953         | 702          |
      | LB            | Defenders      | 10768         | 871          |
      | CB            | Defenders      | 10501         | 2932         |
      | LWB           | Defenders      | 10332         | 220          |
      | RWB           | Defenders      | 10026         | 228          |
      | GK            | Goalkeeper     | 9228          | 1434         |
      | RM            | Midfielders    | 8976          | 1259         |

5. Determine the distribution of wage across different age groups in each position group

    | Position_Group | Age_Group | Mean_Wage_Per_Age_Group |
    |----------------|-----------|-------------------------|
    | Defenders      | 15 - 20   | 4597                    |
    | Defenders      | 20 - 25   | 8825                    |
    | Defenders      | 25 - 30   | 13493                   |
    | Defenders      | 30 - 35   | 12751                   |
    | Defenders      | 35 - 40   | 8981                    |
    | Defenders      | 40 - 45   | 20000                   |
    | Forwards       | 15 - 20   | 4505                    |
    | Forwards       | 20 - 25   | 10109                   |
    | Forwards       | 25 - 30   | 16312                   |
    | Forwards       | 30 - 35   | 20142                   |
    | Forwards       | 35 - 40   | 10902                   |
    | Forwards       | 40 - 45   | 3500                    |
    | Goalkeeper     | 15 - 20   | 2946                    |
    | Goalkeeper     | 20 - 25   | 5802                    |
    | Goalkeeper     | 25 - 30   | 11886                   |
    | Goalkeeper     | 30 - 35   | 12672                   |
    | Goalkeeper     | 35 - 40   | 6280                    |
    | Goalkeeper     | 40 - 45   | 12250                   |
    | Midfielders    | 15 - 20   | 5416                    |
    | Midfielders    | 20 - 25   | 10601                   |
    | Midfielders    | 25 - 30   | 15779                   |
    | Midfielders    | 30 - 35   | 14668                   |
    | Midfielders    | 35 - 40   | 7617                    |
    | Midfielders    | 40 - 45   | 2333                    |

### Data Analysis and Visualization
__________________________________________________________________________________________________________________________________________________________
### Notes:
- Data Visualizations are done in Power BI.
- Data visualizations are just derived from the queried tables in Data Exploration Section and not from the whole dataset.

#### Individual Player Salary vs OVA Rating
   Findings: 
   
   
   - There is a strong correlation between a player's OVA rating and their salary. 
       - A higher OVA rating often translates to a higher salary 


   - Half of the FIFA players are earning below Є4000, which is 140x lower than the highest earning player (Є560,000)
   
   
   
![Salary of 2021 FIFA Players](https://github.com/blumea7/SQL-Project-1-Data-Cleaning-and-Exploration-on-2021-FIFA-Dataset/blob/main/assets/1.%20Salary%20by%20OVA.JPG)


#### Average Salary per Position (and Position Group)

   Findings:
   
   - Generally, forwards are paid the highest, followed by midfielders, and then by defenders. Goalkeepers are paid the least.



![Average Salary of 2021 FIFA Players per Position Group](https://github.com/blumea7/SQL-Project-1-Data-Cleaning-and-Exploration-on-2021-FIFA-Dataset/blob/main/assets/3.%20Salary%20by%20Position.JPG)


#### Top 10 Players rated by OVA against their Salaries

   Findings: 
   
   - We have established in the previous charts that forwards are the highest earning players (and therefore their OVA is also high) 
        - Hence, our Top 10 players by OVA are dominated by forwards (with frequency = 5) 
   - The second chart reveals that goalkeepers are paid the least
        - Surprisingly, we have 3 goalkeepers with high OVA ratings and salaries 
        - This suggests that there may be an abundance of goalkeepers in the league, and only the top performers are highly paid.
   - The first chart depicts that OVA ratings is heavily correlated to earnings
        - However, for high earning players, OVA might have minimal impact on their earning potential
        - Notice that the graph of OVA is generally flat for the top 10 players 
        - But the Top 1 player earns 4.48 times more than the Top 10 player despite having nearly the same OVA rating



![Top 10 Players by OVA and their Salaries and Positions](https://github.com/blumea7/SQL-Project-1-Data-Cleaning-and-Exploration-on-2021-FIFA-Dataset/blob/main/assets/2.1%20Top%2010%20Players%20Salary.JPG)

#### Average Salary per Age and Position Group 

   Findings: 
   
   - Generally, all positions are paid the most either at the age of 25-30 or 30-35. 
   - Note: The reported average salary of Є20,000 for defenders aged between 40-45 should not be relied upon as a credible statistic
        -  Upon further data exploration, it was found out that the  sample size is only 1 rendering the result statistically insignificant.

![Average Salary per Age Group and Position Group](https://github.com/blumea7/SQL-Project-1-Data-Cleaning-and-Exploration-on-2021-FIFA-Dataset/blob/main/assets/4.%20Salary%20by%20Position%20Group%20and%20Age.JPG)
