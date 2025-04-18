/*CODE MAKTOUB ALA MYSQLWORKBENCH THABET FL SYNTAXE 9BAL MA TEKHDM*/
CREATE DATABASE TP1_DB;
USE TP1_DB;

CREATE TABLE Appareil (
    codetype VARCHAR(10) PRIMARY KEY,
    nbplace INT,
    design VARCHAR(100)
);

CREATE TABLE Pilote (
    nopilot VARCHAR(10) PRIMARY KEY,
    nom VARCHAR(50),
    adresse VARCHAR(100),
    sal DECIMAL(10,2),
    comm DECIMAL(10,2),
    embauche DATE
);

CREATE TABLE Avion (
    nuavion VARCHAR(10) PRIMARY KEY,
    annserv YEAR,
    nom VARCHAR(50),
    nbhvol INT,
    typee VARCHAR(10),
    FOREIGN KEY (typee) REFERENCES Appareil(codetype)
);

CREATE TABLE Vol (
    novol VARCHAR(10) PRIMARY KEY,
    vildep VARCHAR(50),
    vilar VARCHAR(50),
    dep_h INT,
    dep_mn INT,
    ar_h INT,
    ar_mn INT,
    ar_jour INT
);

CREATE TABLE Affectation (
    vol VARCHAR(10),
    date_vol DATE,
    pilote VARCHAR(10),
    avion VARCHAR(10),
    nbpass INT,
    PRIMARY KEY (vol, date_vol),
    FOREIGN KEY (vol) REFERENCES Vol(novol),
    FOREIGN KEY (pilote) REFERENCES Pilote(nopilot),
    FOREIGN KEY (avion) REFERENCES Avion(nuavion)
);

-- 2. Insertion des données
INSERT INTO Vol VALUES 
('AF8810','Paris','DJERBA',9,0,11,45,0),
('AF8809','DJERBA','Paris',12,45,15,40,0),
('IW201','LYON','FORT DE FRANCE',9,45,15,25,0);

INSERT INTO Appareil VALUES 
('74E',150,'BOEING 747-400 COMBI'),
('AB3',180,'AIRBUS A300'),
('741',100,'BOEING 747-100');

INSERT INTO Pilote VALUES 
('1333','FEDOI','NANTES',24000.00,0.00,'1993-03-15'),
('6589','DUVAL','PARIS',18600.00,5580.00,'1992-03-12'),
('6723','MARTIN','ORSAY',23150.00,0.00,'1993-07-15');

INSERT INTO Avion VALUES 
('8832',1988,'Ville de paris',16000,'74E'),
('8567',1988,'Ville de Reims',8000,'741'),
('8467',1995,'Le Sud',600,'741');

