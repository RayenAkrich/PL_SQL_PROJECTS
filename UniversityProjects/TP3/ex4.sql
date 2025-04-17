/*CODE MAKTOUB ALA MYSQLWORKBENCH THABET FL SYNTAXE 9BAL MA TEKHDM*/
USE TP3_DB;
	/* Question 1 :
		Le code utilise une substitution de variable (ACCEPT) pour saisir le nom du département. 
		Il insère un nouveau département avec departments_seq.NEXTVAL pour générer l'ID, 
		utilise le nom saisi et 1700 pour location_id. L
		a transaction est validée avec COMMIT.
    */
-- 1. Insertion avec AUTO_INCREMENT
DELIMITER //
CREATE PROCEDURE AjouterDepartement(IN p_dept_nom VARCHAR(30))
BEGIN
    INSERT INTO departments(department_name, location_id)
    VALUES (p_dept_nom, 1700);
    COMMIT;
    
    SELECT LAST_INSERT_ID() AS Nouveau_ID;
END //
DELIMITER ;

-- 2. Exécuter avec 'Health'
CALL AjouterDepartement('Health');

-- 3. Suppression
DELIMITER //
CREATE PROCEDURE SupprimerDepartement(IN p_dept_id INT)
BEGIN
    DELETE FROM departments 
    WHERE department_id = p_dept_id;
    
    SELECT ROW_COUNT() AS Lignes_Supprimees;
    COMMIT;
END //
DELIMITER ;

-- Appel :
CALL SupprimerDepartement(100);