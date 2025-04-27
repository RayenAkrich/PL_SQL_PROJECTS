-- 1. Immeubles >5 étages et construits avant 1950
DELIMITER $$
CREATE PROCEDURE ImmeublesAnciens()
BEGIN
    SELECT adresse, nomProprietaire 
    FROM Immeuble 
    WHERE nbEtages > 5 AND dateConstruction < '1950-01-01';
END $$
DELIMITER ;

-- 2. Nombre de personnes habitant leur propre immeuble
DELIMITER $$
CREATE PROCEDURE HabitantsProprietaires()
BEGIN
    SELECT COUNT(*) AS Total
    FROM Personne p
    INNER JOIN Immeuble i ON p.adresse = i.adresse
    WHERE p.nom = i.nomProprietaire;
END $$
DELIMITER ;

-- 3. Personnes non propriétaires
DELIMITER $$
CREATE PROCEDURE NonProprietaires()
BEGIN
    SELECT nom, adresse 
    FROM Personne 
    WHERE nom NOT IN (SELECT nomProprietaire FROM Immeuble);
END $$
DELIMITER ;

-- 4. Propriétaires avec appartements vides
DELIMITER $$
CREATE PROCEDURE ProprietairesAppartementsVides()
BEGIN
    SELECT DISTINCT i.nomProprietaire, pe.profession
    FROM Immeuble i, Appartement a
    LEFT JOIN Personne pe ON 
        a.adresse = pe.adresse 
        AND a.numAppartement = pe.numAppartement
    WHERE 
        i.adresse = a.adresse 
        AND a.nomOccupant IS NULL;
END $$
DELIMITER ;