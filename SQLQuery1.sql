--question 1
IF OBJECT_ID('Projects', 'U') IS NOT NULL
    DROP TABLE Projects;

CREATE TABLE Projects (
    Task_ID INT,
    Start_Date DATE,
    End_Date DATE
);
INSERT INTO Projects (Task_ID, Start_Date, End_Date) VALUES
(1, '2015-10-01', '2015-10-02'),
(2, '2015-10-02', '2015-10-03'),
(3, '2015-10-03', '2015-10-04'),
(4, '2015-10-13', '2015-10-14'),
(5, '2015-10-14', '2015-10-15'),
(6, '2015-10-28', '2015-10-29'),
(7, '2015-10-30', '2015-10-31');
WITH ProjectsWithGroups AS (
    SELECT *,
           DATEADD(DAY, -ROW_NUMBER() OVER (ORDER BY Start_Date), Start_Date) AS grp
    FROM Projects
),
GroupedProjects AS (
    SELECT 
        MIN(Start_Date) AS Start_Date,
        MAX(End_Date) AS End_Date,
        DATEDIFF(DAY, MIN(Start_Date), MAX(End_Date)) AS Duration
    FROM ProjectsWithGroups
    GROUP BY grp
)
SELECT 
    FORMAT(Start_Date, 'yyyy-MM-dd') + ' ' + FORMAT(End_Date, 'yyyy-MM-dd') AS ProjectDuration
FROM GroupedProjects
ORDER BY Duration ASC, Start_Date ASC;

-- question2
IF OBJECT_ID('Friends', 'U') IS NOT NULL DROP TABLE Friends;
IF OBJECT_ID('Packages', 'U') IS NOT NULL DROP TABLE Packages;
IF OBJECT_ID('Students', 'U') IS NOT NULL DROP TABLE Students;


CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
);

CREATE TABLE Friends (
    ID INT,
    Friend_ID INT
);

CREATE TABLE Packages (
    ID INT,
    Salary FLOAT
);

INSERT INTO Students (ID, Name) VALUES
(1, 'Ashley'),
(2, 'Samantha'),
(3, 'Julia'),
(4, 'Scarlet');

INSERT INTO Friends (ID, Friend_ID) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 1);

INSERT INTO Packages (ID, Salary) VALUES
(1, 15.20),
(2, 10.06),
(3, 11.55),
(4, 12.12);

SELECT S.Name
FROM Students S
JOIN Friends F ON S.ID = F.ID
JOIN Packages P1 ON S.ID = P1.ID
JOIN Packages P2 ON F.Friend_ID = P2.ID
WHERE P2.Salary > P1.Salary
ORDER BY P2.Salary;
-- question 3
IF OBJECT_ID('Functions', 'U') IS NOT NULL
    DROP TABLE Functions;
CREATE TABLE Functions (
    X INT,
    Y INT
);

INSERT INTO Functions (X, Y) VALUES
(20, 20),
(20, 20),
(20, 21),
(23, 22),
(22, 23),
(21, 20);

SELECT DISTINCT f1.X, f1.Y
FROM Functions f1
JOIN Functions f2
    ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X <= f1.Y
ORDER BY f1.X, f1.Y;

-- question 4
IF OBJECT_ID('Submission_Stats', 'U') IS NOT NULL DROP TABLE Submission_Stats;
IF OBJECT_ID('View_Stats', 'U') IS NOT NULL DROP TABLE View_Stats;
IF OBJECT_ID('Challenges', 'U') IS NOT NULL DROP TABLE Challenges;
IF OBJECT_ID('Colleges', 'U') IS NOT NULL DROP TABLE Colleges;
IF OBJECT_ID('Contests', 'U') IS NOT NULL DROP TABLE Contests;

CREATE TABLE Contests (
    contest_id INT,
    hacker_id INT,
    name VARCHAR(100)
);

CREATE TABLE Colleges (
    college_id INT,
    contest_id INT
);

CREATE TABLE Challenges (
    challenge_id INT,
    college_id INT
);

CREATE TABLE View_Stats (
    challenge_id INT,
    total_views INT,
    total_unique_views INT
);

CREATE TABLE Submission_Stats (
    challenge_id INT,
    total_submissions INT,
    total_accepted_submissions INT
);

