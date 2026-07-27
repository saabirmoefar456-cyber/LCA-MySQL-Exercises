-- =====================================================================
-- Course 2 - Backend Web Development
-- Exercise 02 - Querying, Sorting, and Filtering Data
-- Project: EduTrack SA (South African online learning platform)
-- Author: Saabir Moefar
-- =====================================================================

USE edutrack_sa;

-- ---------------------------------------------------------------------
-- TASK 1: Sort all trainees by surname (ascending, A-Z)
-- ---------------------------------------------------------------------
SELECT * FROM trainees
ORDER BY last_name ASC;

-- ---------------------------------------------------------------------
-- TASK 2: Sort all courses by duration (descending, longest first)
-- ---------------------------------------------------------------------
SELECT * FROM courses
ORDER BY duration_weeks DESC;

-- ---------------------------------------------------------------------
-- TASK 3: Show the 3 most recently enrolled records using LIMIT
-- ---------------------------------------------------------------------
SELECT * FROM enrolments
ORDER BY enrolment_date DESC
LIMIT 3;

-- ---------------------------------------------------------------------
-- TASK 4: Filter trainees by province (Gauteng)
-- ---------------------------------------------------------------------
SELECT * FROM trainees
WHERE province = 'Gauteng';

-- ---------------------------------------------------------------------
-- TASK 5: Filter trainees whose first name starts with a specific
-- letter (using LIKE with % wildcard) - here, names starting with 'L'
-- ---------------------------------------------------------------------
SELECT * FROM trainees
WHERE first_name LIKE 'L%';

-- ---------------------------------------------------------------------
-- TASK 6: Filter courses by duration (courses longer than 6 weeks)
-- ---------------------------------------------------------------------
SELECT * FROM courses
WHERE duration_weeks > 6;

-- ---------------------------------------------------------------------
-- TASK 7: Filter enrolments by status (only Active enrolments)
-- ---------------------------------------------------------------------
SELECT * FROM enrolments
WHERE status = 'Active';

-- ---------------------------------------------------------------------
-- TASK 8: Total trainee count (COUNT aggregate function)
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS total_trainees
FROM trainees;

-- ---------------------------------------------------------------------
-- TASK 9: Average and maximum course duration (AVG, MAX aggregates)
-- ---------------------------------------------------------------------
SELECT
    AVG(duration_weeks) AS average_duration,
    MAX(duration_weeks) AS max_duration
FROM courses;

-- ---------------------------------------------------------------------
-- TASK 10: Enrolment count per course (GROUP BY with COUNT)
-- ---------------------------------------------------------------------
SELECT
    c.course_name,
    COUNT(e.enrolment_id) AS enrolment_count
FROM courses c
LEFT JOIN enrolments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- ---------------------------------------------------------------------
-- TASK 11: Trainee count per province (GROUP BY)
-- ---------------------------------------------------------------------
SELECT
    province,
    COUNT(*) AS trainee_count
FROM trainees
GROUP BY province;

-- ---------------------------------------------------------------------
-- TASK 12: Provinces with more than one trainee (GROUP BY + HAVING)
-- ---------------------------------------------------------------------
SELECT
    province,
    COUNT(*) AS trainee_count
FROM trainees
GROUP BY province
HAVING COUNT(*) > 1;

-- ---------------------------------------------------------------------
-- STRETCH GOAL 18: 2nd and 3rd most recently enrolled records
-- (LIMIT + OFFSET combined - skips the 1st most recent, shows next 2)
-- ---------------------------------------------------------------------
SELECT * FROM enrolments
ORDER BY enrolment_date DESC
LIMIT 2 OFFSET 1;

-- ---------------------------------------------------------------------
-- STRETCH GOAL 19: All trainees whose email ends with '.co.za'
-- (LIKE with % wildcard at the start of the pattern)
-- ---------------------------------------------------------------------
SELECT * FROM trainees
WHERE email LIKE '%.co.za';

-- ---------------------------------------------------------------------
-- STRETCH GOAL 20: Each facilitator's full name and number of courses
-- they facilitate, only including those who facilitate more than one
-- ---------------------------------------------------------------------
SELECT
    CONCAT(f.first_name, ' ', f.last_name) AS facilitator_name,
    COUNT(c.course_id) AS course_count
FROM facilitators f
JOIN courses c ON f.facilitator_id = c.facilitator_id
GROUP BY f.facilitator_id, facilitator_name
HAVING COUNT(c.course_id) > 1;
