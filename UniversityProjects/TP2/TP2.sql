SET SERVEROUTPUT ON
DROP TABLE CLIENT CASCADE CONSTRAINTS;
DROP TABLE PERSONNEL CASCADE CONSTRAINTS;
DROP TABLE COMPTECLIENT CASCADE CONSTRAINTS;
DROP TABLE OPERATION CASCADE CONSTRAINTS;
/*EXERCICE 1*/
/*1) Créer les tables suivantes :*/
CREATE TABLE CLIENT (
    numcli INT PRIMARY KEY,
    nomcli VARCHAR(30),
    prenomcli VARCHAR(30),
    adresse VARCHAR(50),
    tel INT
)
CREATE TABLE PERSONNEL (
    numpers INT PRIMARY KEY,
    nompers VARCHAR(30),
    prenompers VARCHAR(30),
    manager BOOLEAN,
    salaire NUMBER(10,2)
)
CREATE TABLE COMPTECLIENT (
    numcli INT CONSTRAINT fk_numeli REFERENCES CLIENT(numcli),
    numccl INT,
    PRIMARY KEY (numcli, numccl),
    dateoper DATE,
    montantoper NUMBER(10,2)
)
CREATE TABLE OPERATION (
    numcli INT CONSTRAINT fk_numeli REFERENCES CLIENT(numcli),
    numccl INT CONSTRAINT fk_numccl REFERENCES COMPTECLIENT(numccl),
    numoper INT,
    dateoper DATE,
    montantoper NUMBER(10,2),
    PRIMARY KEY (numcli, numccl, numoper)
)
/*2) le client dans PERSONNEL de clé primaire la plus élevée
dans la table PERSONNEL (utiliser un type composé).*/
DECLARE
    TYPE ClientType IS RECORD (
        numcli CLIENT.numcli%TYPE,
        nomcli CLIENT.nomcli%TYPE,
        prenomcli CLIENT.prenomcli%TYPE
    );
    v_max_client ClientType;
BEGIN
    SELECT numcli, nomcli, prenomcli INTO v_max_client
    FROM CLIENT
    WHERE numcli = (SELECT MAX(numcli) FROM CLIENT);

    INSERT INTO PERSONNEL (numpers, nompers, prenompers, manager, salaire)
    VALUES (v_max_client.numcli, v_max_client.nomcli, v_max_client.prenomcli, NULL, NULL);
