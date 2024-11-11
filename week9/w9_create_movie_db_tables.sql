-- CREATE DATABASE
DROP DATABASE week_9_movie_view_trigger_example;

CREATE DATABASE week_9_movie_view_trigger_example;
USE week_9_movie_view_trigger_example;

-- CREATE TABLEs
CREATE TABLE movie (
  movie_id INT AUTO_INCREMENT,
  title VARCHAR(100),
  minute_runtime INT,
  release_date DATE,
  PRIMARY KEY (movie_id)
);
CREATE TABLE director (
  director_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  birth_date DATE,
  PRIMARY KEY (director_id)
);
CREATE TABLE movie_director (
  movie_id INT,
  director_id INT,
  PRIMARY KEY (movie_id ,director_id),
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  FOREIGN KEY (director_id) REFERENCES director(director_id)
);
CREATE TABLE user(
  username VARCHAR(255),
  email VARCHAR(255) UNIQUE NOT NULL,
  bio VARCHAR(2000) DEFAULT 'Movie movie! WOO!',
  last_review_id INT,
  PRIMARY KEY (username)
);
CREATE TABLE review (
  review_id INT AUTO_INCREMENT,
  title VARCHAR(255),
  username VARCHAR(255) NOT NULL,
  rating DECIMAL(2,1) NOT NULL,
  content VARCHAR(2000),
  last_update DATETIME,
  movie_id INT NOT NULL,
  PRIMARY KEY (review_id),
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  CHECK (rating >= 0 AND rating <= 5)
);

-- CHECK for empty string emails && add foreign key ref to last review
ALTER TABLE user
  ADD CHECK (email <> '');
ALTER TABLE user
  ADD FOREIGN KEY (last_review_id) REFERENCES review(review_id);

-- INSERT data
INSERT INTO movie (title, minute_runtime, release_date)
  VALUES ('The Banshees of Inisherin', 109, '2022-10-21'),
  ('The Truman Show', 107, '1998-06-05'),
  ('The Dark Knight', 152, '2008-07-18'),
  ('O Brother, where art thou?', 107, '2000-08-30'),
  ('Moana 2', 152, '2024-11-27'),
  ('Get Away', 104, '2024-12-06'),
  ('The Lord of the Rings: The War of the Rohirrim', 123, '2024-12-13'),
  ('Sonic the Hedgehog 3', 102, '2024-12-20'),
  ('Nosferatu', 99, '2024-12-25'),
  ('Paddington in Peru', 134, '2025-01-17'),
  ('Captain America: Brave New World', 108, '2025-02-14');
INSERT INTO director (name)
  VALUES ('Martin McDonagh'),
  ('Peter Weir'),
  ('Christopher Nolan'),
  ('Joel Coen'),('Ethan Coen'),
  ('David G. Derrick Jr.'),('Jason Hand'),('Dana Ledoux Miller'),
  ('Steffen Haars'),
  ('Kenji Kamiyama'),
  ('Jeff Fowler'),
  ('Robert Eggers'),
  ('Dougal Wilson'),
  ('Julius Onah');
INSERT INTO movie_director (movie_id, director_id)
  VALUES (1,1),
  (2,2),
  (3,3),
  (4,4),(4,5),
  (5,6),(5,7),(5,8),
  (6,9),
  (7,10),
  (8,11),
  (9,12),
  (10,13),
  (11,14);

-- VIEWS Examples
--  CREATE coming soon movies VIEW
CREATE VIEW movie_coming_soon AS
  SELECT m.title, m.release_date, d.name
  FROM movie m INNER JOIN movie_director md ON m.movie_id=md.movie_id LEFT JOIN director d ON md.director_id=d.director_id
  WHERE DATE(m.release_date) > NOW();
SELECT * FROM movie_coming_soon;

--  New records are automatically added to the views, since each time we access a view the view runs its query again
INSERT INTO movie (title, minute_runtime, release_date)
  VALUES ('Wicked', 160, '2025-11-22');
INSERT INTO director (name)
  VALUES ('Jon M. Chu');
INSERT INTO movie_director (movie_id, director_id)
  VALUES (12,15);
-- More view examples
--  New table nominee holds movie reference and what the movie is nominated for
CREATE TABLE nominee (
  nominee_id INT AUTO_INCREMENT,
  category VARCHAR(255),
  movie_id INT NOT NULL,
  PRIMARY KEY (nominee_id),
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  CHECK (movie_id > 0)
);
INSERT INTO nominee (category, movie_id)
  VALUES 
  ("Best Director",5),
  ("Movie of the Year",5),
  ("Best Director",6),
  ("Movie of the Year",7),
  ("Best Director",7),
  ("Best Director",8),
  ("Movie of the Year",9);

--  The 2 created views below display nominees for different awards
--  This view contains all the best movie nominees
CREATE VIEW best_movie_nominee AS
  SELECT m.title AS "Movie of the Year Nominee"
  FROM nominee n 
  LEFT JOIN movie m ON n.movie_id=m.movie_id
  WHERE n.category = "Movie of the Year";