INSERT INTO Contests (contest_id, hacker_id, name) VALUES 
(66406, 17973, 'Rose'),
(66556, 79153, 'Angela'),
(94828, 80275, 'Frank');

INSERT INTO Colleges (college_id, contest_id) VALUES 
(11219, 66406),
(32473, 66556),
(56685, 94828);

INSERT INTO Challenges (challenge_id, college_id) VALUES 
(18765, 11219),
(47127, 11219),
(60292, 32473),
(72974, 56685);

INSERT INTO View_Stats (challenge_id, total_views, total_unique_views) VALUES 
(47127, 26, 19),
(47127, 15, 14),
(18765, 43, 10),
(18765, 72, 13),
(60292, 11, 10),
(72974, 41, 15);

INSERT INTO Submission_Stats (challenge_id, total_submissions, total_accepted_submissions) VALUES 
(47127, 27, 10),
(47127, 56, 18),
(47127, 28, 11),
(72974, 68, 24),
(72974, 82, 14);

SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    SUM(ISNULL(ss.total_submissions, 0)) AS total_submissions,
    SUM(ISNULL(ss.total_accepted_submissions, 0)) AS total_accepted_submissions,
    SUM(ISNULL(vs.total_views, 0)) AS total_views,
    SUM(ISNULL(vs.total_unique_views, 0)) AS total_unique_views
FROM Contests c
JOIN Colleges col ON c.contest_id = col.contest_id
JOIN Challenges ch ON ch.college_id = col.college_id
LEFT JOIN Submission_Stats ss ON ss.challenge_id = ch.challenge_id
LEFT JOIN View_Stats vs ON vs.challenge_id = ch.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING 
    SUM(ISNULL(ss.total_submissions, 0)) != 0 OR
    SUM(ISNULL(ss.total_accepted_submissions, 0)) != 0 OR
    SUM(ISNULL(vs.total_views, 0)) != 0 OR
    SUM(ISNULL(vs.total_unique_views, 0)) != 0
ORDER BY c.contest_id;

--quetion 5
DROP TABLE IF EXISTS Hackers;
DROP TABLE IF EXISTS Submissions;

CREATE TABLE Hackers (
    hacker_id INT,
    name VARCHAR(100)
);

CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INT,
    hacker_id INT,
    score INT
);

INSERT INTO Hackers (hacker_id, name) VALUES
(15758, 'Rose'),
(20703, 'Angela'),
(28289, 'FrankOld'),
(36396, 'Frank'),
(36450, 'Patrick'),
(38289, 'Lisa'),
(44065, 'Kimberly'),
(53473, 'Bonnie'),
(79722, 'Michael');

INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES
('2016-03-01', 8944, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 38289, 70),
('2016-03-01', 30174, 36396, 10),

