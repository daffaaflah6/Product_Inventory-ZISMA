-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 10, 2019 at 04:07 PM
-- Server version: 5.7.25-0ubuntu0.16.04.2
-- PHP Version: 7.0.32-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `toko`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `idbarang` varchar(5) NOT NULL,
  `nama` varchar(45) DEFAULT NULL,
  `harga` int(3) DEFAULT NULL,
  `diskon` tinyint(3) DEFAULT '0',
  `pajak` tinyint(3) DEFAULT '0',
  `stok` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`idbarang`, `nama`, `harga`, `diskon`, `pajak`, `stok`) VALUES
('PI001', 'Sepatu Adidas', 100000, 5, 0, 25),
('PI002', 'Sandal Gunung', 60000, 15, 0, 20),
('PI003', 'Tas Sekolah', 350000, 10, 0, 20);

--
-- Triggers `barang`
--
DELIMITER $$
CREATE TRIGGER `after_insert_barang` AFTER INSERT ON `barang` FOR EACH ROW INSERT INTO stok SET
stok.idbarang = new.idbarang,
stok.masuk = new.stok,
stok.terjual = 0,
stok.updated_at = CURRENT_DATE
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `stok`
--

CREATE TABLE `stok` (
  `idstok` int(11) NOT NULL,
  `idbarang` varchar(5) DEFAULT NULL,
  `masuk` tinytext,
  `terjual` tinyint(1) DEFAULT NULL,
  `updated_at` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `stok`
--

INSERT INTO `stok` (`idstok`, `idbarang`, `masuk`, `terjual`, `updated_at`) VALUES
(1, 'PI001', '10', 0, '2021-05-31'),
(2, 'PI002', '13', 0, '2021-05-31'),
(3, 'PI003', '8', 0, '2021-05-31'),
(4, 'PI002', '7', 0, '2021-06-07'),
(5, 'PI001', '8', 0, '2021-06-07'),
(6, 'PI001', '7', 0, '2021-06-14'),
(7, 'PI003', '12', 0, '2021-06-14');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `username` varchar(65) NOT NULL,
  `password` varchar(200) DEFAULT NULL,
  `nama` varchar(65) DEFAULT NULL,
  `akses` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`username`, `password`, `nama`, `akses`) VALUES
('admin', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'ZISMA', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_barang`
--
CREATE TABLE `v_barang` (
  `idbarang` varchar(5),
  `nama` varchar(50),
  `harga` varchar(50),
  `diskon` varchar(6),
  `pajak` varchar(6),
  `stok` tinyint(1),
  `terjual` tinyint(1),
  `total` tinytext,
  `last_modified` date
);

-- --------------------------------------------------------

--
-- Structure for view `v_barang`
--
DROP TABLE IF EXISTS `v_barang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_barang`  AS  select `barang`.`idbarang` AS `idbarang`,`barang`.`nama` AS `nama`,(select concat('Rp ',format(`barang`.`harga`,0))) AS `harga`,(select concat(`barang`.`diskon`,' %')) AS `diskon`,(select concat(`barang`.`pajak`,' %')) AS `pajak`,`barang`.`stok` AS `stok`,`stok`.`terjual` AS `terjual`,`stok`.`masuk` AS `total`,`stok`.`updated_at` AS `last_modified` from (`stok` join `barang` on((`barang`.`idbarang` = `stok`.`idbarang`))) order by `stok`.`updated_at` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`idbarang`);

--
-- Indexes for table `stok`
--
ALTER TABLE `stok`
  ADD PRIMARY KEY (`idstok`),
  ADD KEY `fk_stok_barang_idx` (`idbarang`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `stok`
--
ALTER TABLE `stok`
  MODIFY `idstok` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `stok`
--
ALTER TABLE `stok`
  ADD CONSTRAINT `fk_stok_barang` FOREIGN KEY (`idbarang`) REFERENCES `barang` (`idbarang`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
