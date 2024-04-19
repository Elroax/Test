/* ======= Test 
Use my code to create the tables for the exercise.

-- Create Table_A
CREATE TABLE Table_A (
    dimension_1 INT,
    dimension_2 VARCHAR(10),
    Value_1 INT
);

-- Insert sample data into Table_A
INSERT INTO Table_A (dimension_1, dimension_2, Value_1)
VALUES
    (1, 'X', 10),
    (2, 'Y', 20),
    (3, 'Z', 30);

-- Create Table_B
CREATE TABLE Table_B (
    dimension_1 INT,
    dimension_2 VARCHAR(10),
    Value_2 INT
);

-- Insert sample data into Table_B
INSERT INTO Table_B (dimension_1, dimension_2, Value_2)
VALUES
    (1, 'X', 5),
    (2, 'Y', 10),
    (3, 'W', 15);

-- Create MAP table
CREATE TABLE MAP (
    incorrect_Letter VARCHAR(10),
    correct_Letter VARCHAR(10)
);

-- Insert sample data into MAP
INSERT INTO MAP (incorrect_Letter, correct_Letter)
VALUES ('Z', 'A'),('W', 'B'),('L', 'C'),('H', 'D');



Maping the Correct Letters ============
*/

-- ======== Maping the Correct Letters ======

-- Table_A and Table_B having a wrong letter say the test! =)
-- replace Z to A and W to B

WITH Corrected_A AS (
    SELECT
        dimension_1,
        COALESCE(M.correct_Letter, A.dimension_2) AS dimension_2,
        measure_1
    FROM Table_A A
    LEFT JOIN MAP M ON A.dimension_2 = M.incorrect_Letter
),

Corrected_B AS (
    SELECT
        dimension_1,
        COALESCE(M.correct_Letter, B.dimension_2) AS dimension_2,
        measure_2
    FROM Table_B B
    LEFT JOIN MAP M ON B.dimension_2 = M.incorrect_Letter
)
-- ============================================================================================================

-- Aggregate measures from Corrected_A and Corrected_B and NUll values = 0 and 
-- Extra colum was create to sume all measure.

SELECT
    COALESCE(CA.dimension_1, CB.dimension_1) AS dimension_1,
    COALESCE(CA.dimension_2, CB.dimension_2) AS dimension_2,
    SUM(COALESCE(CA.measure_1, 0)) AS measure_1,
	SUM(COALESCE(CB.measure_2, 0)) AS measure_2,
	SUM(COALESCE(CA.measure_1, 0)) + SUM(COALESCE(CB.measure_2, 0)) AS total_measure_sum
FROM Corrected_A CA
FULL JOIN Corrected_B CB
    ON CA.dimension_1 = CB.dimension_1
    AND COALESCE(CA.dimension_2, '') = COALESCE(CB.dimension_2, '')
GROUP BY COALESCE(CA.dimension_1, CB.dimension_1), COALESCE(CA.dimension_2, CB.dimension_2)
ORDER BY dimension_1

-- to check the tables vs end table
Select * from Table_A
Select * from Table_B