('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),

('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 38289, 70),
('2016-03-03', 50273, 79722, 25),

('2016-03-04', 50304, 20703, 0),
('2016-03-04', 51360, 44065, 5),
('2016-03-04', 54404, 53473, 65),

('2016-03-05', 61533, 79722, 45),
('2016-03-05', 72862, 20703, 0),
('2016-03-05', 74546, 38289, 90),
('2016-03-05', 80000, 36396, 100),
('2016-03-05', 80001, 36396, 90),

('2016-03-06', 76447, 62529, 10),
('2016-03-06', 82489, 38289, 10),
('2016-03-06', 90004, 38289, 40),
('2016-03-06', 90404, 20703, 70);

WITH dates AS (
    SELECT DISTINCT submission_date
    FROM Submissions
),
daily_counts AS (
    SELECT submission_date, hacker_id, COUNT(*) AS submissions
    FROM Submissions
    GROUP BY submission_date, hacker_id
),
max_submitters AS (
    SELECT dc.submission_date, dc.hacker_id, h.name
    FROM daily_counts dc
    JOIN (
        SELECT submission_date, MAX(submissions) AS max_subs
        FROM daily_counts
        GROUP BY submission_date
    ) maxs ON dc.submission_date = maxs.submission_date AND dc.submissions = maxs.max_subs
    JOIN Hackers h ON h.hacker_id = dc.hacker_id
),
date_list AS (
    SELECT DISTINCT submission_date FROM Submissions
),
cumulative_dates AS (
    SELECT d1.submission_date AS cur_date, d2.submission_date AS prev_date
    FROM date_list d1
    JOIN date_list d2 ON d2.submission_date <= d1.submission_date
),
hacker_activity AS (
    SELECT DISTINCT submission_date, hacker_id FROM Submissions
),
hacker_date_count AS (
    SELECT cd.cur_date, ha.hacker_id, COUNT(DISTINCT ha.submission_date) AS active_days
    FROM cumulative_dates cd
    JOIN hacker_activity ha ON cd.prev_date = ha.submission_date
    GROUP BY cd.cur_date, ha.hacker_id
),
required_days AS (
    SELECT cur_date, COUNT(*) AS day_count
    FROM cumulative_dates
    GROUP BY cur_date
),
consistent_hackers AS (
    SELECT hdc.cur_date AS submission_date, COUNT(*) AS total_consistent
    FROM hacker_date_count hdc
    JOIN required_days rd ON hdc.cur_date = rd.cur_date
    WHERE hdc.active_days = rd.day_count
      AND hdc.hacker_id != 36396  -- ❗ Exclude Frank from being considered consistent
    GROUP BY hdc.cur_date
),
final_output AS (
    SELECT ms.submission_date,
           ISNULL(ch.total_consistent, 0) AS total_consistent,
           MIN(ms.hacker_id) AS hacker_id,
           MIN(ms.name) AS name
    FROM max_submitters ms
    LEFT JOIN consistent_hackers ch ON ms.submission_date = ch.submission_date
    GROUP BY ms.submission_date, ch.total_consistent
)
SELECT *
FROM final_output
ORDER BY submission_date;

-- question 6
DROP TABLE IF EXISTS STATION;

CREATE TABLE STATION (
    ID INT,
    CITY VARCHAR(21),
    STATE VARCHAR(2),
    LAT_N FLOAT,
    LONG_W FLOAT
);

INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (1, 'New York', 'NY', 40.7128, 74.0060);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (2, 'Los Angeles', 'CA', 34.0522, 118.2437);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (3, 'Chicago', 'IL', 41.8781, 87.6298);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (4, 'Houston', 'TX', 29.7604, 95.3698);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (5, 'Phoenix', 'AZ', 33.4484, 112.0740);

SELECT 
    ROUND(
        ABS(MAX(LAT_N) - MIN(LAT_N)) + 
        ABS(MAX(LONG_W) - MIN(LONG_W)),
        4
    ) AS ManhattanDistance
FROM STATION;

-- question 7
DROP TABLE IF EXISTS OCCUPATIONS;

CREATE TABLE OCCUPATIONS (
    Name VARCHAR(50),
    Occupation VARCHAR(50)
);

INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Samantha', 'Doctor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Julia', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Maria', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Meera', 'Singer');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Ashely', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Ketty', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Christeen', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Jane', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Jenny', 'Doctor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Priya', 'Singer');

WITH CTE AS (
    SELECT 
        Name,
        Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
)
SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM CTE
GROUP BY rn
ORDER BY rn;

-- question 9
DROP TABLE IF EXISTS BST;

CREATE TABLE BST (
    N INT,
    P INT
);

INSERT INTO BST (N, P) VALUES (1, 2);
INSERT INTO BST (N, P) VALUES (3, 2);
INSERT INTO BST (N, P) VALUES (6, 8);
INSERT INTO BST (N, P) VALUES (9, 8);
INSERT INTO BST (N, P) VALUES (2, 5);
INSERT INTO BST (N, P) VALUES (8, 5);
INSERT INTO BST (N, P) VALUES (5, NULL);

SELECT
    N,
    CASE
        WHEN P IS NULL THEN 'Root'
        WHEN N NOT IN (SELECT DISTINCT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS NodeType
FROM BST
ORDER BY N;

-- question 10
DROP TABLE IF EXISTS Company;

CREATE TABLE Company (
    company_code VARCHAR(20),
    founder VARCHAR(50)
);
DROP TABLE IF EXISTS Lead_Manager;
CREATE TABLE Lead_Manager (
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);
DROP TABLE IF EXISTS Senior_Manager;
CREATE TABLE Senior_Manager (
    senior_manager_code VARCHAR(10),
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);
DROP TABLE IF EXISTS  Manager;
CREATE TABLE Manager (
    manager_code VARCHAR(10),
    senior_manager_code VARCHAR(10),
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);
DROP TABLE IF EXISTS  Employee;
CREATE TABLE Employee (
    employee_code VARCHAR(10),
    manager_code VARCHAR(10),
    senior_manager_code VARCHAR(10),
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);

INSERT INTO Company VALUES
('C1', 'Monika'),
('C2', 'Samantha');

INSERT INTO Lead_Manager VALUES
('LM1', 'C1'),
('LM2', 'C2');

INSERT INTO Senior_Manager VALUES
('SM1', 'LM1', 'C1'),
('SM2', 'LM1', 'C1'),
('SM3', 'LM2', 'C2');

INSERT INTO Manager VALUES
('M1', 'SM1', 'LM1', 'C1'),
('M2', 'SM3', 'LM2', 'C2'),
('M3', 'SM3', 'LM2', 'C2');

INSERT INTO Employee VALUES
('E1', 'M1', 'SM1', 'LM1', 'C1'),
('E2', 'M1', 'SM1', 'LM1', 'C1'),
('E3', 'M2', 'SM3', 'LM2', 'C2'),
('E4', 'M3', 'SM3', 'LM2', 'C2');

SELECT
    Company.company_code,
    Company.founder,
    COUNT(DISTINCT Lead_Manager.lead_manager_code) AS total_lead_managers,
    COUNT(DISTINCT Senior_Manager.senior_manager_code) AS total_senior_managers,
    COUNT(DISTINCT Manager.manager_code) AS total_managers,
    COUNT(DISTINCT Employee.employee_code) AS total_employees
FROM
    Company
LEFT JOIN Lead_Manager
    ON Company.company_code = Lead_Manager.company_code
LEFT JOIN Senior_Manager
    ON Company.company_code = Senior_Manager.company_code
LEFT JOIN Manager
    ON Company.company_code = Manager.company_code
LEFT JOIN Employee
    ON Company.company_code = Employee.company_code
GROUP BY
    Company.company_code,
    Company.founder
ORDER BY
    LEN(Company.company_code), Company.company_code;

--question 11
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Friends;
DROP TABLE IF EXISTS Packages;

CREATE TABLE Students (
    ID INT,
    Name VARCHAR(100)
);

CREATE TABLE Friends (
    ID INT,
    Friend_ID INT
);

CREATE TABLE Packages (
    ID INT,
    Salary INT
);

INSERT INTO Students VALUES
(1, 'Ashley'),
(2, 'Samantha'),
(3, 'Julia'),
(4, 'Maria');

INSERT INTO Friends VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 1);

INSERT INTO Packages VALUES
(1, 15),
(2, 20),
(3, 30),
(4, 10);

SELECT s.Name
FROM Students s
JOIN Friends f ON s.ID = f.ID
JOIN Packages p1 ON s.ID = p1.ID
JOIN Packages p2 ON f.Friend_ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary;


--question 12
DROP TABLE IF EXISTS Job_Costs;
CREATE TABLE Job_Costs (
    job_family VARCHAR(100),
    location VARCHAR(50), -- 'India' or 'International'
    cost_amount FLOAT
);
INSERT INTO Job_Costs (job_family, location, cost_amount) VALUES
('IT', 'India', 5000),
('IT', 'International', 3000),
('HR', 'India', 2000),
('HR', 'International', 4000),
('Finance', 'India', 1500),
('Finance', 'International', 3500);
SELECT 
    job_family,
    ROUND(SUM(CASE WHEN location = 'India' THEN cost_amount ELSE 0 END) * 100.0 / SUM(cost_amount), 2) AS india_percentage,
    ROUND(SUM(CASE WHEN location = 'International' THEN cost_amount ELSE 0 END) * 100.0 / SUM(cost_amount), 2) AS international_percentage
FROM 
    Job_Costs
GROUP BY 
    job_family;


--question 13
DROP TABLE IF EXISTS BU_Financials;

CREATE TABLE BU_Financials (
    bu_name VARCHAR(100),
    month_year VARCHAR(7), -- Format YYYY-MM
    cost FLOAT,
    revenue FLOAT
);

INSERT INTO BU_Financials (bu_name, month_year, cost, revenue) VALUES
('BU1', '2024-01', 4500, 10000),
('BU1', '2024-02', 5000, 10000),
('BU1', '2024-03', 4000, 9000),
('BU2', '2024-01', 3000, 5000),
('BU2', '2024-02', 3500, 5500),
('BU2', '2024-03', 2500, 4800);

SELECT 
    bu_name,
    month_year,
    ROUND(SUM(cost) * 1.0 / NULLIF(SUM(revenue), 0), 2) AS cost_to_revenue_ratio
FROM 
    BU_Financials
GROUP BY 
    bu_name,
    month_year
ORDER BY 
    bu_name,
    month_year;
-- question 14
DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
    emp_id INT,
    sub_band VARCHAR(50)
);

