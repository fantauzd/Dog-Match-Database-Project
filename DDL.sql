-- Dominic Fantauzzo
-- Joshua Warnick
-- Project Group 85

-- for reference:
--      mysql -u [database_user_name] -h classmysql.engr.oregonstate.edu -p



SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cs340_fantauzd
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cs340_fantauzd
-- -----------------------------------------------------
-- CREATE SCHEMA IF NOT EXISTS `cs340_fantauzd` DEFAULT CHARACTER SET utf8 ;

-- -----------------------------------------------------
-- Table `Breeds`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE `Breeds` (
  `breed_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `activity_level` SMALLINT(10) NULL,
  `shedding_level` SMALLINT(10) NULL,
  `size` VARCHAR(45) NULL,
  PRIMARY KEY (`breed_id`))
ENGINE = InnoDB;

INSERT INTO Breeds (name, activity_level, shedding_level, size)
VALUES
    ('Beagle', 4, 3, 'Small'),
    ('Poodle', 4, 1, 'Medium'),
    ('Beauceron', 5, 4, 'Large'),
    ('Maltese', 3, 1, 'Small');

-- -----------------------------------------------------
-- Table `shelters`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE `Shelters` (
  `shelter_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `city` VARCHAR(255) NOT NULL,
  `postal_code` VARCHAR(255) NOT NULL,
  `state` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`shelter_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;

INSERT INTO Shelters (name, email, street_address, city, postal_code, state)
VALUES
	('West Valley Humane Society', 'westvalleyhumanesociety@gmail.com', '5234 Jebba Way', 'Boise', '52344', 'Idaho'),
    ('Hand and Paw', 'handandpaw@outlook.com', '5214 Jebba Way', 'Boise', '52343', 'Idaho'),
    ('Lake Lowell Animal Rescue', 'lakelowellanimal@gmail.com', '455 Zeland Street', 'Nampa', '34554', 'Idaho');

-- -----------------------------------------------------
-- Table 'dogs`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE `Dogs` (
  `dog_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `birthdate` DATE NULL,
  `training_level` SMALLINT(10) NULL,
  `is_family_friendly` TINYINT(1) NULL DEFAULT 1,
  `shelter_arrival_date` DATE NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `shelter_id` INT NOT NULL,
  `breed_id` INT NULL,
  INDEX `fk_dogs_breeds_idx` (`breed_id` ASC) VISIBLE,
  INDEX `fk_dogs_Shelter1_idx` (`shelter_id` ASC) VISIBLE,
  PRIMARY KEY (`dog_id`),
  CONSTRAINT `fk_dogs_breeds`
    FOREIGN KEY (`breed_id`)
    REFERENCES `breeds` (`breed_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dogs_Shelter1`
    FOREIGN KEY (`shelter_id`)
    REFERENCES `shelters` (`shelter_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO Dogs (name, birthdate, training_level, is_family_friendly, shelter_arrival_date, shelter_id, breed_id, is_active)
VALUES
    ('Rusty', '2023-12-01', 4, 1, '2023-12-02', 1, 1, 0),
    ('Marlowe', '2023-12-01', 3, 1, '2023-12-02', 1, 2, 0),
    ('Churro', '2023-12-01', 4, 0, '2023-12-02', 2, 3, 0),
    ('Fitz', '2023-12-01', 1, 0, '2023-12-02', 1, 1, 1);

-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE `Users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `birthdate` DATE NULL,
  `home_type` VARCHAR(45) NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `city` VARCHAR(255) NOT NULL,
  `postal_code` VARCHAR(255) NOT NULL,
  `state` VARCHAR(255) NOT NULL,
  `activity_preference` SMALLINT(10) NULL,
  `shedding_preference` SMALLINT(10) NULL,
  `training_preference` SMALLINT(10) NULL,
  `size_preference` VARCHAR(45) NULL,
  `has_children` TINYINT(1) NULL DEFAULT 0,
  `has_dog` TINYINT(1) NULL DEFAULT 0,
  `has_cat` TINYINT(1) NULL DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE)
ENGINE = InnoDB;

INSERT INTO Users (username, phone, email, birthdate, home_type, street_address, city, postal_code, state, activity_preference, shedding_preference, training_preference, size_preference, has_children, has_dog, has_cat, is_active)
VALUES
	('pinkpanther', '2085558953', 'pinkpanther@gmail.com', '1996-11-05', 'House', '562 Franny Way', 'Boise', '52314', 'Idaho', 4, 1, 5, 'Small', 1 , 0, 1, 1),
	('jwar1989', '2085554598', 'jwar1989@hotmail.com', '1996-11-13', 'Apartment', '16 Zimba Circle', 'Boise', '52112', 'Idaho', 3, 2, 1, 'Medium', 0 , 0, 0, 1),
	('cooldad78', '2035556732', 'cooldad78@outlook.com', '1996-01-05', 'Duplex', '524 Hawk Lane', 'Nampa', '25345', 'Idaho', 3, 4, 5, 'Large', 0 , 1, 0, 1),
	('petlover', '3173585012', 'petlover777@gmail.com', '1996-10-05', 'House', '5214 Jebba Way', 'Boise', '52344', 'Idaho', 5, 1, 5, 'Medium', 1 , 1, 0, 1);

-- -----------------------------------------------------
-- Table `matches`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE `Matches` (
  `match_id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `user_id` INT NOT NULL,
  `dog_id` INT NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`match_id`),
  INDEX `fk_matches_users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_matches_dogs1_idx` (`dog_id` ASC) VISIBLE,
  CONSTRAINT `fk_matches_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_matches_dogs1`
    FOREIGN KEY (`dog_id`)
    REFERENCES `dogs` (`dog_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO Matches (date, user_id, dog_id, is_active)
VALUES
	('2024-04-01', 3, 1, 0),
	('2024-04-01', 3, 2, 0),
	('2024-04-01', 2, 3, 0),
	('2024-04-01', 1, 3, 0);

-- -----------------------------------------------------
-- Table `adoptions`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE `Adoptions` (
  `adoption_id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NULL,
  `dog_id` INT NOT NULL,
  `shelter_id` INT NOT NULL,
  `user_id` INT NULL,
  `match_id` INT NULL,
  PRIMARY KEY (`adoption_id`),
  INDEX `fk_adoptions_dogs1_idx` (`dog_id` ASC) VISIBLE,
  INDEX `fk_adoptions_users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_adoptions_matches1_idx` (`match_id` ASC) VISIBLE,
  INDEX `fk_adoptions_shelters1_idx` (`shelter_id` ASC) VISIBLE,
  CONSTRAINT `fk_adoptions_dogs1`
    FOREIGN KEY (`dog_id`)
    REFERENCES `dogs` (`dog_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_adoptions_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_adoptions_matches1`
    FOREIGN KEY (`match_id`)
    REFERENCES `matches` (`match_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_adoptions_shelters1`
    FOREIGN KEY (`shelter_id`)
    REFERENCES `shelters` (`shelter_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
ROW_FORMAT = DEFAULT;

INSERT INTO Adoptions (date, dog_id, shelter_id, user_id, match_id)
VALUES
	('2024-05-01', 1, 1, 3, 1),
	('2024-05-01', 2, 1, 3, 2),
	('2024-05-01', 3, 2, 1, 4);

-- -----------------------------------------------------
-- Table `dogs_has_users`
-- -----------------------------------------------------
CREATE OR REPLACE TABLE `Dogs_has_users` (
  `dogs_has_users_id` INT NOT NULL AUTO_INCREMENT,
  `dogs_dog_id` INT NOT NULL,
  `users_user_id` INT NOT NULL,
  `source` VARCHAR(45) NOT NULL,
  INDEX `fk_dogs_has_users_users1_idx` (`users_user_id` ASC) VISIBLE,
  INDEX `fk_dogs_has_users_dogs1_idx` (`dogs_dog_id` ASC) VISIBLE,
  PRIMARY KEY (`dogs_has_users_id`),
  CONSTRAINT `fk_dogs_has_users_dogs1`
    FOREIGN KEY (`dogs_dog_id`)
    REFERENCES `dogs` (`dog_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dogs_has_users_users1`
    FOREIGN KEY (`users_user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO Dogs_has_users (users_user_id, dogs_dog_id, source)
VALUES 
	(1, 3, 'Dog'),
	(3, 1, 'Dog'),
	(3, 2, 'Dog'),
	(2, 3, 'Dog'),
  (1, 3, 'User'),
	(3, 1, 'User'),
	(3, 2, 'User'),
	(2, 3, 'User');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
