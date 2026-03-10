-- useful commands: 
-- docker stop watchtower-postgres
-- docker start watchtower-postgres

-- https://hunter-undergraduate.catalog.cuny.edu/policies-and-requirements/academic-requirements/general-requirements/general-education-common-core

DROP TABLE IF EXISTS course_type_map CASCADE;
DROP TABLE IF EXISTS course_type CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE departments (
  dep_id TEXT PRIMARY KEY,    
  dep_code TEXT,
  name   TEXT NOT NULL
);

CREATE TABLE courses (
    course_id TEXT PRIMARY KEY,
    dep_id TEXT FOREIGN KEY,
    title TEXT NOT NULL,
    description TEXT, 
    credits NUMERIC(3,1) NOT NULL DEFAULT 3.0
); 

-- Requirement types (as of 02/09):
-- CS Major Core, CS Major Elective, Scientific World, Mathematical and Quantitative Reasoning, English Composition,
-- Life & Physical Sciences, Creative Expression, U.S. Experiences in its Diversity
-- World Cultures and Global Issues, Individual and Society - Social Science, 
-- Individual and Society - Humanities, Cultures and Ideas, Writing Requirement,
-- Pluralism & Diversity Group A: Non-European Societies, Pluralism & Diversity Group B: Groups in the U.S.A.
-- Pluralism & Diversity Group C: Women, Gender & Sexual Orientation, Pluralism & Diversity Group D: European Societies
CREATE TABLE course_type (
  type_id   BIGSERIAL PRIMARY KEY,
  type_name TEXT NOT NULL UNIQUE
);

CREATE TABLE course_type_map (
  course_id TEXT NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
  type_id    BIGINT NOT NULL REFERENCES course_type(type_id) ON DELETE CASCADE,
  PRIMARY KEY (course_id, type_id)
);


INSERT INTO departments (dep_id, name) VALUES -- might be useful if we want the user to add wants after the needs are satisfied
  ('CSCI', 'Computer Science'),
  ('MATH', 'Mathematics'),
  ('STAT', 'Statistics'),
  ('ENGL', 'English'),
  ('MEDIA', 'Media Studies'),
  ('ECO', 'Economics'),
  ('FILM', 'Film & Cinema Studies'),
  ('SOC', 'Sociology'),
  ('ASIAN', 'Asian American Studies')
  ('ANTHP', 'Anthropology'),
  ('ASTRO', 'Astronomy'),
  ('BIOL', 'Biology'),
  ('CHEM', 'Chemistry'),
  ('GEOL', 'Geology')
  ON CONFLICT (dep_id) DO NOTHING;