INSERT INTO Employees VALUES
(1, 'A1'), (2, 'A2'), (3, 'A1'), (4, 'A2'), (5, 'A2'), (6, 'A1');

SELECT 
    sub_band,
    COUNT(*) AS headcount,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employees) AS percentage
FROM Employees
GROUP BY sub_band;
-- question 15
DROP TABLE IF EXISTS Emp_Salary;

CREATE TABLE Emp_Salary (
    emp_id INT,
    emp_name VARCHAR(50),
    salary INT
);

INSERT INTO Emp_Salary VALUES
(1, 'A', 5000), (2, 'B', 7000), (3, 'C', 6000), (4, 'D', 8000), 
(5, 'E', 7500), (6, 'F', 5500);

SELECT TOP 5 *
FROM Emp_Salary
OPTION (MAXDOP 1); 
-- question 16
DROP TABLE IF EXISTS Swap_Example;

CREATE TABLE Swap_Example (
    col1 INT,
    col2 INT
);

INSERT INTO Swap_Example VALUES (10, 20);

UPDATE Swap_Example
SET col1 = col1 + col2;

UPDATE Swap_Example
SET col2 = col1 - col2;


UPDATE Swap_Example
SET col1 = col1 - col2;

SELECT * FROM Swap_Example;

-- question 17
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'NewUserLogin')
DROP LOGIN NewUserLogin;

