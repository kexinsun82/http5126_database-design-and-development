SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` smallint(4) UNSIGNED NOT NULL COMMENT 'Primary key for this table.',
  `last_name` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `sin` int(9) UNSIGNED NOT NULL COMMENT 'Social Insurance Number',
  `phone` int(10) UNSIGNED NOT NULL,
  `role` varchar(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Pet store employees table for HTTP5126.';

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `last_name`, `first_name`, `sin`, `phone`, `role`) VALUES
(110, 'Maracle', 'James', 123456789, 4165551234, 'Manager'),
(111, 'Marquis', 'Henry', 987654321, 4165551235, 'Sales'),
(112, 'Kaur', 'Jas', 456123789, 4165551236, 'Sales'),
(113, 'Neema', 'Hank', 654987321, 4165551237, 'Assistant'),
(114, 'Said', 'Farud', 258741369, 4165551238, 'Sales'),
(115, 'Fitzpatrick', 'Henry', 753951842, 4165551239, 'Stock');

-- --------------------------------------------------------

--
-- Table structure for table `stock_items`
--

CREATE TABLE `stock_items` (
  `id` smallint(5) UNSIGNED NOT NULL COMMENT 'Primary key for this table.',
  `item` varchar(30) NOT NULL COMMENT 'Name of stock item.',
  `price` decimal(10,0) NOT NULL COMMENT 'Retail price of item.',
  `inventory` smallint(4) NOT NULL COMMENT 'How many currently in stock.',
  `category` varchar(7) NOT NULL COMMENT 'Animal group this item is for.'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Pet store demo table for HTTP5126.';

--
-- Dumping data for table `stock_items`
--

INSERT INTO `stock_items` (`id`, `item`, `price`, `inventory`, `category`) VALUES
(1001, 'Luxury dog bed', '95', 2, 'Canine'),
(1002, 'Super size chew toy', '15', 45, 'Canine'),
(1003, 'Water dish', '87', 11, 'Feline '),
(1004, 'Fish bowl starter kit', '46', 22, 'Piscine'),
(1005, 'Luxury cat bed', '89', 0, 'Feline '),
(1006, 'Just as good dog bed', '74', 14, 'Canine'),
(1007, 'Deluxe Aquarium', '12', 10, 'Piscine'),
(1008, 'Terrarium', '231', 24, 'Murine'),
(1009, 'Cat stand', '55', 6, 'Feline '),
(1010, 'Premium Terrarium', '524', 2, 'Murine'),
(1011, 'Water dish', '10', 88, 'Canine'),
(1012, 'Giant clam aerator', '15', 12, 'Piscine'),
(1013, 'Small cage', '20', 26, 'Murine'),
(1014, 'Small chew toy', '6', 123, 'Canine'),
(1015, 'Collar', '12', 65, 'Feline '),
(1016, 'Collar', '15', 87, 'Canine'),
(1017, 'Air pump', '18', 36, 'Piscine'),
(1018, 'Hamster tubes', '65', 12, 'Murine'),
(1019, 'Large cage', '30', 11, 'Murine'),
(1020, 'Leash', '18', 88, 'Canine');
COMMIT;