INSERT INTO courses (course_id, dep_id, title, description, credits) VALUES
    ('CSCI 12700', 'Introduction to Computer Science', '', 3.0), -- CS Major Core
    ('CSCI 13500', 'Software Analysis and Design I', '', 4.0),
    ('CSCI 15000', 'Discrete Structures', '', 4.0),
    ('CSCI 23500', 'Software Analysis and Design II', '', 3.0), 
    ('CSCI 26500', 'Computer Theory I', '', 3.0),
    ('CSCI 16000', 'Computer Architecture I', '', 3.0),
    ('CSCI 26000', 'Computer Architecture II', '', 3.0),
    ('CSCI 33500', 'Software Analysis and Design III', '', 3.0),
    ('CSCI 34000', 'Operating Systems', '', 3.0),
    ('CSCI 49900', 'Advnc Apl: Cpstne Maj', '', 4.0),
    ('MATH 15000', 'Calculus I', '', 4.0),
    ('MATH 15500', 'Calculus II', '', 4.0),
    ('STAT 21300', 'Introduction to Applied Stat', '', 3.0)
    ('CSCI 35000', 'Artifical Intelligence', '', 3.0),  -- CS Major Electives
    ('CSCI 35300', 'Machine Learning', '', 3.0),
    ('CSCI 36000', 'Computer Architecture 3', '', 3.0),
    ('CSCI 36500', 'Computer Theory 2', '', 3.0),
    ('CSCI 39100', 'Independent Study in Computer Science', '', 1.0),
    ('CSCI 39200', 'Independent Study in Computer Science', '', 2.0),
    ('CSCI 39300', 'Independent Study in Computer Science', '', 3.0),
    ('CSCI 39535', 'UI/UX Design', '', 3.0),
    ('CSCI 39536', 'Intro to Robotics', '', 3.0),
    ('CSCI 39540', 'Flutter App Dev', '', 3.0),
    ('CSCI 39541', 'Basics of Game Engines', '', 3.0),
    ('CSCI 39542', 'Intro to Data Science', '', 3.0),
    ('CSCI 39543', 'Intro to Data Mining', '', 3.0),
    ('CSCI 39544', 'Digital Product Dev', '', 3.0),
    ('CSCI 39548', 'Practical Web Development', '', 3.0),
    ('CSCI 39597', 'iOS Development', '', 3.0),
    ('CSCI 39598', 'Intro to Cyber Risk', '', 3.0),
    ('CSCI 40500', 'Software Engineering', '', 3.0),
    ('CSCI 43500', 'Data Base Management', '', 3.0),

    ('ENGL 12000', 'Expository Writing', '', 3.0), -- Mathematical and Quantitative Reasoning
    ('ENGL 22000', 'Intro: Writing about Literature', '', 3.0),   
    ('ENGL 220HS', 'Intro to Literature', '', 3.0),
    ('ASIAN 22100', 'Introduction to Writing About Asian American Literature', '', 3.0),
    ('MEDIA 21100', 'News Literacy in a Digital Age', '', 3.0),
    ('AFPRL 23800', 'Intro: Lit African Diaspora', '', 3.0),
    ('CSCI 12100', 'Computers & Money: Quant', '', 3.0),
    ('ECO 22100', 'Economic Statistics', '', 3.0),
    ('MATH 10000', 'Basic Structures in Math', '', 3.0),
    ('MATH 10200', 'Math in Everyday Life', '', 3.0),
    ('MATH 10400', 'Math for Elem Educ I', '', 3.0),
    ('MATH 12400', 'College Algebra & Trig', '', 4.0),
    ('MATH 12500', 'Precalculus', '', 4.0),
    ('MATH 12550', 'Precalculus with Workshop', '', 4.0),    
    ('MATH 15200', 'Calc for Life and Soc Science', '', 3.0),
    ('STAT 11300', 'Elem Prob & Stat', '', 3.0),
    ('STAT 21200', 'Discrete Probability', '', 3.0),
    ('ANTHP 10100', 'ANTHP', 'Human Evolution', '', 3.0), -- Scientific World
    ('ANTHP 10500', 'ANTHP', 'The Human Species', '', 3.0),
    ('ASTRO 10200', 'ASTRO', 'Lab Explorations in Astronomy', '', 3.0),
    ('BIOL 10000', 'BIOL', 'Principles of Biology I', '', 3.0),
    ('BIOL 10500', 'BIOL', 'Introduction to Genome Biology', '', 3.0),
    ('BIOL 10700', 'BIOL', 'Biology & Genetics of Personal Identification', '', 3.0),
    ('BIOL 12500', 'BIOL', 'Human Biology', '', 3.0),
    ('BIOL 15000', 'BIOL', 'CSI: Hunter (Forensic Biology)', '', 4.5),
    ('CHEM 10100', 'CHEM', 'Inquiries Nature of Matter', '', 3.0),
    ('CHEM 101HE', 'CHEM', 'Inquiries Nature of Matter (Honors)', '', 3.0),
    ('CHEM 101LB', 'CHEM', 'Essentials of General Chemistry Lab', '', 3.0),
    ('CHEM 10300', 'CHEM', 'General Chemistry I (Lab)', '', 3.0),
    ('CHEM 103HE', 'CHEM', 'General Chemistry I (Lab) Honors', '', 3.0),
    ('CHEM 10500', 'CHEM', 'General Chemistry II (Lab)', '', 3.0),
    ('CHEM 10600', 'CHEM', 'General Chemistry Laboratory', '', 3.0),
    ('CHEM 11100', 'CHEM', 'Chemical Principles', '', 3.0),
    ('CHEM 12000', 'CHEM', 'Essentials of Organic Chemistry (Lecture)', '', 3.0),
    ('CHEM 12100', 'CHEM', 'Essentials of Organic Chemistry (Lab)', '', 3.0),
    ('GEOL 10100', 'GEOL', 'Introductory Geology Lab', '', 3.0),
    ('POLSC 25000', 'Comparing Countries', '', 3.0), -- 
    ('FILM 10100', 'Introduction to Cinema', '', 3.0),
    ('SOC 10100', 'Introduction to Sociology', '', 3.0),
    ('ASIAN 21000', 'Asians in the United States', '', 3.0),
    ('CSCI 12700', 'Introduction: Computer Science', '', 3.0),
    ('MEDIA 29853', 'Film Genre: Horror Film', '', 3.0);


INSERT INTO course_type (type_name) VALUES 
    ('CS Major Core'),
    ('CS Major Elective'), 
    ('Scientific World, Mathematical and Quantitative Reasoning'), 
    ('English Composition'),
    ('Life & Physical Sciences'),
    ('Creative Expression'),
    ('U.S. Experiences in its Diversity'),
    ('World Cultures and Global Issues'),  
    ('Individual and Society - Social Science'),
    ('Individual and Society - Humanities, Cultures and Ideas, Writing Requirement'),
    ('Pluralism & Diversity Group A: Non-European Societies'), 
    ('Pluralism & Diversity Group B: Groups in the U.S.A.'),
    ('Pluralism & Diversity Group C: Women, Gender & Sexual Orientation'), 
    ('Pluralism & Diversity Group D: European Societies')
