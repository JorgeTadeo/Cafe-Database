-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2020 at 03:52 AM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cafedb`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `check_type` (`Itemtype` CHAR, `Alcohol` DECIMAL(4,2), `Vegan` BOOLEAN) RETURNS TINYINT(1) BEGIN
         DECLARE isGood BOOLEAN default FALSE;
         CASE (Itemtype)
            WHEN 'F' THEN SET isGood = (Alcohol IS NULL);
            WHEN 'D' THEN SET isGood = (Vegan IS NULL);
         END CASE;
         RETURN isGood;
     end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `game_type` (`GameType` CHAR, `PlayerNum` INT, `BoardName` VARCHAR(30), `ConsoleType` VARCHAR(30), `ControllerAmnt` INT, `ComputerNum` INT) RETURNS TINYINT(1) BEGIN
         DECLARE isGood BOOLEAN default FALSE;
         CASE (GameType)
            WHEN 'B' THEN SET isGood = (ConsoleType IS NULL AND ControllerAmnt IS NULL AND ComputerNum IS NULL);
            WHEN 'C' THEN SET isGood = (PlayerNum IS NULL AND BoardName IS NULL AND ComputerNum IS NULL);
			WHEN 'P' THEN SET isGood = (PlayerNum IS NULL AND BoardName IS NULL AND ConsoleType IS NULL AND ControllerAmnt IS NULL);
         END CASE;
         RETURN isGood;
     end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `staff_type` (`StaffType` CHAR, `Tips` DECIMAL(5,2), `Bonus` DECIMAL(5,2)) RETURNS TINYINT(1) BEGIN
         DECLARE isGood BOOLEAN default FALSE;
         CASE (Stafftype)
            WHEN 'M' THEN SET isGood = (Tips IS NULL);
            WHEN 'W' THEN SET isGood = (Bonus IS NULL);
         END CASE;
         RETURN isGood;
     end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `boardgames`
-- (See below for the actual view)
--
CREATE TABLE `boardgames` (
`GameID` int(11)
,`BoardName` varchar(30)
,`PlayerNum` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `booth`
--

CREATE TABLE `booth` (
  `BoothID` int(11) NOT NULL,
  `Floor` int(11) NOT NULL,
  `Seats` int(11) NOT NULL,
  `Availability` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `booth`
--

INSERT INTO `booth` (`BoothID`, `Floor`, `Seats`, `Availability`) VALUES
(1, 2, 8, 1),
(2, 1, 4, 1),
(3, 3, 6, 1),
(4, 1, 2, 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `consoles`
-- (See below for the actual view)
--
CREATE TABLE `consoles` (
`GameID` int(11)
,`ConsoleType` varchar(30)
,`ControllerAmnt` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `CustomerID` int(11) NOT NULL,
  `Username` varchar(25) NOT NULL,
  `Password` varchar(25) NOT NULL,
  `FirstName` varchar(15) NOT NULL,
  `MiddleName` varchar(15) DEFAULT NULL,
  `LastName` varchar(15) NOT NULL,
  `Zip` varchar(9) DEFAULT NULL,
  `Street` varchar(50) DEFAULT NULL,
  `City` varchar(30) DEFAULT NULL,
  `State` char(2) DEFAULT NULL,
  `Hours` int(11) DEFAULT NULL,
  `GameID` int(11) DEFAULT NULL,
  `BoothID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`CustomerID`, `Username`, `Password`, `FirstName`, `MiddleName`, `LastName`, `Zip`, `Street`, `City`, `State`, `Hours`, `GameID`, `BoothID`) VALUES
