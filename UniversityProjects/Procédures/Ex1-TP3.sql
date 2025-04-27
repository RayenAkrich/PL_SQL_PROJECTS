/*CODE MAKTOUB ALA MYSQLWORKBENCH THABET FL SYNTAXE 9BAL MA TEKHDM*/
USE TP3_DB;
DELIMITER //
CREATE PROCEDURE AfficherRevenuEmploye(IN p_employee_id INT)
BEGIN
    DECLARE v_first_name VARCHAR(20);
    DECLARE v_last_name VARCHAR(25);
    DECLARE v_salary DECIMAL(8,2);
    DECLARE v_commission_pct DECIMAL(2,2);
    DECLARE v_revenu DECIMAL(10,2);
    
    SELECT 
        first_name, 
        last_name, 
        salary, 
        IFNULL(commission_pct, 0)
    INTO 
        v_first_name, 
        v_last_name, 
        v_salary, 
        v_commission_pct
    FROM employees
    WHERE employee_id = p_employee_id;
    
    SET v_revenu = v_salary * (1 + v_commission_pct);
    
    SELECT 
        CONCAT('Nom : ', v_first_name, ' ', v_last_name) AS Nom,
        CONCAT('Revenu mensuel : ', FORMAT(v_revenu, 2)) AS Revenu;
    
END //
DELIMITER ;

-- Appel :
CALL AfficherRevenuEmploye(100);