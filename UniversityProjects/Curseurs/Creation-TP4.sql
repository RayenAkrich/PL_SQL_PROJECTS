-- -----------------------------------------
-- Exercice 1 : Création des tables GESCOM
-- -----------------------------------------
CREATE DATABASE IF NOT EXISTS GESCOM;
USE GESCOM;

-- Table Articles
CREATE TABLE Articles (
    Refart VARCHAR(10) PRIMARY KEY,
    Libart VARCHAR(50),
    Coulart VARCHAR(20),
    Pvart DECIMAL(10,2),
    Qstart INT,
    Paart DECIMAL(10,2)
) ENGINE=InnoDB;

-- Table Clients
CREATE TABLE Clients (
    Codeclt INT PRIMARY KEY,
    Nomclt VARCHAR(50),
    Prenonclt VARCHAR(50),
    Cateclt VARCHAR(20),
    Adrclt VARCHAR(100),
    Cpclt VARCHAR(10),
    Villeclt VARCHAR(50)
) ENGINE=InnoDB;

-- Table Commandes
CREATE TABLE Commandes (
    Numcom INT PRIMARY KEY,
    Datecom DATE,
    Codeclt INT,
    FOREIGN KEY (Codeclt) REFERENCES Clients(Codeclt)
) ENGINE=InnoDB;

-- Table LigCom
CREATE TABLE LigCom (
    Numcom INT,
    Refart VARCHAR(10),
    Qtecom INT,
    PRIMARY KEY (Numcom, Refart),
    FOREIGN KEY (Numcom) REFERENCES Commandes(Numcom),
    FOREIGN KEY (Refart) REFERENCES Articles(Refart)
) ENGINE=InnoDB;

-- Données d'exemple pour GESCOM
INSERT INTO Articles VALUES 
('A200', 'Clavier mécanique', 'Noir', 59.99, 100, 30.00),
('B450', 'Souris sans fil', 'Blanc', 29.99, 200, 12.50),
('C100', 'Écran 24"', 'Gris', 149.99, 50, 80.00);

INSERT INTO Clients VALUES 
(101, 'Dupont', 'Jean', 'VIP', '12 Rue de Paris', '75000', 'Paris'),
(102, 'Martin', 'Alice', 'Standard', '5 Avenue Lyon', '69000', 'Lyon');

INSERT INTO Commandes VALUES 
(1001, '2024-01-15', 101),
(1002, '2024-02-20', 102);

INSERT INTO LigCom VALUES 
(1001, 'A200', 5),
(1001, 'B450', 2),
(1002, 'A200', 3),
(1002, 'C100', 1);

-- -----------------------------------------
-- Exercice 2 : Création des tables Enseignement
-- -----------------------------------------
CREATE DATABASE IF NOT EXISTS ENSEIGNEMENT;
USE ENSEIGNEMENT;

-- Table grade
CREATE TABLE grade (
    legrade CHAR(10) PRIMARY KEY,
    nomgrade CHAR(30),
    hstat INT
) ENGINE=InnoDB;

-- Table enseignant
CREATE TABLE enseignant (
    noinsee CHAR(10) PRIMARY KEY,
    nomp CHAR(10),
    prenomp CHAR(10),
    legrade CHAR(10),
    ville CHAR(10),
    FOREIGN KEY (legrade) REFERENCES grade(legrade)
) ENGINE=InnoDB;

-- Table type
CREATE TABLE type (
    letype INT PRIMARY KEY,
    nomtype CHAR(10)
) ENGINE=InnoDB;

-- Table filiere
CREATE TABLE filiere (
    codef CHAR(10) PRIMARY KEY,
    nomf CHAR(30)
) ENGINE=InnoDB;

-- Table UNITE
CREATE TABLE UNITE (
    codef CHAR(10),
    nunite CHAR(30),
    coef INT,
    PRIMARY KEY (codef, nunite),
    FOREIGN KEY (codef) REFERENCES filiere(codef)
) ENGINE=InnoDB;

-- Table service
CREATE TABLE service (
    noinsee CHAR(10),
    codef CHAR(10),
    nunite CHAR(30),
    letype INT,
    heures INT,
    PRIMARY KEY (noinsee, codef, nunite, letype),
    FOREIGN KEY (noinsee) REFERENCES enseignant(noinsee),
    FOREIGN KEY (letype) REFERENCES type(letype),
    FOREIGN KEY (codef, nunite) REFERENCES UNITE(codef, nunite)
) ENGINE=InnoDB;

-- Données d'exemple pour Enseignement
INSERT INTO grade VALUES 
('GRADE1', 'Professeur', 192),
('GRADE2', 'Maître de conférences', 180);

INSERT INTO enseignant VALUES 
('E001', 'Durand', 'Pierre', 'GRADE1', 'Paris'),
('E002', 'Leroy', 'Sophie', 'GRADE2', 'Lyon');

INSERT INTO type VALUES 
(1, 'Cours'),
(2, 'TD');

INSERT INTO filiere VALUES 
('F1', 'Informatique'),
('F2', 'Mathématiques');

INSERT INTO UNITE VALUES 
('F1', 'Algorithmique', 4),
('F1', 'Base de données', 5);

INSERT INTO service VALUES 
('E001', 'F1', 'Algorithmique', 1, 40),
('E002', 'F1', 'Base de données', 2, 30);

-- -----------------------------------------
-- Exercice 3 : Création des tables Immobilier
-- -----------------------------------------
CREATE DATABASE IF NOT EXISTS IMMOBILIER;
USE IMMOBILIER;

-- Table Immeuble
CREATE TABLE Immeuble (
    adresse VARCHAR(100) PRIMARY KEY,
    nbEtages INT,
    dateConstruction YEAR,
    nomProprietaire VARCHAR(50)
) ENGINE=InnoDB;

-- Table Appartement
CREATE TABLE Appartement (
    adresse VARCHAR(100),
    numAppartement INT,
    nomOccupant VARCHAR(50),
    type VARCHAR(20),
    superficie INT,
    etage INT,
    PRIMARY KEY (adresse, numAppartement),
    FOREIGN KEY (adresse) REFERENCES Immeuble(adresse)
) ENGINE=InnoDB;

-- Table Personne
CREATE TABLE Personne (
    nom VARCHAR(50),
    adresse VARCHAR(100),
    numAppartement INT,
    dateArrivée DATE,
    dateDepart DATE,
    age INT,
    profession VARCHAR(50),
    PRIMARY KEY (nom, adresse, numAppartement),
    FOREIGN KEY (adresse, numAppartement) REFERENCES Appartement(adresse, numAppartement)
) ENGINE=InnoDB;

-- Données d'exemple pour Immobilier
INSERT INTO Immeuble VALUES 
('12 Rue de Paris', 6, 1945, 'Dupont'),
('5 Avenue Lyon', 4, 1960, 'Martin');

INSERT INTO Appartement VALUES 
('12 Rue de Paris', 1, 'Jean', 'T2', 50, 2),
('12 Rue de Paris', 2, NULL, 'T3', 70, 3),
('5 Avenue Lyon', 1, 'Alice', 'T1', 30, 1);

INSERT INTO Personne VALUES 
('Jean', '12 Rue de Paris', 1, '2020-01-01', NULL, 35, 'Ingénieur'),
('Alice', '5 Avenue Lyon', 1, '2019-05-15', NULL, 28, 'Designer');