(10389209, '', '', '', NULL, '', NULL, NULL, NULL, NULL, 1, NULL, NULL),
(34532567, 'Brad49', '98765', 'Brad', NULL, 'Richards', '65401', '122 Homestead Street.', 'Rolla', 'MO', NULL, NULL, 1),
(34543234, 'Kev97', '12345', 'Kevin', NULL, 'Aston', '30144', '418 Euclid Ave.', 'Kennesaw', 'GA', 1, 934, 2),
(42053929, '', '', '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44739990, '', '', '', NULL, '', NULL, NULL, NULL, NULL, 1, NULL, NULL),
(56345367, 'SteveWillDoIt', '$1234', 'Steve', NULL, 'CanDoIt', '08087', '3434 Augusta Avenue', 'Tuckerton', 'NJ', NULL, NULL, NULL),
(56745676, 'Dan98', '98752', 'Daniel', NULL, 'Ramerez', '91768', '9204 Meadowbrook St.', 'Pomona', 'CA', 3, NULL, 2),
(56886567, 'PerryG97', '87234', 'Perry', NULL, 'Lanister', '08087', '7474 Augusta Avenue', 'Tuckerton', 'NJ', NULL, NULL, 2),
(68168958, 'PGeorge', '246810', 'Paul', '', 'George', '', '', '', '', 1, NULL, NULL),
(76477594, 'jsnow', '123456', 'john', '', 'snow', '', '', '', '', NULL, NULL, NULL);

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `customer_update_trigger` AFTER UPDATE ON `customer` FOR EACH ROW BEGIN
        DECLARE newPoints int;
        DECLARE newMembershipType varchar(8);

        if old.CustomerID in (select CustomerID from MEMBERS_VIEW) then
            DELETE FROM MEMBERS_VIEW WHERE CustomerID = old.CustomerID;
        end if;

        if new.CustomerID in (select MCustomerID from MEMBER) then
            SELECT Points, MembershipType INTO newPoints, newMembershipType
            FROM MEMBER
            WHERE MCustomerID = new.CustomerID;

            INSERT INTO MEMBERS_VIEW values (new.CustomerID, new.Username, new.Password, new.FirstName, new.MiddleName, new.LastName, 
											  new.Zip, new.Street, new.City, new.State,
                                              new.Hours, new.GameID, new.BoothID, newPoints, newMembershipType);
        end if;
    end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_order`
--

CREATE TABLE `customer_order` (
  `OCustomerID` int(11) NOT NULL,
  `OrderNum` int(11) NOT NULL,
  `Cost` decimal(5,2) NOT NULL,
  `Payment` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer_order`
--

INSERT INTO `customer_order` (`OCustomerID`, `OrderNum`, `Cost`, `Payment`) VALUES
(10389209, 80, '8.00', 'Debit'),
(10389209, 81, '15.98', 'Cash'),
(34543234, 82, '3.99', 'Cash'),
(34543234, 83, '7.99', 'Cash'),
(34543234, 84, '8.99', 'Cash'),
(44739990, 76, '13.00', 'Debit'),
(44739990, 77, '13.00', 'Debit'),
(44739990, 78, '13.00', 'Debit'),
(44739990, 79, '7.00', 'Cash'),
(56886567, 35, '20.00', 'Credit'),
(68168958, 85, '7.99', 'Cash');

-- --------------------------------------------------------

--
-- Table structure for table `customer_phone`
--

CREATE TABLE `customer_phone` (
  `PCustomerID` int(11) NOT NULL,
  `PhoneNum` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer_phone`
--

INSERT INTO `customer_phone` (`PCustomerID`, `PhoneNum`) VALUES
(34532567, '(325)-732-2333'),
(34543234, '(510)-237-3235'),
(34543234, '(510)-415-3235'),
(56745676, '(423)-643-1237'),
(56886567, '(942)-234-4893');

-- --------------------------------------------------------

--
-- Table structure for table `drinks_menu_view`
--

CREATE TABLE `drinks_menu_view` (
  `ItemID` int(11) NOT NULL,
  `Name` varchar(15) DEFAULT NULL,
  `Price` decimal(5,2) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Alcohol` decimal(4,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `drinks_menu_view`
--

INSERT INTO `drinks_menu_view` (`ItemID`, `Name`, `Price`, `Quantity`, `Alcohol`) VALUES
(1398, 'Kamikaze', '7.64', 147, '28.60'),
(2398, 'Gimlet', '8.13', 221, '12.40'),
(4256, 'Jack n Coke', '6.45', 300, '10.00'),
(5623, 'Dr.Pepper', '1.00', 147, '0.00'),
(6341, 'Coke', '1.00', 300, '0.00'),
(7821, 'Sprite', '1.00', 274, '0.00'),
(8213, 'Diet Coke', '1.00', 221, '0.00'),
(8233, 'Martini', '6.99', 274, '15.00');

-- --------------------------------------------------------

--
-- Table structure for table `food_menu_view`
--

CREATE TABLE `food_menu_view` (
  `ItemID` int(11) NOT NULL,
  `Name` varchar(35) DEFAULT NULL,
  `Price` decimal(5,2) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `vegan` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food_menu_view`
--

INSERT INTO `food_menu_view` (`ItemID`, `Name`, `Price`, `Quantity`, `vegan`) VALUES
(182, 'Carne Asada Tacos', '2.99', 372, 0),
(1029, 'Pasta', '6.99', 41, 0),
(5675, 'Cheese Burger', '7.99', 64, 0),
(5732, 'Creamy Vegan Pasta', '6.99', 141, 1),
(7317, 'Steak and Potatoes', '8.99', 24, 0),
(7441, 'Sweet Potato & Black Bean Burger', '7.99', 214, 1),
(7731, 'Vegan Mac and Cheese', '2.99', 74, 1),
(8534, 'Cauliflower Tacos', '2.99', 237, 1);

-- --------------------------------------------------------

--
-- Table structure for table `game`
--

CREATE TABLE `game` (
  `GameID` int(11) NOT NULL,
  `PlayerNum` int(11) DEFAULT NULL,
  `BoardName` varchar(30) DEFAULT NULL,
  `ConsoleType` varchar(30) DEFAULT NULL,
  `ControllerAmnt` int(11) DEFAULT NULL,
  `ComputerNum` int(11) DEFAULT NULL,
  `GameType` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `game`
--

INSERT INTO `game` (`GameID`, `PlayerNum`, `BoardName`, `ConsoleType`, `ControllerAmnt`, `ComputerNum`, `GameType`) VALUES
(345, NULL, NULL, 'Xbox One', 4, NULL, 'C'),
(834, NULL, NULL, 'Nintendo 64', 4, NULL, 'C'),
(934, 8, 'UNO', NULL, NULL, NULL, 'B'),
(1213, NULL, NULL, 'PS4', 4, NULL, 'C'),
(2343, NULL, NULL, 'Nintendo GameCube', 4, NULL, 'C'),
(2346, NULL, NULL, NULL, NULL, 3, 'P'),
(2389, 6, 'Monopoly', NULL, NULL, NULL, 'B'),
(2398, 2, 'Connect 4', NULL, NULL, NULL, 'B'),
(3456, NULL, NULL, NULL, NULL, 2, 'P'),
(5678, NULL, NULL, NULL, NULL, 1, 'P'),
(6780, NULL, NULL, NULL, NULL, 4, 'P'),
(9834, 4, 'Scrabble', NULL, NULL, NULL, 'B');

--
-- Triggers `game`
--
DELIMITER $$
CREATE TRIGGER `game_insert_trigger` BEFORE INSERT ON `game` FOR EACH ROW begin
         DECLARE isGood BOOLEAN;
         -- check participation and disjoint
         SET isGood = game_type(new.GameType, new.PlayerNum, new.BoardName, new.ConsoleType, new.ControllerAmnt, new.ComputerNum);
         IF (!isGood) THEN
             signal sqlstate '45000'
             SET MESSAGE_TEXT = 'Incorrect attribute values for game type';
         end if;
     end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `game_update_trigger` BEFORE UPDATE ON `game` FOR EACH ROW begin
         DECLARE isGood BOOLEAN;

          SET isGood = game_type(new.GameType, new.PlayerNum, new.BoardName, new.ConsoleType, new.ControllerAmnt, new.ComputerNum);

         IF (!isGood) THEN
             signal sqlstate '45000'
             SET MESSAGE_TEXT = 'Incorrect attribute values for game type';
             END IF;

     end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `manager_view`
--

CREATE TABLE `manager_view` (
  `StaffID` int(11) NOT NULL,
  `FirstName` varchar(15) DEFAULT NULL,
  `MiddleName` varchar(15) DEFAULT NULL,
  `LastName` varchar(15) DEFAULT NULL,
  `Ssn` int(11) DEFAULT NULL,
  `SupervisorID` int(11) DEFAULT NULL,
  `PayRate` decimal(4,2) DEFAULT NULL,
  `Bonus` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `manager_view`
--

INSERT INTO `manager_view` (`StaffID`, `FirstName`, `MiddleName`, `LastName`, `Ssn`, `SupervisorID`, `PayRate`, `Bonus`) VALUES
(55456, 'Luis', 'Fernando', 'Alvarez', 637989888, NULL, '30.00', '500.00');

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `MCustomerID` int(11) NOT NULL,
  `Points` int(11) DEFAULT NULL,
  `MembershipType` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`MCustomerID`, `Points`, `MembershipType`) VALUES
(34532567, 298, 'Bronze'),
(34543234, 100, 'Gold'),
(56886567, 0, 'Platinum');

--
-- Triggers `member`
--
DELIMITER $$
CREATE TRIGGER `member_insert_trigger` AFTER INSERT ON `member` FOR EACH ROW BEGIN
		DECLARE newUsername varchar(25);
        DECLARE newPassword varchar(25);
        DECLARE newFirstName varchar(15);
        DECLARE newMiddleName varchar(15);
		DECLARE newLastName varchar(15);
        DECLARE newZip char(9);
        DECLARE newStreet varchar(50);
        DECLARE newCity varchar(30);
        DECLARE newState char(2);
        DECLARE newHours int;
        DECLARE newGameID int;
        DECLARE newBoothID int;

        SELECT Username, Password, FirstName, MiddleName, LastName, Zip, Street, City, State, Hours, GameID, BoothID 
        INTO newUsername, newPassword, newFirstName, newMiddleName, newLastname, newZip, 
			   newStreet, newCity, newState, newHours, newGameID, newBoothID
        FROM CUSTOMER
        WHERE CustomerID = new.MCustomerID;

        INSERT INTO MEMBERS_VIEW values (new.MCustomerID,newUsername, newPassword, newFirstName, newMiddleName, newLastName, newZip, newStreet, 
										 newCity, newState, newHours, newGameID, newBoothID, new.Points, new.MembershipType);
    end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `member_update_trigger` AFTER UPDATE ON `member` FOR EACH ROW BEGIN
		DECLARE newUsername varchar(25);
        DECLARE newPassword varchar(25);
        DECLARE newFirstName varchar(15);
        DECLARE newMiddleName varchar(15);
		DECLARE newLastName varchar(15);
        DECLARE newZip char(9);
        DECLARE newStreet varchar(50);
        DECLARE newCity varchar(30);
        DECLARE newState char(2);
        DECLARE newHours int;
        DECLARE newGameID int;
        DECLARE newBoothID int;

        if old.MCustomerID in (select CustomerID from MEMBERS_VIEW) then
            DELETE FROM MEMBERS_VIEW WHERE CustomerID = old.MCustomerID;
        end if;

        SELECT Username, Password, FirstName, MiddleName, LastName, Zip, Street, City, State, Hours, GameID, BoothID 
        INTO newUsername, newPassword, newFirstName, newMiddleName, newLastName, newZip, newStreet, newCity, newState, newHours, newGameID, newBoothID 
        FROM CUSTOMER
        WHERE CustomerID = new.MCustomerID;

        INSERT INTO MEMBERS_VIEW values (new.MCustomerID,newUserName, newPassowrd, newFirstName, newMiddleName, newLastName, newZip, newStreet, 
										 newCity, newState, newHours, newGameID, newBoothID, new.Points, new.MembershipType);
    end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `members_view`
--

CREATE TABLE `members_view` (
  `CustomerID` int(11) NOT NULL,
  `Username` varchar(25) NOT NULL,
  `Password` varchar(25) NOT NULL,
  `FirstName` varchar(15) NOT NULL,
  `MiddleName` varchar(15) DEFAULT NULL,
  `LastName` varchar(15) NOT NULL,
  `Zip` char(9) NOT NULL,
  `Street` varchar(50) NOT NULL,
  `City` varchar(30) NOT NULL,
  `State` char(2) NOT NULL,
  `Hours` int(11) DEFAULT NULL,
  `GameID` int(11) DEFAULT NULL,
  `BoothID` int(11) DEFAULT NULL,
  `Points` int(11) DEFAULT NULL,
  `MembershipType` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `members_view`
--

INSERT INTO `members_view` (`CustomerID`, `Username`, `Password`, `FirstName`, `MiddleName`, `LastName`, `Zip`, `Street`, `City`, `State`, `Hours`, `GameID`, `BoothID`, `Points`, `MembershipType`) VALUES
(34532567, 'Brad49', '98765', 'Brad', NULL, 'Richards', '65401', '122 Homestead Street.', 'Rolla', 'MO', NULL, NULL, 1, 298, 'Bronze'),
(34543234, 'Kev97', '12345', 'Kevin', NULL, 'Aston', '30144', '418 Euclid Ave.', 'Kennesaw', 'GA', 1, 934, 2, 100, 'Gold'),
(56886567, 'PerryG97', '87234', 'Perry', NULL, 'Lanister', '08087', '7474 Augusta Avenue', 'Tuckerton', 'NJ', NULL, NULL, 2, 0, 'Platinum');

-- --------------------------------------------------------

--
-- Table structure for table `menu_item`
--

CREATE TABLE `menu_item` (
  `ItemID` int(11) NOT NULL,
  `Name` varchar(70) DEFAULT NULL,
  `Price` decimal(5,2) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Alcohol` decimal(4,2) DEFAULT NULL,
  `Vegan` tinyint(1) DEFAULT NULL,
  `ItemType` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `menu_item`
--

INSERT INTO `menu_item` (`ItemID`, `Name`, `Price`, `Quantity`, `Alcohol`, `Vegan`, `ItemType`) VALUES
(182, 'Carne Asada Tacos', '2.99', 372, NULL, 0, 'F'),
(1029, 'Pasta', '6.99', 41, NULL, 0, 'F'),
(1398, 'Kamikaze', '7.64', 147, '28.60', NULL, 'D'),
(2398, 'Gimlet', '8.13', 221, '12.40', NULL, 'D'),
(4256, 'Jack n Coke', '6.45', 300, '10.00', NULL, 'D'),
(5623, 'Dr.Pepper', '1.00', 147, '0.00', NULL, 'D'),
(5675, 'Cheese Burger', '7.99', 64, NULL, 0, 'F'),
(5732, 'Creamy Vegan Pasta', '6.99', 141, NULL, 1, 'F'),
(6341, 'Coke', '1.00', 300, '0.00', NULL, 'D'),
(7317, 'Steak and Potatoes', '8.99', 24, NULL, 0, 'F'),
(7441, 'Sweet Potato & Black Bean Burger', '7.99', 214, NULL, 1, 'F'),
(7731, 'Vegan Mac and Cheese', '2.99', 74, NULL, 1, 'F'),
(7821, 'Sprite', '1.00', 274, '0.00', NULL, 'D'),
(8213, 'Diet Coke', '1.00', 221, '0.00', NULL, 'D'),
(8233, 'Martini', '6.99', 274, '15.00', NULL, 'D'),
(8534, 'Cauliflower Tacos', '2.99', 237, NULL, 1, 'F');

--
-- Triggers `menu_item`
--
DELIMITER $$
CREATE TRIGGER `menu_insert_trigger` BEFORE INSERT ON `menu_item` FOR EACH ROW begin
         DECLARE isGood BOOLEAN;
         -- check participation and disjoint
         SET isGood = check_type(new.Itemtype, new.Alcohol, new.Vegan);
         IF (!isGood) THEN
             signal sqlstate '45000'
             SET MESSAGE_TEXT = 'Incorrect attribute values for item type';
         end if;
     end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `menu_item_delete_trigger` BEFORE DELETE ON `menu_item` FOR EACH ROW begin
         -- delete old row from DRINKS_MENU_VIEW
         if old.ItemID in (select ItemID from DRINKS_MENU_VIEW) then
            DELETE FROM cafedb.DRINKS_MENU_VIEW WHERE DRINKS_MENU_VIEW.ItemID = old.ItemID;
         end if;
		 -- delete old row from FOOD_MENU_VIEW
         if old.ItemID in (select ItemID from FOOD_MENU_VIEW) then
            DELETE FROM cafedb.FOOD_MENU_VIEW WHERE FOOD_MENU_VIEW.ItemID = old.ItemID;
         end if;
     end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `menu_item_insertafter_trigger` AFTER INSERT ON `menu_item` FOR EACH ROW begin
         IF new.Itemtype = 'D' then
            INSERT INTO cafedb.DRINKS_MENU_VIEW value (new.ItemID, new.Name, new.Price, new.Quantity, new.Alcohol);
		 end if;
		 IF new.Itemtype = 'F' then
			INSERT INTO cafedb.FOOD_MENU_VIEW value (new.ItemID, new.Name, new.Price, new.Quantity, new.vegan);
         end if;
     end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `menu_item_update_trigger` BEFORE UPDATE ON `menu_item` FOR EACH ROW begin
         DECLARE isGood BOOLEAN;

         SET isGood = check_type(new.Itemtype, new.Alcohol, new.Vegan);

         IF (!isGood) THEN
             signal sqlstate '45000'
             SET MESSAGE_TEXT = 'Incorrect attribute values for item type';
             END IF;

     end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `menu_item_updateafter_trigger` AFTER UPDATE ON `menu_item` FOR EACH ROW begin

         -- delete old row from materialized view then insert new row
         if old.Itemtype = 'F' then
            DELETE FROM cafedb.FOOD_MENU_VIEW WHERE FOOD_MENU_VIEW.ItemID = old.ItemID;
         end if;

         if new.Itemtype = 'F' then
            INSERT INTO cafedb.FOOD_MENU_VIEW value (new.ItemID, new.Name, new.Price, new.Quantity, new.vegan);
		 end if;
         
                  -- delete old row from materialized view then insert new row
         if old.Itemtype = 'D' then
            DELETE FROM cafedb.DRINKS_MENU_VIEW WHERE DRINKS_MENU_VIEW.ItemID = old.ItemID;
         end if;

         if new.Itemtype = 'D' then
            INSERT INTO cafedb.DRINKS_MENU_VIEW value (new.ItemID, new.Name, new.Price, new.Quantity, new.Alcohol);
		 end if;
     end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_contents`
--

CREATE TABLE `order_contents` (
  `CustomerID` int(11) NOT NULL,
  `OrderNum` int(11) NOT NULL,
  `ItemID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_contents`
--

INSERT INTO `order_contents` (`CustomerID`, `OrderNum`, `ItemID`) VALUES
(10389209, 80, 8233),
(10389209, 80, 8534),
(10389209, 81, 5675),
(10389209, 81, 5732),
(10389209, 81, 7821),
(34543234, 82, 182),
(34543234, 82, 6341),
(34543234, 83, 1029),
(34543234, 83, 8213),
(34543234, 84, 5623),
(34543234, 84, 5675),
(44739990, 76, 4256),
(44739990, 76, 5675),
(44739990, 77, 4256),
(44739990, 77, 5675),
(44739990, 78, 4256),
(44739990, 78, 5675),
(44739990, 79, 5732),
(44739990, 79, 6341),
(56886567, 35, 4256),
(56886567, 35, 7317),
(68168958, 85, 5623),
(68168958, 85, 5732);

-- --------------------------------------------------------

--
-- Stand-in structure for view `pcs`
-- (See below for the actual view)
--
CREATE TABLE `pcs` (
`GameID` int(11)
,`ComputerNum` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `StaffID` int(11) NOT NULL,
  `FirstName` varchar(15) NOT NULL,
  `MiddleName` varchar(15) DEFAULT NULL,
  `LastName` varchar(15) NOT NULL,
  `Ssn` int(11) NOT NULL,
  `SuperVisorID` int(11) DEFAULT NULL,
  `PayRate` decimal(4,2) NOT NULL,
  `Tips` decimal(5,2) DEFAULT NULL,
  `Bonus` decimal(5,2) DEFAULT NULL,
  `StaffType` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`StaffID`, `FirstName`, `MiddleName`, `LastName`, `Ssn`, `SuperVisorID`, `PayRate`, `Tips`, `Bonus`, `StaffType`) VALUES
(9344, 'Gillian', NULL, 'Micheals', 298982376, 55456, '13.50', '30.00', NULL, 'W'),
(23454, 'Hanna', NULL, 'Ramone', 234092334, 55456, '13.50', '25.00', NULL, 'W'),
(45654, 'Jerry', NULL, 'Stevens', 98234998, 55456, '13.50', '20.00', NULL, 'W'),
(55456, 'Luis', 'Fernando', 'Alvarez', 637989888, NULL, '30.00', NULL, '500.00', 'M');

--
-- Triggers `staff`
--
DELIMITER $$
CREATE TRIGGER `staff_delete_trigger` BEFORE DELETE ON `staff` FOR EACH ROW begin
         -- delete old row from MANAGER_VIEW
         if old.StaffID in (select StaffID from MANAGER_VIEW) then
            DELETE FROM cafedb.MANAGER_VIEW WHERE MANAGER_VIEW.StaffID = old.StaffID;
         end if;
		 -- delete old row from WAITER_VIEW
         if old.StaffID in (select StaffID from WAITER_VIEW) then
            DELETE FROM cafedb.WAITER_VIEW WHERE WAITER_VIEW.StaffID = old.StaffID;
         end if;
     end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `staff_insert_trigger` BEFORE INSERT ON `staff` FOR EACH ROW begin
         DECLARE isGood BOOLEAN;
         -- check participation and disjoint
         SET isGood = staff_type(new.StaffType, new.Tips, new.Bonus);
         IF (!isGood) THEN
             signal sqlstate '45000'
             SET MESSAGE_TEXT = 'Incorrect attribute values for staff type';
         end if;
     end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `staff_insertafter_trigger` AFTER INSERT ON `staff` FOR EACH ROW begin
         IF new.StaffType = 'M' then
            INSERT INTO cafedb.MANAGER_VIEW value (new.StaffID, new.FirstName, new.MiddleName, new.LastName, new.Ssn, new.SupervisorID, new.PayRate, new.Bonus);
		 end if;
		 IF new.StaffType = 'W' then
			INSERT INTO cafedb.WAITER_VIEW value (new.StaffID, new.FirstName, new.MiddleName, new.LastName, new.Ssn, new.SupervisorID, new.PayRate, new.Tips);
         end if;
     end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `staff_update_trigger` BEFORE UPDATE ON `staff` FOR EACH ROW begin
         DECLARE isGood BOOLEAN;

          SET isGood = staff_type(new.StaffType, new.Tips, new.Bonus);

         IF (!isGood) THEN
             signal sqlstate '45000'
             SET MESSAGE_TEXT = 'Incorrect attribute values for game type';
             END IF;
     end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `staff_updateafter_trigger` AFTER UPDATE ON `staff` FOR EACH ROW begin

         -- delete old row from materialized view then insert new row
         if old.StaffType = 'M' then
            DELETE FROM cafedb.MANAGER_VIEW WHERE MANAGER_VIEW.StaffID = old.StaffID;
         end if;

         if new.StaffType = 'M' then
            INSERT INTO cafedb.MANAGER_VIEW value (new.StaffID, new.FirstName, new.MiddleName, new.LastName, new.Ssn, new.SupervisorID, new.PayRate, new.Bonus);
		 end if;
         
                  -- delete old row from materialized view then insert new row
         if old.StaffType = 'W' then
            DELETE FROM cafedb.WAITER_VIEW WHERE WAITER_VIEW.StaffID = old.StaffID;
         end if;

         if new.StaffType = 'W' then
            INSERT INTO cafedb.WAITER_VIEW value (new.StaffID, new.FirstName, new.MiddleName, new.LastName, new.Ssn, new.SupervisorID, new.PayRate, new.Tips);
		 end if;
     end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `staff_phone`
--

CREATE TABLE `staff_phone` (
  `PStaffID` int(11) NOT NULL,
  `PhoneNum` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `staff_phone`
--

INSERT INTO `staff_phone` (`PStaffID`, `PhoneNum`) VALUES
(9344, '(408)-329-4893'),
(23454, '(408)-238-1267'),
(45654, '(408)-732-2343'),
(55456, '(408)-287-3755');

-- --------------------------------------------------------

--
-- Table structure for table `waiter_view`
--

CREATE TABLE `waiter_view` (
  `StaffID` int(11) NOT NULL,
  `FirstName` varchar(15) DEFAULT NULL,
  `MiddleName` varchar(15) DEFAULT NULL,
  `LastName` varchar(15) DEFAULT NULL,
  `Ssn` int(11) DEFAULT NULL,
  `SuperVisorID` int(11) DEFAULT NULL,
  `PayRate` decimal(4,2) DEFAULT NULL,
  `Tips` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `waiter_view`
--

INSERT INTO `waiter_view` (`StaffID`, `FirstName`, `MiddleName`, `LastName`, `Ssn`, `SuperVisorID`, `PayRate`, `Tips`) VALUES
(9344, 'Gillian', NULL, 'Micheals', 298982376, 55456, '13.50', '30.00'),
(23454, 'Hanna', NULL, 'Ramone', 234092334, 55456, '13.50', '25.00'),
(45654, 'Jerry', NULL, 'Stevens', 98234998, 55456, '13.50', '20.00');

-- --------------------------------------------------------

--
-- Table structure for table `works`
--

CREATE TABLE `works` (
  `WStaffID` int(11) NOT NULL,
  `WBoothNum` int(11) NOT NULL,
  `Hours` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `works`
--

INSERT INTO `works` (`WStaffID`, `WBoothNum`, `Hours`) VALUES
(9344, 3, 6),
(23454, 2, 8),
(45654, 1, 4);

-- --------------------------------------------------------

--
-- Structure for view `boardgames`
--
DROP TABLE IF EXISTS `boardgames`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `boardgames`  AS  (select `game`.`GameID` AS `GameID`,`game`.`BoardName` AS `BoardName`,`game`.`PlayerNum` AS `PlayerNum` from `game` where `game`.`GameType` = 'B') ;

-- --------------------------------------------------------

--
-- Structure for view `consoles`
--
DROP TABLE IF EXISTS `consoles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `consoles`  AS  (select `game`.`GameID` AS `GameID`,`game`.`ConsoleType` AS `ConsoleType`,`game`.`ControllerAmnt` AS `ControllerAmnt` from `game` where `game`.`GameType` = 'C') ;

-- --------------------------------------------------------

--
-- Structure for view `pcs`
--
DROP TABLE IF EXISTS `pcs`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pcs`  AS  (select `game`.`GameID` AS `GameID`,`game`.`ComputerNum` AS `ComputerNum` from `game` where `game`.`GameType` = 'P') ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booth`
--
ALTER TABLE `booth`
  ADD PRIMARY KEY (`BoothID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`CustomerID`),
  ADD KEY `CUSTOMER_GAME_fk` (`GameID`),
  ADD KEY `CUSTOMER_BOOTH_fk` (`BoothID`);

--
-- Indexes for table `customer_order`
--
ALTER TABLE `customer_order`
  ADD PRIMARY KEY (`OCustomerID`,`OrderNum`);

--
-- Indexes for table `customer_phone`
--
ALTER TABLE `customer_phone`
  ADD PRIMARY KEY (`PCustomerID`,`PhoneNum`);

--
-- Indexes for table `drinks_menu_view`
--
ALTER TABLE `drinks_menu_view`
  ADD PRIMARY KEY (`ItemID`);

--
-- Indexes for table `food_menu_view`
--
ALTER TABLE `food_menu_view`
  ADD PRIMARY KEY (`ItemID`);

--
-- Indexes for table `game`
--
ALTER TABLE `game`
  ADD PRIMARY KEY (`GameID`);

--
-- Indexes for table `manager_view`
--
ALTER TABLE `manager_view`
  ADD PRIMARY KEY (`StaffID`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`MCustomerID`);

--
-- Indexes for table `members_view`
--
ALTER TABLE `members_view`
  ADD PRIMARY KEY (`CustomerID`);

--
-- Indexes for table `menu_item`
--
ALTER TABLE `menu_item`
  ADD PRIMARY KEY (`ItemID`);

--
-- Indexes for table `order_contents`
--
ALTER TABLE `order_contents`
  ADD PRIMARY KEY (`CustomerID`,`OrderNum`,`ItemID`),
  ADD KEY `ORDER_CONTENTS_MENU_ITEM_fk` (`ItemID`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`StaffID`),
  ADD KEY `STAFF_SUPERVISOR_fk` (`SuperVisorID`);

--
-- Indexes for table `staff_phone`
--
ALTER TABLE `staff_phone`
  ADD PRIMARY KEY (`PStaffID`,`PhoneNum`);

--
-- Indexes for table `waiter_view`
--
ALTER TABLE `waiter_view`
  ADD PRIMARY KEY (`StaffID`);

--
-- Indexes for table `works`
--
ALTER TABLE `works`
  ADD PRIMARY KEY (`WStaffID`,`WBoothNum`),
  ADD KEY `Works_BOOTHID_fk` (`WBoothNum`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `CUSTOMER_BOOTH_fk` FOREIGN KEY (`BoothID`) REFERENCES `booth` (`BoothID`) ON DELETE SET NULL,
  ADD CONSTRAINT `CUSTOMER_GAME_fk` FOREIGN KEY (`GameID`) REFERENCES `game` (`GameID`) ON DELETE SET NULL;

--
-- Constraints for table `customer_order`
--
ALTER TABLE `customer_order`
  ADD CONSTRAINT `CUSTOMER_ORDER_CUSTID_fk` FOREIGN KEY (`OCustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE CASCADE;

--
-- Constraints for table `customer_phone`
--
ALTER TABLE `customer_phone`
  ADD CONSTRAINT `CUSTOMER_PHONE_fk` FOREIGN KEY (`PCustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE CASCADE;

--
-- Constraints for table `drinks_menu_view`
--
ALTER TABLE `drinks_menu_view`
  ADD CONSTRAINT `DRINKS_MENU_fk` FOREIGN KEY (`ItemID`) REFERENCES `menu_item` (`ItemID`);

--
-- Constraints for table `food_menu_view`
--
ALTER TABLE `food_menu_view`
  ADD CONSTRAINT `FOOD_MENU_fk` FOREIGN KEY (`ItemID`) REFERENCES `menu_item` (`ItemID`);

--
-- Constraints for table `manager_view`
--
ALTER TABLE `manager_view`
  ADD CONSTRAINT `MANAGER_VIEW_fk` FOREIGN KEY (`StaffID`) REFERENCES `staff` (`StaffID`);

--
-- Constraints for table `member`
--
ALTER TABLE `member`
  ADD CONSTRAINT `MEMBER_CUSTOMERID_fk` FOREIGN KEY (`MCustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE CASCADE;

--
-- Constraints for table `members_view`
--
ALTER TABLE `members_view`
  ADD CONSTRAINT `MEMBER_VIEW_pk` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`);

--
-- Constraints for table `order_contents`
--
ALTER TABLE `order_contents`
  ADD CONSTRAINT `ORDER_CONTENTS_CUSTOMER_fk` FOREIGN KEY (`CustomerID`,`OrderNum`) REFERENCES `customer_order` (`OCustomerID`, `OrderNum`) ON DELETE CASCADE,
  ADD CONSTRAINT `ORDER_CONTENTS_MENU_ITEM_fk` FOREIGN KEY (`ItemID`) REFERENCES `menu_item` (`ItemID`);

--
-- Constraints for table `staff`
--
ALTER TABLE `staff`
  ADD CONSTRAINT `STAFF_SUPERVISOR_fk` FOREIGN KEY (`SuperVisorID`) REFERENCES `staff` (`StaffID`) ON DELETE SET NULL;

--
-- Constraints for table `staff_phone`
--
ALTER TABLE `staff_phone`
  ADD CONSTRAINT `STAFF_PHONE_fk` FOREIGN KEY (`PStaffID`) REFERENCES `staff` (`StaffID`) ON DELETE CASCADE;

--
-- Constraints for table `waiter_view`
--
ALTER TABLE `waiter_view`
  ADD CONSTRAINT `WAITER_VIEW_fk` FOREIGN KEY (`StaffID`) REFERENCES `staff` (`StaffID`);

--
-- Constraints for table `works`
--
ALTER TABLE `works`
  ADD CONSTRAINT `Works_BOOTHID_fk` FOREIGN KEY (`WBoothNum`) REFERENCES `booth` (`BoothID`) ON DELETE CASCADE,
  ADD CONSTRAINT `Works_STAFFID_fk` FOREIGN KEY (`WStaffID`) REFERENCES `staff` (`StaffID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
