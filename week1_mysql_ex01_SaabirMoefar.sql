-- =====================================================================
-- Course 2 - Backend Web Development
-- Exercise 01 - Database Design and Table Creation
-- Project: EduTrack SA (South African online learning platform)
-- Author: Saabir Moefar
-- =====================================================================

-- ---------------------------------------------------------------------
-- TASK 1: Create the database and select it for use
-- ---------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS edutrack_sa;
USE edutrack_sa;

-- ---------------------------------------------------------------------
-- TASK 2: Create the facilitators table
-- Stores instructors who run courses. Email must be unique and required.
-- ---------------------------------------------------------------------
CREATE TABLE facilitators (
    facilitator_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name     VARCHAR(50)  NOT NULL,
    last_name      VARCHAR(50)  NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    phone          VARCHAR(20)
);

-- ---------------------------------------------------------------------
-- TASK 3: Create the courses table
-- Each course is run by one facilitator (FOREIGN KEY -> facilitators).
-- ---------------------------------------------------------------------
CREATE TABLE courses (
    course_id       INT AUTO_INCREMENT PRIMARY KEY,
    course_name     VARCHAR(100) NOT NULL,
    duration_weeks  INT NOT NULL,
    facilitator_id  INT NOT NULL,
    CONSTRAINT fk_courses_facilitator
        FOREIGN KEY (facilitator_id) REFERENCES facilitators(facilitator_id)
);

-- ---------------------------------------------------------------------
-- TASK 4: Create the trainees table
-- Stores learners. Email must be unique and required.
-- STRETCH GOAL 19: created_at timestamp added.
-- ---------------------------------------------------------------------
CREATE TABLE trainees (
    trainee_id  INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    province    VARCHAR(50)  NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- TASK 5: Create the enrolments table
-- Links trainees to courses (many-to-many resolved via this junction
-- table). This keeps the design in 3NF - no repeating groups, no
-- partial or transitive dependencies.
-- STRETCH GOAL 18: CHECK constraint restricts status values.
-- STRETCH GOAL 19: created_at timestamp added.
-- ---------------------------------------------------------------------
CREATE TABLE enrolments (
    enrolment_id    INT AUTO_INCREMENT PRIMARY KEY,
    trainee_id      INT NOT NULL,
    course_id       INT NOT NULL,
    enrolment_date  DATE NOT NULL,
    status          VARCHAR(20) NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_enrolments_trainee
        FOREIGN KEY (trainee_id) REFERENCES trainees(trainee_id),
    CONSTRAINT fk_enrolments_course
        FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT chk_enrolment_status
        CHECK (status IN ('Active', 'Completed', 'Withdrawn'))
);

-- ---------------------------------------------------------------------
-- TASK 6: Insert data into facilitators (4 rows, SA names)
-- ---------------------------------------------------------------------
INSERT INTO facilitators (first_name, last_name, email, phone) VALUES
('Thabo', 'Mokoena', 'thabo.mokoena@edutrack.co.za', '0712345678'),
('Zanele', 'Dlamini', 'zanele.dlamini@edutrack.co.za', '0723456789'),
('Pieter', 'van der Merwe', 'pieter.vandermerwe@edutrack.co.za', '0734567890'),
('Naledi', 'Khumalo', 'naledi.khumalo@edutrack.co.za', '0745678901');

-- ---------------------------------------------------------------------
-- TASK 7: Insert data into courses (4 rows, linked to facilitators)
-- ---------------------------------------------------------------------
INSERT INTO courses (course_name, duration_weeks, facilitator_id) VALUES
('Introduction to Web Development', 8, 1),
('Backend Development with MySQL', 6, 2),
('Data Analysis with Python', 10, 3),
('UI/UX Design Fundamentals', 5, 4);

-- ---------------------------------------------------------------------
-- TASK 8: Insert data into trainees (4 rows, SA names and provinces)
-- ---------------------------------------------------------------------
INSERT INTO trainees (first_name, last_name, email, province) VALUES
('Lindiwe', 'Nkosi', 'lindiwe.nkosi@gmail.com', 'Gauteng'),
('Sipho', 'Ndlovu', 'sipho.ndlovu@gmail.com', 'KwaZulu-Natal'),
('Amahle', 'Botha', 'amahle.botha@gmail.com', 'Western Cape'),
('Kagiso', 'Molefe', 'kagiso.molefe@gmail.com', 'Gauteng');

-- ---------------------------------------------------------------------
-- TASK 9: Insert data into enrolments (4 rows, linked to trainees/courses)
-- ---------------------------------------------------------------------
INSERT INTO enrolments (trainee_id, course_id, enrolment_date, status) VALUES
(1, 1, '2026-01-15', 'Active'),
(2, 2, '2026-02-01', 'Completed'),
(3, 3, '2026-02-10', 'Active'),
(4, 4, '2026-01-20', 'Withdrawn');

-- ---------------------------------------------------------------------
-- TASK 10: Verification SELECT queries - confirm all data inserted
-- ---------------------------------------------------------------------
SELECT * FROM facilitators;
SELECT * FROM courses;
SELECT * FROM trainees;
SELECT * FROM enrolments;

-- ---------------------------------------------------------------------
-- STRETCH GOAL 20: Full name and province of all trainees from Gauteng
-- ---------------------------------------------------------------------
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    province
FROM trainees
WHERE province = 'Gauteng';
