DROP DATABASE IF EXISTS evilcorp;
CREATE DATABASE evilcorp;
USE evilcorp;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS conditions;
DROP TABLE IF EXISTS medicines;

DROP FUNCTION IF EXISTS get_city;

DELIMITER $$
CREATE FUNCTION get_city(city_name VARCHAR(64), country_name VARCHAR(64), planet_name VARCHAR(64))
RETURNS INT UNSIGNED
BEGIN
DECLARE planet_id INT UNSIGNED;
DECLARE country_id INT UNSIGNED;
DECLARE city_id INT UNSIGNED;


SELECT id_planet INTO planet_id FROM planets WHERE name = planet_name;

IF planet_id IS NULL THEN
INSERT INTO planets (name) VALUES (planet_name);
SET planet_id = LAST_INSERT_ID();
END IF;


SELECT id_country INTO country_id FROM countries WHERE country = country_name AND id_planet = planet_id;

IF country_id IS NULL THEN
INSERT INTO countries (country, id_planet) VALUES (country_name, planet_id);
SET country_id = LAST_INSERT_ID();
END IF;


SELECT id_city INTO city_id FROM cities WHERE city = city_name AND id_country = country_id;

IF city_id IS NULL THEN
INSERT INTO cities (city, id_country) VALUES (city_name, country_id);
SET city_id = LAST_INSERT_ID();
ELSE
SET city_id = (SELECT id_city FROM cities WHERE city = city_name AND id_country = country_id LIMIT 1);
END IF;

RETURN city_id;
END$$
DELIMITER ;


CREATE TABLE users (
	id_user INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name varchar(24) NOT NULL,
	surname varchar(32) NOT NULL,
	username varchar(24) NOT NULL,
	password varchar(50) NOT NULL,
	country char(3)
);

CREATE TABLE medicines (
	id_medicine INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name varchar(192) NOT NULL,
	invented_by varchar(24) NOT NULL,
	side_effects text NOT NULL,
	cost decimal(9,2) NOT NULL,
	sale_price decimal(9,2) NOT NULL
);

CREATE TABLE conditions (
	id_condition INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
	name varchar(64) NOT NULL,
	deadly boolean NOT NULL,
	description TEXT NOT NULL,
	symptoms TEXT NOT NULL
);

CREATE TABLE doctors (
	id_doctor INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	doctor varchar(32) NOT NULL
);

CREATE TABLE diagnoses (
	id_diagnose INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	diagnose TEXT NOT NULL,
	date DATETIME NOT NULL,
	id_condition INT UNSIGNED NOT NULL,
	id_user INT UNSIGNED NOT NULL,
	id_doctor INT UNSIGNED NOT NULL,
	FOREIGN KEY (id_condition) REFERENCES conditions(id_condition),
	FOREIGN KEY (id_user) REFERENCES users(id_user),
	FOREIGN KEY (id_doctor) REFERENCES doctors(id_doctor)
);

CREATE TABLE treatments (
	id_treatment INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	id_diagnose INT UNSIGNED NOT NULL,
	id_medicine INT UNSIGNED NOT NULL,
	description TEXT NOT NULL,
	FOREIGN KEY (id_diagnose) REFERENCES diagnoses(id_diagnose),
  FOREIGN KEY (id_medicine) REFERENCES medicines(id_medicine)
);

INSERT INTO users (name,surname,username,password,country)
VALUES
('Hilon','Musg','root',MD5('password'),'USA'),
('Jeb','Besos','root2',MD5('pass'),'USA'),
('Vil','gatos','root3',MD5('passwd'),'USA'),
('Mark','Cucumber','root4',MD5('pass123'),'USA'),
('Hilon Jr','Musg','hijo', MD5('venus'),'USA'),
('Jeb Jr','Besos','amazon',MD5('baldpower'),'USA'),
('Vil Jr','gatos','ihatelinux',MD5('passroot'),'USA'),
('Mark Jr','Cucumber','root5',MD5('meta'),'USA'),
('Vladimir','Putin','russiafirst',MD5('motherrussia'),'RUS'),
('Aleksandr','Dugin','eurasia',MD5('eurasia123'),'RUS'),
('Xi','Jinpin','CCP',MD5('madeinchina'),'CHN');

