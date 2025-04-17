/*CODE MAKTOUB ALA MYSQLWORKBENCH THABET FL SYNTAXE 9BAL MA TEKHDM*/
USE TP3_DB;
DELIMITER //
CREATE PROCEDURE AfficherTop6Employes()
BEGIN
    SELECT 
        CONCAT(first_name, ' ', last_name) AS Nom,
        job_id AS Poste,
        salary AS Salaire
    FROM employees
    ORDER BY salary DESC
    LIMIT 6;
END //
DELIMITER ;

-- Appel :
CALL AfficherTop6Employes();