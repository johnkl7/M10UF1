DROP DATABASE IF EXISTS evilcorp;
CREATE DATABASE evilcorp;
USE evilcorp;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS conditions;
DROP TABLE IF EXISTS medicines;

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
('Vil','gatos','root3',MD5('passwd'),'USA');

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

CREATE VIEW total_cost AS SELECT treatments.id_medicine, COUNT(treatments.id_treatment) medicines, medicines.cost, sum(medicines.cost) total_cost FROM medicines LEFT JOIN treatments on medicines.id_medicine = treatments.id_medicine GROUP BY cost;

CREATE VIEW all_costs AS SELECT sum(total_cost) FROM total_cost;