INSERT INTO doctors (doctor)
VALUES
('Fauci'),
('Frankenstein');

INSERT INTO medicines (name,invented_by,side_effects,cost,sale_price)
VALUES
("Paxlovid","Pfizer","nausea, muscle aches, skin rash, increased blood preasure",400.0,530.0),
("Adderall","ShireLCC","nausea, decreased appetite, headache, difficulty sleeping",150.5,284.5),
("Humulin","Eli Lilly","low blood sugar, weight gain, skin rash",40.0,54.5),
("Tamiflu","Gilead Sciences","nausea, vomiting, nosebleeds, headache, fatigue",53.5,60.3);

INSERT INTO conditions (name,deadly,description,symptoms)
VALUES
("covid19",1,"Infectious disease caused by the SARS-coV-2 virus","fever,cough,tiredness,loss of taste or smell, difficulty breathing"),
("ebola",1,"Severe and often fatal illness caused by the Ebola virus","fever, headache, muscle pain, weakness, fatigue, vomiting"),
("Diabetes2",0,"Chronic condition that affects the way the body processes blood sugar","fatigue,blurred vision, frequent infections, slow healing"),
("flu",0,"Viral respiratory illness","fever, cough, body aches, chills, fatigue"),
("Pancreatic cancer",1,"Abnormal number of cells grow and divide in the pancreas","back pain,nausea,vomiting,weight loss"),
("ADHD",0,"Attention deficit and hyperactivity","inattention, hyperactivity, impulsivity,fidgeting");

INSERT INTO diagnoses (diagnose,date,id_condition,id_user,id_doctor)
VALUES
("Severe COVID-19","2012-12-12 10:31:04",1,1,1),
("Attention-Deficit/Hyperactive disorder","2013-12-12 09:30:02",4,1,1),
("Type 2 diabetes mellitus","2008-12-12 16:30:02",3,2,2),
("Influenza A","2015-05-05 15:00:00",4,3,2);

INSERT INTO treatments (id_diagnose,id_medicine,description)
VALUES
(1,1,"Antiviral medications"),
(2,2,"Oral treatment"),
(3,3,"Injection"),
(4,4,"Oral treatment"),
(4,1,"Oral treatment");





DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS doors;
DROP TABLE IF EXISTS street_numbers;
DROP TABLE IF EXISTS staircases;
DROP TABLE IF EXISTS floors;
DROP TABLE IF EXISTS zip_codes;
DROP TABLE IF EXISTS streets;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS planets;

CREATE TABLE planets (
	id_planet INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(64)
);

CREATE TABLE countries (
	id_country INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	country VARCHAR(64),
	id_planet INT UNSIGNED,
	FOREIGN KEY (id_planet) REFERENCES planets(id_planet)
);

CREATE TABLE cities (
	id_city INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	city VARCHAR(64),
	id_country INT UNSIGNED,
	FOREIGN KEY (id_country) REFERENCES countries(id_country)
);

CREATE TABLE streets (
	id_street INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	street VARCHAR(124),
	id_city INT UNSIGNED,
	FOREIGN KEY (id_city) REFERENCES cities(id_city)
);

CREATE TABLE street_numbers (
	id_street_number INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	street_number VARCHAR(32)
);

CREATE TABLE staircases (
	id_staircase INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	staircase VARCHAR(32)
);

CREATE TABLE zip_codes (
  id_zip_code INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	zip_code VARCHAR(32)
);

CREATE TABLE floors (
	id_floor INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	floor varchar(32)
);

CREATE TABLE doors (
	id_door INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	door VARCHAR(32)
);

CREATE TABLE addresses (
	id_address BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	id_user INT UNSIGNED,
	id_street INT UNSIGNED,
	id_street_number INT UNSIGNED,
	id_staircase INT UNSIGNED,
	id_floor INT UNSIGNED,
	id_door INT UNSIGNED,
	id_zip_code INT UNSIGNED,
	FOREIGN KEY (id_street) REFERENCES streets(id_street),
  FOREIGN KEY (id_street_number) REFERENCES street_numbers(id_street_number),
	FOREIGN KEY (id_staircase) REFERENCES staircases(id_staircase),
	FOREIGN KEY (id_floor) REFERENCES floors(id_floor),
	FOREIGN KEY (id_door) REFERENCES doors(id_door),
	FOREIGN KEY (id_zip_code) REFERENCES zip_codes(id_zip_code)
);