ON CONFLICT (type_name) DO NOTHING;


INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 12700', type_id FROM course_type WHERE type_name IN ('CS Major Core', 'Scientific World');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 13500', type_id FROM course_type WHERE type_name IN ('CS Major Core');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 15000', type_id FROM course_type WHERE type_name IN ('CS Major Core');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 23500', type_id FROM course_type WHERE type_name IN ('CS Major Core');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 26500', type_id FROM course_type WHERE type_name IN ('CS Major Core');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 16000', type_id FROM course_type WHERE type_name IN ('CS Major Core');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 26000', type_id FROM course_type WHERE type_name IN ('CS Major Core');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 33500', type_id FROM course_type WHERE type_name IN ('CS Major Core');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 34000', type_id FROM course_type WHERE type_name IN ('CS Major Core');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 49900', type_id FROM course_type WHERE type_name IN ('CS Major Core');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 43500', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 43500', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 35000', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 35300', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 36000', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 36500', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39100', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39200', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39300', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39535', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39536', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39540', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39541', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39542', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39543', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39544', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39548', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39597', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 39598', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 40500', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 43500', type_id FROM course_type WHERE type_name IN ('CS Major Elective');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MATH 15000', type_id FROM course_type WHERE type_name IN ('CS Major Core', 'Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MATH 15500', type_id FROM course_type WHERE type_name IN ('CS Major Core', 'Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'STAT 21300', type_id FROM course_type WHERE type_name IN ('CS Major Core', 'Mathematical and Quantitative Reasoning');

INSERT INTO course_type_map (course_id, type_id)
SELECT 'ENGL 12000', type_id FROM course_type WHERE type_name IN ('English Composition');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'ENGL 22000', type_id FROM course_type WHERE type_name IN ('English Composition');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'ENGL 220HS', type_id FROM course_type WHERE type_name IN ('English Composition');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'ASIAN 22100', type_id FROM course_type WHERE type_name IN ('English Composition', 'Writing Requirement');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MEDIA 21100', type_id FROM course_type WHERE type_name IN ('English Composition', 'Writing Requirement');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'AFPRL 23800', type_id FROM course_type WHERE type_name IN ('English Composition');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'CSCI 12100', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'ECO 22100', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MATH 10000', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MATH 10200', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MATH 10400', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MATH 12400', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MATH 12500', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MATH 12550', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'MATH 15200', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'STAT 11300', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'STAT 21200', type_id FROM course_type WHERE type_name IN ('Mathematical and Quantitative Reasoning');

INSERT INTO course_type_map (course_id, tag_id)
SELECT c.course_id, t.type_id
FROM courses c
JOIN course_type t ON t.type_name = 'Life and Physical Sciences'
WHERE c.course_id IN (
  'ANTHP 10100',
  'ANTHP 10500',
  'ASTRO 10200',
  'BIOL 10000',
  'BIOL 10500',
  'BIOL 10700',
  'BIOL 12500',
  'BIOL 15000',
  'CHEM 10100',
  'CHEM 101HE',
  'CHEM 101LB',
  'CHEM 10300',
  'CHEM 103HE',
  'CHEM 10500',
  'CHEM 10600',
  'CHEM 11100',
  'CHEM 12000',
  'CHEM 12100',
  'GEOL 10100'
)
ON CONFLICT DO NOTHING;

INSERT INTO course_type_map (course_id, type_id)
SELECT 'POLSC 25000', type_id FROM course_type WHERE type_name IN ('World Cultures and Global Issues', 'Pluralism & Diversity Group A: Non-European Societies');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'FILM 10100', type_id FROM course_type WHERE type_name IN ('Creative Expression');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'SOC 10100', type_id FROM course_type WHERE type_name IN ('Individual and Society - Social Science');
INSERT INTO course_type_map (course_id, type_id)
SELECT 'ASIAN 21000', type_id FROM course_type WHERE type_name IN ('Individual and Society - Humanities, Cultures and Ideas', 'Pluralism & Diversity Group B: Groups in the U.S.A.');

SELECT course_id, title, credits
FROM courses
ORDER BY course_id;

SELECT c.course_id, c.title, t.type_name
FROM course_type_map m
JOIN courses c ON c.course_id = m.course_id
JOIN course_type t ON t.type_id = m.type_id
ORDER BY c.course_id, t.type_name;