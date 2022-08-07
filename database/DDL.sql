-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cs340_hobi
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cs340_hobi
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cs340_hobi` DEFAULT CHARACTER SET utf8 ;
USE `cs340_hobi` ;

-- -----------------------------------------------------
-- Table `cs340_hobi`.`Developers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs340_hobi`.`Developers` ;

CREATE TABLE IF NOT EXISTS `cs340_hobi`.`Developers` (
  `dev_id` INT NOT NULL AUTO_INCREMENT,
  `dev_name` VARCHAR(100) NOT NULL,
  `dev_description` TEXT NULL,
  `staff_comments` TEXT NULL,
  PRIMARY KEY (`dev_id`),
  UNIQUE INDEX `dev_name_UNIQUE` (`dev_name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_hobi`.`CardGames`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs340_hobi`.`CardGames` ;

CREATE TABLE IF NOT EXISTS `cs340_hobi`.`CardGames` (
  `cardgame_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(150) NOT NULL,
  `stock_qty` INT NOT NULL DEFAULT 0,
  `price_per_pack` DECIMAL(19,2) NOT NULL,
  `dev_id` INT,
  PRIMARY KEY (`cardgame_id`),
  INDEX `fk_CardGames_Developers1_idx` (`dev_id` ASC),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC),
  CONSTRAINT `fk_CardGames_Developers1`
    FOREIGN KEY (`dev_id`)
    REFERENCES `cs340_hobi`.`Developers` (`dev_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_hobi`.`Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs340_hobi`.`Customers` ;

CREATE TABLE IF NOT EXISTS `cs340_hobi`.`Customers` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `phone_num` VARCHAR(20) NULL,
  `birthday` DATE NULL,
  `email` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_hobi`.`Genres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs340_hobi`.`Genres` ;

CREATE TABLE IF NOT EXISTS `cs340_hobi`.`Genres` (
  `genre_id` INT NOT NULL AUTO_INCREMENT,
  `genre_type` VARCHAR(50) NOT NULL,
  `genre_description` TEXT NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE INDEX `genre_type_UNIQUE` (`genre_type` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_hobi`.`CardGames_Genres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs340_hobi`.`CardGames_Genres` ;

CREATE TABLE IF NOT EXISTS `cs340_hobi`.`CardGames_Genres` (
  `cardgame_id` INT NOT NULL,
  `genre_id` INT NOT NULL,
  PRIMARY KEY (`cardgame_id`, `genre_id`),
  INDEX `fk_CardGames_Genres_CardGames1_idx` (`cardgame_id` ASC),
  INDEX `fk_CardGames_Genres_Genres1_idx` (`genre_id` ASC),
  CONSTRAINT `fk_CardGames_Genres_CardGames1`
    FOREIGN KEY (`cardgame_id`)
    REFERENCES `cs340_hobi`.`CardGames` (`cardgame_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CardGames_Genres_Genres1`
    FOREIGN KEY (`genre_id`)
    REFERENCES `cs340_hobi`.`Genres` (`genre_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_hobi`.`Invoices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs340_hobi`.`Invoices` ;

CREATE TABLE IF NOT EXISTS `cs340_hobi`.`Invoices` (
  `purchase_id` INT NOT NULL AUTO_INCREMENT,
  `purchase_date` DATE NOT NULL,
  `customer_id` INT NULL,
  PRIMARY KEY (`purchase_id`),
  INDEX `fk_Sales_Customers1_idx` (`customer_id` ASC),
  CONSTRAINT `fk_Sales_Customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `cs340_hobi`.`Customers` (`customer_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cs340_hobi`.`InvoiceLines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs340_hobi`.`InvoiceLines` ;

CREATE TABLE IF NOT EXISTS `cs340_hobi`.`InvoiceLines` (
  `invoiceline_id` INT NOT NULL AUTO_INCREMENT,
  `purchase_qty` INT NOT NULL,
  `line_cost` DECIMAL(19,2) NOT NULL,
  `cardgame_id` INT NOT NULL,
  `purchase_id` INT NOT NULL,
  PRIMARY KEY (`invoiceline_id`),
  INDEX `fk_SalesDetails_Cardgames1_idx` (`cardgame_id` ASC),
  INDEX `fk_Sales_Sales1_idx` (`purchase_id` ASC),
  CONSTRAINT `fk_SalesDetails_Cardgames1`
    FOREIGN KEY (`cardgame_id`)
    REFERENCES `cs340_hobi`.`CardGames` (`cardgame_id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sales_Sales1`
    FOREIGN KEY (`purchase_id`)
    REFERENCES `cs340_hobi`.`Invoices` (`purchase_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `cs340_hobi`.`Developers`
-- -----------------------------------------------------
START TRANSACTION;
USE `cs340_hobi`;
INSERT INTO `cs340_hobi`.`Developers` (`dev_id`, `dev_name`, `dev_description`, `staff_comments`) VALUES (1, 'Konami Digital Entertainment B.V.', 'Konami', NULL);
INSERT INTO `cs340_hobi`.`Developers` (`dev_id`, `dev_name`, `dev_description`, `staff_comments`) VALUES (2, 'Nintendo Co. Ltd.', 'Nintendo Company', 'popular company with younger generation');
INSERT INTO `cs340_hobi`.`Developers` (`dev_id`, `dev_name`, `dev_description`, `staff_comments`) VALUES (3, 'Fantasy Flight Games', 'FFG', NULL);
INSERT INTO `cs340_hobi`.`Developers` (`dev_id`, `dev_name`, `dev_description`, `staff_comments`) VALUES (4, 'Wizards of the Coast', NULL, 'popular with older generation');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cs340_hobi`.`CardGames`
-- -----------------------------------------------------
START TRANSACTION;
USE `cs340_hobi`;
INSERT INTO `cs340_hobi`.`CardGames` (`cardgame_id`, `title`, `stock_qty`, `price_per_pack`, `dev_id`) VALUES (1, 'Arkham Horror: The Card Game', 100, 20.00, 3);
INSERT INTO `cs340_hobi`.`CardGames` (`cardgame_id`, `title`, `stock_qty`, `price_per_pack`, `dev_id`) VALUES (2, 'Marvel Champions: The Card Game', 50, 74.99, 3);
INSERT INTO `cs340_hobi`.`CardGames` (`cardgame_id`, `title`, `stock_qty`, `price_per_pack`, `dev_id`) VALUES (3, 'Magic: The Gathering', 200, 83.95, 4);
INSERT INTO `cs340_hobi`.`CardGames` (`cardgame_id`, `title`, `stock_qty`, `price_per_pack`, `dev_id`) VALUES (4, 'Pokemon Trading Card Game', 200, 12.19, 2);
INSERT INTO `cs340_hobi`.`CardGames` (`cardgame_id`, `title`, `stock_qty`, `price_per_pack`, `dev_id`) VALUES (5, 'Yu-Gi-Oh! Trading Card Game', 150, 8.99, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `cs340_hobi`.`Customers`
-- -----------------------------------------------------
START TRANSACTION;
USE `cs340_hobi`;
INSERT INTO `cs340_hobi`.`Customers` (`customer_id`, `name`, `phone_num`, `birthday`, `email`) VALUES (1, 'David Luo', '8186547891', NULL, 'davidluo@gmail.com');
INSERT INTO `cs340_hobi`.`Customers` (`customer_id`, `name`, `phone_num`, `birthday`, `email`) VALUES (2, 'Albert Zhang', NULL, '1996-01-08', 'Zhang@gmail.com');
INSERT INTO `cs340_hobi`.`Customers` (`customer_id`, `name`, `phone_num`, `birthday`, `email`) VALUES (3, 'Tom Lewis', NULL, NULL, 'trollewis@gmail.com');
INSERT INTO `cs340_hobi`.`Customers` (`customer_id`, `name`, `phone_num`, `birthday`, `email`) VALUES (4, 'John Doe', NULL, NULL, 'superdoe@yahoo.com');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cs340_hobi`.`Genres`
-- -----------------------------------------------------
START TRANSACTION;
USE `cs340_hobi`;
INSERT INTO `cs340_hobi`.`Genres` (`genre_id`, `genre_type`, `genre_description`) VALUES (1, 'Fighting', 'Games that encourage players to engage game characters in close quarter battles and hand-to-hand combat.');
INSERT INTO `cs340_hobi`.`Genres` (`genre_id`, `genre_type`, `genre_description`) VALUES (2, 'Fantasy', 'Games that use magic and other supernatural forms as a primary element of plot, theme, and/or setting.');
INSERT INTO `cs340_hobi`.`Genres` (`genre_id`, `genre_type`, `genre_description`) VALUES (3, 'Movies/TV/Radio', 'Games that are thematically linked with a popular movie, television show, or radio program.');
INSERT INTO `cs340_hobi`.`Genres` (`genre_id`, `genre_type`, `genre_description`) VALUES (4, 'Horror', 'Games that contain themes and imagery depicting morbid and supernatural elements.');
INSERT INTO `cs340_hobi`.`Genres` (`genre_id`, `genre_type`, `genre_description`) VALUES (5, 'Novel-based', 'Games that are thematically linked with a popular novel or novel series.');
INSERT INTO `cs340_hobi`.`Genres` (`genre_id`, `genre_type`, `genre_description`) VALUES (6, 'Comic Book/Strip', 'Games that have themes and storylines that are based on established comic book/strip characters.');
INSERT INTO `cs340_hobi`.`Genres` (`genre_id`, `genre_type`, `genre_description`) VALUES (7, 'Video Game Theme', 'Games that are thematically linked with or inspired by a video game franchise or genre.');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cs340_hobi`.`CardGames_Genres`
-- -----------------------------------------------------
START TRANSACTION;
USE `cs340_hobi`;
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (1, 2);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (1, 4);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (1, 5);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (2, 6);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (3, 2);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (3, 1);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (4, 2);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (4, 1);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (4, 7);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (5, 2);
INSERT INTO `cs340_hobi`.`CardGames_Genres` (`cardgame_id`, `genre_id`) VALUES (5, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `cs340_hobi`.`Invoices`
-- -----------------------------------------------------
START TRANSACTION;
USE `cs340_hobi`;
INSERT INTO `cs340_hobi`.`Invoices` (`purchase_id`, `purchase_date`, `customer_id`) VALUES (1, '2022-07-04', 1);
INSERT INTO `cs340_hobi`.`Invoices` (`purchase_id`, `purchase_date`, `customer_id`) VALUES (2, '2022-07-04', 3);
INSERT INTO `cs340_hobi`.`Invoices` (`purchase_id`, `purchase_date`, `customer_id`) VALUES (3, '2022-07-05', 4);
INSERT INTO `cs340_hobi`.`Invoices` (`purchase_id`, `purchase_date`, `customer_id`) VALUES (4, '2022-07-05', 2);
INSERT INTO `cs340_hobi`.`Invoices` (`purchase_id`, `purchase_date`, `customer_id`) VALUES (5, '2022-07-06', 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `cs340_hobi`.`InvoiceLines`
-- -----------------------------------------------------
START TRANSACTION;
USE `cs340_hobi`;
INSERT INTO `cs340_hobi`.`InvoiceLines` (`invoiceline_id`, `purchase_qty`, `line_cost`, `cardgame_id`, `purchase_id`) VALUES (1, 3, 60.00, 1, 1);
INSERT INTO `cs340_hobi`.`InvoiceLines` (`invoiceline_id`, `purchase_qty`, `line_cost`, `cardgame_id`, `purchase_id`) VALUES (2, 1, 8.99, 5, 1);
INSERT INTO `cs340_hobi`.`InvoiceLines` (`invoiceline_id`, `purchase_qty`, `line_cost`, `cardgame_id`, `purchase_id`) VALUES (3, 5, 60.95, 4, 2);
INSERT INTO `cs340_hobi`.`InvoiceLines` (`invoiceline_id`, `purchase_qty`, `line_cost`, `cardgame_id`, `purchase_id`) VALUES (4, 1, 74.99, 2, 3);
INSERT INTO `cs340_hobi`.`InvoiceLines` (`invoiceline_id`, `purchase_qty`, `line_cost`, `cardgame_id`, `purchase_id`) VALUES (5, 10, 839.50, 3, 4);
INSERT INTO `cs340_hobi`.`InvoiceLines` (`invoiceline_id`, `purchase_qty`, `line_cost`, `cardgame_id`, `purchase_id`) VALUES (6, 2, 167.90, 3, 5);

COMMIT;