END;
/*3)Afficher les noms et soldes < 2000 avec un type table :*/
BEGIN
    DECLARE
        TYPE PrenomList IS TABLE OF VARCHAR2(50);
        v_prenoms PrenomList := PrenomList('Mohamed', 'Aymen', 'Amira', 'Amine', 'Arwa', 'Najla');
    BEGIN
        FOR c IN (
            SELECT c.nomcli, cc.solde
            FROM CLIENT c, COMPTECLIENT cc
            WHERE c.prenomcli IN (SELECT COLUMN_VALUE FROM TABLE(v_prenoms)) 
              AND cc.solde < 2000 
              AND c.numcli = cc.numcli
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(c.nomcli || ' - ' || c.solde);
        END LOOP;
    END;
END;
/*4) Afficher les clients avec solde > 2000 :*/
BEGIN
    DECLARE
    BEGIN
        FOR c IN (
            SELECT c.nomcli, c.prenomcli, c.adresse
            FROM CLIENT c, COMPTECLIENT cc 
            WHERE c.numcli = cc.numcli
            AND cc.solde > 2000
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(c.nomcli || ', ' || c.prenomcli || ', ' || c.adresse);
        END LOOP;
    END;
END;
/*5)Afficher clients,t pour chaque client, la liste des comptes, et pour chacun de ces comptes, l'historique des opérations:*/
BEGIN
    DECLARE
        CURSOR client_cursor IS SELECT * FROM CLIENT;
        CURSOR compte_cursor (p_numcli INT) IS SELECT * FROM COMPTECLIENT WHERE numcli = p_numcli;
        CURSOR operation_cursor (p_numcli INT, p_numccl INT) IS SELECT * FROM OPERATION WHERE numcli = p_numcli AND numccl = p_numccl;
    BEGIN
        FOR client IN client_cursor LOOP
            DBMS_OUTPUT.PUT_LINE('Client: ' || client.nomcli);
            FOR compte IN compte_cursor(client.numcli) LOOP
                DBMS_OUTPUT.PUT_LINE('  Compte: ' || compte.numccl || ' - Solde: ' || compte.solde);
                FOR operation IN operation_cursor(compte.numcli, compte.numccl) LOOP
                    DBMS_OUTPUT.PUT_LINE('    Opération: ' || operation.dateoper || ' - ' || operation.montantoper);
                END LOOP;
            END LOOP;
        END LOOP;
    END;
END;
/*EXERCICE 2*/
/*les employés ayant les cinq salaires les plus élevés.*/
BEGIN
    DECLARE
        -- Déclaration des types et variables
        TYPE TopSalariesTab IS TABLE OF PERSONNEL%ROWTYPE;
        v_top_salaries    TopSalariesTab;
        v_distinct_count  NUMBER;

        -- Exception personnalisée pour le cas < 5 salaires distincts
        less_than_5_distinct EXCEPTION;
        PRAGMA EXCEPTION_INIT(less_than_5_distinct, -20001);
    BEGIN
        -- 1) Vérification du nombre de salaires distincts
        SELECT COUNT(DISTINCT salaire) INTO v_distinct_count 
        FROM PERSONNEL;

        IF v_distinct_count < 5 THEN
            RAISE less_than_5_distinct; -- Lève l'exception si < 5
        END IF;

        -- 2-3) Récupération des top salaires avec gestion des ex-aequo
        SELECT * 
        BULK COLLECT INTO v_top_salaries
        FROM (
            SELECT p.*, 
                   DENSE_RANK() OVER (ORDER BY salaire DESC) AS rank
            FROM PERSONNEL p
        )
        WHERE rank <= 5;

        -- 4) Affichage des résultats
        DBMS_OUTPUT.PUT_LINE('Top 5 des meilleurs salaires :');
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        FOR i IN 1..v_top_salaries.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(v_top_salaries(i).nompers, 20) || ' | ' ||
                LPAD(TO_CHAR(v_top_salaries(i).salaire, '999,999.99'), 12) || ' DT'
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('Total : ' || v_top_salaries.COUNT || ' employé(s)');

    EXCEPTION
        -- Gestion du cas particulier < 5 salaires distincts
        WHEN less_than_5_distinct THEN
            DBMS_OUTPUT.PUT_LINE('[ATTENTION] Moins de 5 salaires distincts !');

            -- Malgré l'exception, on affiche les résultats existants
            SELECT * 
            BULK COLLECT INTO v_top_salaries
            FROM (
                SELECT p.*, 
                       DENSE_RANK() OVER (ORDER BY salaire DESC) AS rank
                FROM PERSONNEL p
            )
            WHERE rank <= 5;

            DBMS_OUTPUT.PUT_LINE('Liste des salaires disponibles :');
            FOR i IN 1..v_top_salaries.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(v_top_salaries(i).nompers, 20) || ' | ' ||
                    LPAD(TO_CHAR(v_top_salaries(i).salaire, 12)) || ' DT');
            END LOOP;

        -- Gestion des autres erreurs
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
    END;
END;
/*EXERCICE 3*/
/*1. Afficher les valeurs en double*/
DECLARE
    -- Curseur pour récupérer les valeurs en double
    CURSOR c_duplicates IS
        SELECT num, COUNT(*) AS occurrences
        FROM TEST
        GROUP BY num
        HAVING COUNT(*) > 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Valeurs en double :');
    DBMS_OUTPUT.PUT_LINE('-------------------');
    
    FOR rec IN c_duplicates LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Numéro: ' || rec.num || 
            ' | Occurrences: ' || rec.occurrences
        );
    END LOOP;
END;
/*2. la suppression des doublons.*/
BEGIN
    -- Supprime les doublons en gardant une seule occurrence
    DELETE FROM TEST
    WHERE ROWID NOT IN (
        SELECT MIN(ROWID)  -- Garde la première occurrence
        FROM TEST
        GROUP BY num
    );
    
    DBMS_OUTPUT.PUT_LINE('Doublons supprimés avec succès.');
    COMMIT;
END;
/*EXERCICE 4*/
BEGIN
    DECLARE
        v_target NUMBER := 1;      -- Position cible dans la séquence (1, 3, 6, 10...)
        v_increment NUMBER := 1;   -- Incrément dynamique (1, 2, 3, 4...)
        v_counter NUMBER := 0;     -- Compteur de lignes
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Collaborateurs échantillonnés :');
        
        -- Parcours des employés triés par Cnum
        FOR emp IN (SELECT Cnom FROM COLB ORDER BY Cnum) LOOP
            v_counter := v_counter + 1;
            
            -- Si on atteint la position cible
            IF v_counter = v_target THEN
                DBMS_OUTPUT.PUT_LINE(emp.Cnom);
                
                -- Calcul de la prochaine cible
                v_increment := v_increment + 1;
                v_target := v_target + v_increment;
            END IF;
        END LOOP;
    END;
END;