INSERT INTO planets (name)
VALUES
("Earth"),
("Mars"),
("Venus"),
("Saturn"),
("Jupiter"),
("Neptune"),
("Uranus"),
("Mercury"),
("Proxima Centauri b");

INSERT INTO countries (country,id_planet)
VALUES
("Tesla",2),
("USA",1),
("Soviet Union",1),
("SpaceX",2),
("Blue",6),
("Catalunya",3),
("Mesopotamia",9),
("China",1),
("Hurra",7);

INSERT INTO cities (city,id_country)
VALUES
("New York city",2),
("Washington D.C.",2),
("Moscow",3),
("Saint Petersburg",3),
("Blue city",5),
("Beijing",8),
("HongKong",8),
("SpaceX city",1),
("Uruk",7),
("Barcelona",6);

INSERT INTO street_numbers (street_number)
VALUES
("1"),
("2"),
("3"),
("4"),
("5"),
("6"),
("7"),
("8"),
("9"),
("10"),
("11"),
("12"),
("13"),
("14"),
("15");

INSERT INTO streets (street,id_city)
VALUES
("Kremlin",3),
("1600 Pennsylvania Avenue NW",2),
("Nevsky Prospekt",3),
("Chang'an Avenue",7),
("Amazon avenue",1),
("Microsoft avenue",2),
("Meta street",8),
("DogCoin street",8),
("Marduk",9),
("Enti street", get_city('Barcelona','Catalunya','Venus'));

INSERT INTO floors (floor)
VALUES
("1"),
("2"),
("3"),
("4"),
("5"),
("6"),
("7"),
("8"),
("9"),
("10"),
("11"),
("12"),
("13"),
("14"),
("15");

INSERT INTO doors (door)
VALUES
("1"),
("2"),
("3"),
("4"),
("5"),
("6"),
("7"),
("8"),
("9"),
("10"),
("11"),
("12"),
("13"),
("14"),
("15");

INSERT INTO staircases (staircase)
VALUES
("1"),
("2"),
("3"),
("4"),
("5"),
("6"),
("7"),
("8"),
("9"),
("10"),
("11"),
("12"),
("13"),
("14"),
("15");

INSERT INTO zip_codes (zip_code)
VALUES
("10020"),  
("20020"), 
("065001"), 
("103132"), 
("187015"), 
("meta01"),
("Dog01"),
("Enlil020"),
("08018");

INSERT INTO addresses (id_user,id_street,id_street_number,id_staircase,id_floor,id_door,id_zip_code)
VALUES
(2,2,15,1,1,1,1),
(9,1,15,3,3,1,3),
(9,9,4,1,1,1,8),
(10,3,2,5,5,1,4),
(11,4,1,2,2,1,5),
(1,2,15,2,2,1,1),
(1,8,1,10,10,1,7),
(4,7,2,5,5,1,6),
(5,2,2,1,1,1,7),
(6,2,15,2,2,1,1),
(6,5,1,10,10,1,2),
(4,5,2,10,10,1,2),
(9,10,4,1,1,1,9),
(1,9,2,1,1,1,8),
(11,7,3,1,1,1,7);

CREATE VIEW total_cost AS SELECT treatments.id_medicine, COUNT(treatments.id_treatment) medicines, medicines.cost, sum(medicines.cost) total_cost FROM medicines LEFT JOIN treatments on medicines.id_medicine = treatments.id_medicine GROUP BY cost;

CREATE VIEW all_costs AS SELECT sum(total_cost) FROM total_cost;


CREATE VIEW planet_addresses AS
SELECT planets.name AS planet, COUNT(addresses.id_address) AS address_count
FROM planets
JOIN countries ON countries.id_planet = planets.id_planet
JOIN cities ON cities.id_country = countries.id_country
JOIN streets ON streets.id_city = cities.id_city
JOIN addresses ON addresses.id_street = streets.id_street
GROUP BY planets.name;

