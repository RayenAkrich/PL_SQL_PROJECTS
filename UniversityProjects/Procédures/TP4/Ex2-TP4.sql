-- 1. Remplacer les horaires statutaires
DELIMITER $$
CREATE PROCEDURE UpdateHoraireStat()
BEGIN
    UPDATE grade 
    SET hstat = 200 
    WHERE hstat = 192;
END $$
DELIMITER ;

-- 2. Infos par Grade
DELIMITER $$
CREATE PROCEDURE GetEnseignantsParGrade(IN grade_param CHAR(10))
BEGIN
    SELECT e.* 
    FROM enseignant e
    INNER JOIN grade g ON e.legrade = g.legrade
    WHERE g.legrade = grade_param;
END $$
DELIMITER ;