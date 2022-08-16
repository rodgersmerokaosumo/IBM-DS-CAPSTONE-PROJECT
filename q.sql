-- Create trigger to only allow adults to create accounts
-- Business requirement 3
DELIMITER $$
CREATE TRIGGER age_update
    BEFORE UPDATE 
    ON users_table FOR EACH ROW
BEGIN
    IF DATE_FORMAT(FROM_DAYS(DATEDIFF(now(),dob)), '%Y')+0 < 18  THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'You need Consent from an adult to create account';
    END IF;
END$$    
DELIMITER ;


-- Business Requirement 4
-- Trigger to not allow employee experience update to be higher
DELIMITER //
Create Trigger before_insert_experience BEFORE INSERT ON experience FOR EACH ROW
BEGIN
IF NEW.experience <=OLD.experience THEN
	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Experience cannot be lower than set';
END IF;
END //

DELIMITER ;


-- Calculate the raise for employees based on their experience
--  Business Requirement
DELIMETER // 
CREATE FUNCTION CalcRaise ( experience DECIMAL, SALARY DECIMAL )
RETURNS DECIMAL

BEGIN

   DECLARE Raise Decimal;

   SET Raise = 0;

   label1: WHILE Experience >= 3 DO
     SET Raise = salary * experience/10;
   END WHILE label1;

   RETURN Raise;

END; //

DELIMITER ;


-- Determine vetran employees with over 10 years experience
-- Business Requirement 2

DELIMITER //
CREATE FUNCTION CalcVeteran ( experience DECIMAL)
RETURNS VARCHAR(45)

BEGIN

   DECLARE VETERAN_STATUS VARCHAR(45);

   SET VETERAN_STATUS = 'NOT A VETERAN';

   label2: WHILE Experience >= 10 DO
     SET VETERAN_STATUS = 'VETERAN';
   END WHILE label2;

   RETURN VETERAN_STATUS;

END; //

DELIMITER ;

DELIMITER //
-- Procedure to  all LAB TECHNICIANS PER SPECIALIZATION
-- Business Requirement 7
CREATE PROCEDURE GetAllLabTechs()
BEGIN
	SELECT specialization,f_name, l_name  FROM lab_tech_tables
    WHERE experience >1
    GROUP BY specialization;
END //

DELIMITER ;

-- Business Requirement 4
-- Trigger to not allow employee experience update to be higher
DELIMITER //
Create Trigger before_insert_experience BEFORE INSERT ON experience FOR EACH ROW
BEGIN
IF NEW.experience <=OLD.experience THEN
	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Experience cannot be lower than set';
END IF;
END //

DELIMITER ;

DELIMETER //
-- Calculate the raise for employees based on their experience
--  Business Requirement 
CREATE FUNCTION CalcSalary ( experience DECIMAL, SALARY DECIMAL )
RETURNS DECIMAL

BEGIN

   DECLARE Raise Decimal;

   SET Raise = 0;

   label3: WHILE Experience >= 3 DO
     SET Raise = salary * experience/10;
     SET NEW.salary = OLD.salary + Raise
   END WHILE label3;

   RETURN salary;

END; //

DELIMITER ;

