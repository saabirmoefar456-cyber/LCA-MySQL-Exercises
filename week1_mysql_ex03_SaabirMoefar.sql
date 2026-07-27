-- =====================================================================
-- Course 2 - Backend Web Development
-- Exercise 03 - SQL Joins and Data Manipulation
-- Project: EduTrack SA (South African online learning platform)
-- Author:Saabir Moefar

USE edutrack_sa;

-- ---------------------------------------------------------------------
-- TASK 1: INNER JOIN - enrolment list joining trainees, enrolments,
-- and courses. Only shows trainees who ARE enrolled in a course.
-- ---------------------------------------------------------------------
SELECT
    t.first_name,
    t.last_name,
    c.course_name,
    e.enrolment_date,
    e.status
FROM trainees t
INNER JOIN enrolments e ON t.trainee_id = e.trainee_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- ---------------------------------------------------------------------
-- TASK 1b: INNER JOIN - course and facilitator name pairing
-- ---------------------------------------------------------------------
SELECT
    c.course_name,
    CONCAT(f.first_name, ' ', f.last_name) AS facilitator_name
FROM courses c
INNER JOIN facilitators f ON c.facilitator_id = f.facilitator_id;

-- ---------------------------------------------------------------------
-- TASK 2: LEFT JOIN - full trainee list with course name, including
-- trainees who are NOT enrolled in anything (shows NULL for course)
-- ---------------------------------------------------------------------
SELECT
    t.first_name,
    t.last_name,
    c.course_name
FROM trainees t
LEFT JOIN enrolments e ON t.trainee_id = e.trainee_id
LEFT JOIN courses c ON e.course_id = c.course_id;

-- ---------------------------------------------------------------------
-- TASK 3: RIGHT JOIN - full course list with trainee names, including
-- courses that have NO trainees enrolled (shows NULL for trainee)
-- ---------------------------------------------------------------------
SELECT
    c.course_name,
    t.first_name,
    t.last_name
FROM enrolments e
RIGHT JOIN courses c ON e.course_id = c.course_id
LEFT JOIN trainees t ON e.trainee_id = t.trainee_id;

-- ---------------------------------------------------------------------
-- TASK 4: UPDATE - change a trainee's province, affecting only that
-- one specific row (identified by trainee_id, not by a broader match)
-- ---------------------------------------------------------------------
UPDATE trainees
SET province = 'Western Cape'
WHERE trainee_id = 2;

-- ---------------------------------------------------------------------
-- TASK 4b: UPDATE - change an enrolment's status, affecting only that
-- one specific row
-- ---------------------------------------------------------------------
UPDATE enrolments
SET status = 'Completed'
WHERE enrolment_id = 1;

-- ---------------------------------------------------------------------
-- TASK 5: DELETE - remove a specific enrolment record. ORDER BY and
-- LIMIT are used to safely target the single most recent 'Withdrawn'
-- enrolment rather than deleting on an ambiguous condition.
-- ---------------------------------------------------------------------
DELETE FROM enrolments
WHERE status = 'Withdrawn'
ORDER BY enrolment_date DESC
LIMIT 1;

-- ---------------------------------------------------------------------
-- TASK 6: Mini challenge - single query combining JOIN, WHERE,
-- GROUP BY, HAVING, and ORDER BY. Shows courses with at least one
-- Active enrolment, along with how many active trainees they have,
-- sorted from most to least popular.
-- ---------------------------------------------------------------------
SELECT
    c.course_name,
    COUNT(e.enrolment_id) AS active_enrolments
FROM courses c
JOIN enrolments e ON c.course_id = e.course_id
WHERE e.status = 'Active'
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrolment_id) >= 1
ORDER BY active_enrolments DESC;

-- ---------------------------------------------------------------------
-- STRETCH GOAL 20: Facilitator with the most trainees across all of
-- their courses combined
-- ---------------------------------------------------------------------
SELECT
    CONCAT(f.first_name, ' ', f.last_name) AS facilitator_name,
    COUNT(e.enrolment_id) AS total_trainees
FROM facilitators f
JOIN courses c ON f.facilitator_id = c.facilitator_id
JOIN enrolments e ON c.course_id = e.course_id
GROUP BY f.facilitator_id, facilitator_name
ORDER BY total_trainees DESC
LIMIT 1;

-- ---------------------------------------------------------------------
-- STRETCH GOAL 21: Add a new facilitator, create a new course for
-- them, and enrol two existing trainees into that course
-- ---------------------------------------------------------------------
INSERT INTO facilitators (first_name, last_name, email, phone)
VALUES ('Bongani', 'Sithole', 'bongani.sithole@edutrack.co.za', '0756789012');

INSERT INTO courses (course_name, duration_weeks, facilitator_id)
VALUES ('Cloud Computing Basics', 7, (SELECT facilitator_id FROM facilitators WHERE email = 'bongani.sithole@edutrack.co.za'));

INSERT INTO enrolments (trainee_id, course_id, enrolment_date, status)
VALUES
    (1, (SELECT course_id FROM courses WHERE course_name = 'Cloud Computing Basics'), '2026-03-01', 'Active'),
    (3, (SELECT course_id FROM courses WHERE course_name = 'Cloud Computing Basics'), '2026-03-01', 'Active');

-- ---------------------------------------------------------------------
-- STRETCH GOAL 22: Trainees enrolled in more than one course
-- ---------------------------------------------------------------------
SELECT
    t.trainee_id,
    CONCAT(t.first_name, ' ', t.last_name) AS trainee_name,
    COUNT(e.enrolment_id) AS course_count
FROM trainees t
JOIN enrolments e ON t.trainee_id = e.trainee_id
GROUP BY t.trainee_id, trainee_name
HAVING COUNT(e.enrolment_id) > 1;

SELECT * FROM facilitators;