SELECT * FROM best_movie_nominee;

--  This view contains all the best director nominees
CREATE VIEW best_director_nominee AS
  SELECT d.name AS "Best Director Nominee", m.title
  FROM nominee n 
  LEFT JOIN movie m ON n.movie_id=m.movie_id 
  INNER JOIN movie_director md ON m.movie_id=md.movie_id 
  LEFT JOIN director d ON md.director_id=d.director_id
  WHERE n.category = "Best Director";
SELECT * FROM best_director_nominee;

--  New records are automatically added to the views 
INSERT INTO movie (title, minute_runtime, release_date)
  VALUES ('Civil War', 109, '2024-04-12');
INSERT INTO director (name)
  VALUES ('Alex Garland');
INSERT INTO movie_director (movie_id, director_id)
  VALUES (13,16);
INSERT INTO nominee (category, movie_id)
  VALUES 
  ("Best Director",13),
  ("Movie of the Year",13);

SELECT * FROM best_movie_nominee;
SELECT * FROM best_director_nominee;

--  Example View 3
--   Uses GROUP_CONCAT function to list all directors for each movie in 1 line
CREATE VIEW movie_with_director AS
  SELECT m.title AS "Film Title", GROUP_CONCAT(distinct d.name SEPARATOR ', ') AS "Directors"
    FROM movie m 
    INNER JOIN movie_director md ON m.movie_id=md.movie_id 
    INNER JOIN director d ON md.director_id=d.director_id
    GROUP BY m.title;

--  Example View 4
--   Create a view that selects reviews with a rating 4 or higher
CREATE VIEW review_rating_above_four AS
  SELECT m.title, r.content, CONCAT(r.rating,"/5")
  FROM movie m INNER JOIN review r ON m.movie_id=r.movie_id
  WHERE r.rating >= 4;
SELECT * FROM review_rating_above_four;

-- DELETE views
DROP VIEW review_rating_above_four;
DROP VIEW movie_with_director;

-- TRIGGERS Examples
--  This trigger will be executed when an INSERT event occurs on the review table
--  The trigger will execute the query that is defined between the BEGIN and END keywords
--  The query will execute AFTER the new review has been inserted
--  The NEW prefix will get the newest review_id in the table, AKA the review_id from the latest inserted row
CREATE TRIGGER update_after_latest_review
  AFTER INSERT ON review
  FOR EACH ROW
    UPDATE user 
    SET last_review_id = NEW.review_id
    WHERE username=NEW.username;

-- same trigger as above but shown with delimiter, begin, end syntax
DELIMITER // -- Temporarily change the DELIMITER from ; to // 
CREATE OR REPLACE TRIGGER update_after_latest_review
  AFTER INSERT ON review
  FOR EACH ROW
  BEGIN
    UPDATE user 
    SET last_review_id = NEW.review_id
    WHERE username=NEW.username;
  END//
DELIMITER ; -- Revert the DELIMITER back to ; 

-- Create multiple users
INSERT INTO user(username,email)
  VALUES ('humber_bebis', 'humber.bebis@humber.ca'),
  ('movie_girl_99', 'movie99@movies.ca'),
  ('movie_dude_1021', 'moviedude1021@movies.ca'),
  ('movie_reviewer_9000', '9000reviews@movies.ca');
--  Create multiple reviews by users(5 rows created here)
--   FOR EACH new ROW inserted, after the insert is compelte, the trigger query is executed (5 rows, 5 executions)
INSERT INTO review (username,rating,movie_id,content)
  VALUES ('humber_bebis',4.5,1,"This movie rocks!"),
  ('humber_bebis',0.4,5,"This movie sucks!"),
  ('movie_girl_99',4,3,"Amazing!"),
  ('movie_girl_99',0,11,"awful."),
  ('movie_dude_1021',5,7,"Oscar or riot!");
-- Select all fields from user, notice a review_id has been filled in the last_review_id column
SELECT * FROM user;

-- Now we can create a join to get all the users and their latest reviews if they exist
--  This query will get all the users, and will show us only thier latest reviews
--  if they have not reviewed anything we will see NULL values in their row.
SELECT u.username, r.rating, r.content, m.title AS "Last Film Reviewed by User" 
  FROM user u 
  LEFT JOIN review r ON u.last_review_id=r.review_id
  LEFT JOIN movie m ON r.movie_id=m.movie_id;

-- We can even turn this into a view to quickly retrieve the latest reviews of our users
CREATE VIEW user_latest_movie_review AS
  SELECT u.username, r.rating, r.content, m.title AS "Last Film Reviewed by User" 
    FROM user u 
    LEFT JOIN review r ON u.last_review_id=r.review_id
    LEFT JOIN movie m ON r.movie_id=m.movie_id;

