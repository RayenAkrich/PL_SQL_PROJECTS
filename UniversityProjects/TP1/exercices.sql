/*CODE MAKTOUB ALA MYSQLWORKBENCH THABET FL SYNTAXE 9BAL MA TEKHDM*/
-- I ) Déclaration d'un type scalaire
-- 1. Nombre de pilotes
DELIMITER //
CREATE PROCEDURE AfficherNbPilotes()
BEGIN
    SELECT CONCAT('Le nombre de pilotes existants dans la base est de: ', COUNT(*)) 
    FROM Pilote;
END //
DELIMITER ;
-- 2. Commission et embauche du pilote le mieux payé
DELIMITER //
CREATE PROCEDURE PiloteMaxSalaire()
BEGIN
    SELECT comm, embauche 
    FROM Pilote 
    ORDER BY sal DESC 
    LIMIT 1;
END //
DELIMITER ;
-- 3. Avion avec plus de 4 vols
DELIMITER //
CREATE PROCEDURE AvionPlusQuatreVols()
BEGIN
    SELECT a.nom 
    FROM Avion a
    JOIN Affectation af ON a.nuavion = af.avion
    GROUP BY a.nuavion
    HAVING COUNT(*) > 4;
END //
DELIMITER ;
-- II. Type composé
-- 4. Premier pilote embauché (deux solutions)
-- Solution scalaire
DELIMITER //
CREATE PROCEDURE PremierPiloteScalaire()
BEGIN
    SELECT nom, sal 
    FROM Pilote 
    ORDER BY embauche 
    LIMIT 1;
END //
DELIMITER ;

-- Solution avec variable composée (simulée)
DELIMITER //
CREATE PROCEDURE PremierPiloteCompose()
BEGIN
    DECLARE v_nom VARCHAR(50);
    DECLARE v_sal DECIMAL(10,2);
    
    SELECT nom, sal INTO v_nom, v_sal 
    FROM Pilote 
    ORDER BY embauche 
    LIMIT 1;
    
    SELECT v_nom AS nom, v_sal AS salaire;
END //
DELIMITER ;
-- 5. Appareil 'AB3' (deux solutions)
-- Solution scalaire
DELIMITER //
CREATE PROCEDURE InfoAppareilScalaire()
BEGIN
    SELECT 'Le code type: AB3', CONCAT('Le nombre d''avion: ', COUNT(*)) 
    FROM Avion 
    WHERE typee = 'AB3';
END //
DELIMITER ;

-- Solution avec variable composée
DELIMITER //
CREATE PROCEDURE InfoAppareilCompose()
BEGIN
    DECLARE v_code VARCHAR(10);
    DECLARE v_count INT;
    
    SELECT 'AB3', COUNT(*) INTO v_code, v_count 
    FROM Avion 
    WHERE typee = 'AB3';
    
    SELECT CONCAT('Le code type: ', v_code), CONCAT('Le nombre d''avion: ', v_count);
END //
DELIMITER ;
-- III. Structures conditionnelles
-- 6. Majoration salaire pilote 1333
DELIMITER //
CREATE PROCEDURE MajSalaire1333()
BEGIN
    DECLARE v_sal DECIMAL(10,2);
    DECLARE v_comm DECIMAL(10,2);
    
    SELECT sal, comm INTO v_sal, v_comm 
    FROM Pilote 
    WHERE nopilot = '1333';
    
    IF v_comm > v_sal THEN
        UPDATE Pilote 
        SET sal = sal * 1.12 
        WHERE nopilot = '1333';
        SELECT 'Salaire majoré de 12%';
    ELSE
        SELECT 'Salaire supérieur à la commission';
    END IF;
END //
DELIMITER ;
-- 7. Augmentation commission pilote 6723
DELIMITER //
CREATE PROCEDURE MajCommission6723()
BEGIN
    DECLARE v_nb_vols INT;
    
    SELECT COUNT(*) INTO v_nb_vols 
    FROM Affectation 
    WHERE pilote = '6723';
    
    IF v_nb_vols BETWEEN 50 AND 100 THEN
        UPDATE Pilote SET comm = comm * 1.10 WHERE nopilot = '6723';
    ELSEIF v_nb_vols > 100 THEN
        UPDATE Pilote SET comm = comm * 1.20 WHERE nopilot = '6723';
    END IF;
END //
DELIMITER ;

CALL AfficherNbPilotes();
CALL PiloteMaxSalaire();
CALL AvionPlusQuatreVols();
CALL PremierPiloteScalaire();
CALL PremierPiloteCompose();
CALL InfoAppareilScalaire();
CALL InfoAppareilCompose();
CALL MajSalaire1333();
CALL MajCommission6723();