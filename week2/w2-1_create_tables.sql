CREATE TABLE movie (
movie_id INT NOT NULL AUTO_INCREMENT, 
title VARCHAR(255),
runtime SMALLINT,
genre VARCHAR(255),
release_year SMALLINT,
PRIMARY KEY (movie_id)
);

INSERT INTO movie (
title,
runtime,
genre,
release_year
) VALUES 
('The Banshees of Inisherin', 109, 'Drama', 2022),
('The Truman Show', 107, 'Drama', 1998),
('Eternal Sunshine of the Spotless Mind', 108, 'Romance', 2004),
('The Dark Knight', 152, 'Action', 2008),
('The Grand Budapest Hotel', 99, 'Comedy', 2014),
('Spider-Man: Into the Spider-Verse', 116, 'Animation', 2018),
('Shrek', 89, 'Animation', 2001),
('Spirited Away', 125, 'Animation', 2001);