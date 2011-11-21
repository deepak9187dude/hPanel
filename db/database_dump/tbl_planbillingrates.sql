-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 17, 2011 at 05:54 PM
-- Server version: 5.1.54
-- PHP Version: 5.3.5-1ubuntu7.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `vmcomplete_sadmin`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_planbillingrates`
--


INSERT INTO `plan_billing_rates` (`id`, `plan_id`, `rec_monthly`, `rec_quaterly`, `rec_semiyear`, `rec_yearly`, `monthly`, `quaterly`, `semi`, `yearly`, `active_plan`) VALUES
(1, 1, 1.99, 0, 0, 0, 1, 0, 0, 0, 1),
(2, 2, 0, 3.99, 0, 0, 0, 2, 0, 0, 1),
(3, 3, 0, 3.99, 5, 0, 0, 0, 3, 0, 1),
(4, 4, 0, 3.99, 5, 7, 0, 0, 0, 4, 1),
(5, 5, 1, 2, 3, 4, 1, 2, 3, 4, 1),
(6, 6, 1, 2, 3, 4, 1, 2, 3, 4, 1),
(7, 7, 1, 2, 3, 4, 1, 2, 3, 4, 1),
(8, 8, 11, 22, 33, 44, 1, 2, 3, 4, 1),
(9, 9, 0, 0, 1.5, 0, 0, 0, 3, 0, 1),
(10, 10, 1.34, 0, 0, 0, 1, 0, 0, 0, 0),
(11, 11, 12.99, 13.99, 14.99, 0, 1, 2, 3, 0, 0),
(12, 12, 0, 7.4, 0, 0, 0, 2, 0, 0, 0),
(13, 13, 7.9, 0, 0, 0, 1, 0, 0, 0, 1),
(14, 14, 12.99, 13.99, 14.99, 3, 1, 2, 3, 4, 1),
(15, 15, 11, 0, 0, 0, 1, 0, 0, 0, 1),
(16, 16, 1.34, 0, 0, 0, 1, 0, 0, 0, 1),
(17, 17, 0, 7.4, 0, 0, 0, 2, 0, 0, 1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