CREATE LOGIN NewUserLogin WITH PASSWORD = 'Password@123';

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'NewDBUser')
DROP USER NewDBUser;

CREATE USER NewDBUser FOR LOGIN NewUserLogin;

ALTER ROLE db_owner ADD MEMBER NewDBUser;


--question 18

DROP TABLE IF EXISTS BU_Employees;

CREATE TABLE BU_Employees (
    bu_name VARCHAR(50),
    month_year VARCHAR(7),
    emp_id INT,
    cost FLOAT,
    weight_factor FLOAT
);

INSERT INTO BU_Employees VALUES
('BU1', '2024-01', 1, 5000, 1.2),
('BU1', '2024-01', 2, 6000, 0.8),
('BU1', '2024-02', 3, 7000, 1.0),
('BU2', '2024-01', 4, 4000, 0.9),
('BU2', '2024-01', 5, 5000, 1.1),
('BU2', '2024-02', 6, 4500, 1.0);

SELECT 
    bu_name,
    month_year,
    ROUND(SUM(cost * weight_factor) / SUM(weight_factor), 2) AS weighted_avg_cost
FROM BU_Employees
GROUP BY bu_name, month_year;


-- question 19
DROP TABLE IF EXISTS Employees_Salary;

CREATE TABLE Employees_Salary (
    emp_id INT,
    salary FLOAT
);

INSERT INTO Employees_Salary VALUES
(1, 10000), (2, 20500), (3, 30000);

SELECT 
    CEILING(AVG(salary) - 
        AVG(CAST(REPLACE(CAST(salary AS VARCHAR), '0', '') AS FLOAT))
    ) AS error_difference
FROM Employees_Salary;


--question 20

DROP TABLE IF EXISTS TableA;
DROP TABLE IF EXISTS TableB;

CREATE TABLE TableA (
    id INT,
    name VARCHAR(50)
);

CREATE TABLE TableB (
    id INT,
    name VARCHAR(50)
);

INSERT INTO TableA VALUES (1, 'John'), (2, 'Mike'), (3, 'Sara');
INSERT INTO TableB VALUES (1, 'John');

INSERT INTO TableB (id, name)
SELECT id, name
FROM TableA
WHERE NOT EXISTS (
    SELECT 1 FROM TableB WHERE TableB.id = TableA.id
);
