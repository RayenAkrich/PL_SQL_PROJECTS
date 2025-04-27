use GESCOM;
-- 1. Numéros des commandes A200 est supérieure à 4.
DELIMITER $$ 
CREATE PROCEDURE CommandesA200Sup4()
BEGIN
    SELECT DISTINCT Numcom 
    FROM LigCom 
    WHERE Refart = 'A200' AND Qtecom > 4;
END $$
DELIMITER ;
Call CommandesA200Sup4()

-- 3. Nombre de Commandes
DELIMITER $$
CREATE PROCEDURE NombreCommandesA200Sup4()
BEGIN
    SELECT COUNT(DISTINCT Numcom)
    FROM LigCom 
    WHERE Refart = 'A200' AND Qtecom > 4;
END $$
DELIMITER ;

-- 4. Transformation en Fonction
DELIMITER $$
CREATE FUNCTION NombreCommandesA200Sup4Func() 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(DISTINCT Numcom) INTO total 
    FROM LigCom 
    WHERE Refart = 'A200' AND Qtecom > 4;
    RETURN total;
END $$
DELIMITER ;

-- 5. Articles les Moins Chers avec Fonction
	-- Fonction pour le prix minimal
DELIMITER $$
CREATE FUNCTION GetMinPaart() 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE min_pa DECIMAL(10,2);
    SELECT MIN(Paart) INTO min_pa FROM Articles;
    RETURN min_pa;
END $$
DELIMITER ;
	-- Bloc principal (exemple d'utilisation)
SELECT Refart, Libart, Paart 
FROM Articles 
WHERE Paart = GetMinPaart();

-- 6. Procédure procnbrCat
DELIMITER $$
CREATE PROCEDURE procnbrCat()
BEGIN
    SELECT Cateclt, COUNT(*) AS TotalClients
    FROM Clients
    GROUP BY Cateclt
    HAVING TotalClients > 50;
END $$
DELIMITER ;

-- 7. Procédure procMajpv
DELIMITER $$
CREATE PROCEDURE procMajpv(IN valdif DECIMAL(10,2), IN paugt INT)
BEGIN
    UPDATE Articles
    SET Pvart = Pvart * (1 + paugt / 100)
    WHERE (Pvart - Paart) <= valdif;
END $$
DELIMITER ;