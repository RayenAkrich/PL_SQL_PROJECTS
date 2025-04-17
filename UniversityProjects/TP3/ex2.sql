/*CODE MAKTOUB ALA MYSQLWORKBENCH THABET FL SYNTAXE 9BAL MA TEKHDM*/
-- Création de la table temporaire
CREATE TEMPORARY TABLE temp (
    department_id INT,
    manager_id INT,
    total_salaire DECIMAL(10,2),
    total_commission DECIMAL(10,2),
    salaire_moyen DECIMAL(10,2)
);

DELIMITER //
CREATE PROCEDURE CalculerStatistiquesDepartement(IN p_department_id INT)
BEGIN
    DECLARE v_manager_id INT;
    DECLARE v_total_salaire DECIMAL(10,2);
    DECLARE v_total_commission DECIMAL(10,2);
    DECLARE v_salaire_moyen DECIMAL(10,2);
    
    -- 1. Récupérer le manager du département
    SELECT manager_id INTO v_manager_id
    FROM departments
    WHERE department_id = p_department_id;
    
    -- 2. Calculer le total des salaires et commissions
    SELECT 
        SUM(salary),
        SUM(salary * IFNULL(commission_pct, 0))
    INTO 
        v_total_salaire, 
        v_total_commission
    FROM employees
    WHERE department_id = p_department_id;
    
    -- 3. Calcul direct du salaire moyen (remplace la fonction fctsalaireMoy)
    SELECT AVG(salary) INTO v_salaire_moyen
    FROM employees
    WHERE department_id = p_department_id;
    
    -- 4. Insertion dans la table temporaire
    INSERT INTO temp VALUES (
        p_department_id,
        v_manager_id,
        v_total_salaire,
        v_total_commission,
        v_salaire_moyen
    );
    
    -- 5. Affichage des résultats
    SELECT * FROM temp;
    
    -- 6. Nettoyage
    DROP TEMPORARY TABLE temp;
END //
DELIMITER ;

-- Appel de la procédure
CALL CalculerStatistiquesDepartement(1);

/* FI VSCODE EKTB HAKA BCH TA3ML FUNCTION NON STOCKEE : 
    FUNCTION fctsalaireMoy(p_department_id INT) RETURNS DECIMAL(10,2)
    DETERMINISTIC
    BEGIN
        DECLARE v_moyenne DECIMAL(10,2);
        SELECT AVG(salary) INTO v_moyenne
        FROM employees
        WHERE department_id = p_department_id;
        RETURN v_moyenne;
    END; */