-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Aug 15, 2018 at 04:00 PM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `db_penjualan`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_category`
--

CREATE TABLE IF NOT EXISTS `tbl_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `tbl_category`
--

INSERT INTO `tbl_category` (`id`, `name`, `description`) VALUES
(1, 'category 1', 'namea'),
(2, 'tesyt name', 'teat descriaaaptionh'),
(3, 'tesyt name', 'teat desacriptionh'),
(7, 'a', 'a');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customer`
--

CREATE TABLE IF NOT EXISTS `tbl_customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) NOT NULL DEFAULT '25d55ad283aa400af464c76d713c07ad',
  `name` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `status` enum('active','nonactive') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `tbl_customer`
--

INSERT INTO `tbl_customer` (`id`, `username`, `password`, `name`, `address`, `phone`, `email`, `status`) VALUES
(1, 'customer 1', '25d55ad283aa400af464c76d713c07ad', '', '', '', '', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_product`
--

CREATE TABLE IF NOT EXISTS `tbl_product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` int(10) NOT NULL DEFAULT '0',
  `base_price` int(11) NOT NULL DEFAULT '0',
  `stock` int(10) NOT NULL DEFAULT '0',
  `image` varchar(255) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

--
-- Dumping data for table `tbl_product`
--

INSERT INTO `tbl_product` (`id`, `name`, `description`, `price`, `base_price`, `stock`, `image`, `category_id`, `created`, `modified`) VALUES
(1, '', '', 9, 0, 89, NULL, 1, '0000-00-00 00:00:00', '2018-07-12 01:10:00'),
(2, 'asd', 'asdasd', 0, 0, 0, NULL, 7, '0000-00-00 00:00:00', '2018-07-28 13:07:37'),
(19, 'aa', 'teat descriptionh', 0, 0, 0, '1133816201807281127195625043.jpg', 1, '2018-07-28 16:27:22', '2018-07-28 23:27:22');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sale`
--

CREATE TABLE IF NOT EXISTS `tbl_sale` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `total_items` int(11) NOT NULL,
  `proof` varchar(255) NOT NULL,
  `status` enum('process','accepted','canceled') NOT NULL DEFAULT 'process',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `buy_user_id` (`customer_id`,`user_id`,`product_id`),
  KEY `work_user_id` (`user_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `tbl_sale`
--

INSERT INTO `tbl_sale` (`id`, `customer_id`, `user_id`, `product_id`, `total_items`, `proof`, `status`, `created`) VALUES
(1, 1, NULL, 1, 10, '', 'process', '2018-07-26 15:29:08'),
(2, 1, NULL, 1, 22, '', 'process', '2018-07-26 15:29:08'),
(3, 1, NULL, 1, 20, '', 'canceled', '2018-07-26 15:57:19');

--
-- Triggers `tbl_sale`
--
DROP TRIGGER IF EXISTS `stockBuy`;
DELIMITER //
CREATE TRIGGER `stockBuy` AFTER INSERT ON `tbl_sale`
 FOR EACH ROW begin
declare banyakstock int;
declare harga int;
declare baseprice int;
SELECT stock into @banyakstock fROM tbl_product WHERE id = new.product_id; 
SELECT price into @harga fROM tbl_product WHERE id = new.product_id; 
SELECT base_price into @baseprice fROM tbl_product WHERE id = new.product_id; 

    insert tbl_stock set 
    product_id = new.product_id , 
    kredit = new.total_items, 
    description = "buy",
    price = @harga, 
    base_price = @baseprice , 
    customer_id = new.customer_id, 
    sale_id = new.id;




	

end
//
DELIMITER ;
DROP TRIGGER IF EXISTS `stockCancel`;
DELIMITER //
CREATE TRIGGER `stockCancel` AFTER UPDATE ON `tbl_sale`
 FOR EACH ROW begin

declare harga int;
declare baseprice int;
 
SELECT price into @harga fROM tbl_stock WHERE sale_id = new.id; 
SELECT base_price into @baseprice fROM tbl_stock WHERE sale_id = new.id; 
if (new.status = 'canceled')
then

    insert tbl_stock set 
    product_id = new.product_id , 
    debit = new.total_items, 
    description = "cancel",
    price = @harga, 
    base_price = @baseprice , 
    customer_id = new.customer_id, 
    sale_id = new.id;




	
end if;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_stock`
--

CREATE TABLE IF NOT EXISTS `tbl_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `debit` int(11) NOT NULL DEFAULT '0',
  `kredit` int(11) NOT NULL DEFAULT '0',
  `description` enum('add','adjust','buy','cancel') NOT NULL,
  `price` int(11) NOT NULL,
  `base_price` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `stock_id` int(11) DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `customer_id` (`customer_id`),
  KEY `sale_id_2` (`sale_id`),
  KEY `user_id` (`user_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `tbl_stock`
--

INSERT INTO `tbl_stock` (`id`, `product_id`, `debit`, `kredit`, `description`, `price`, `base_price`, `date`, `user_id`, `customer_id`, `stock_id`, `sale_id`) VALUES
(3, 1, 10, 0, 'add', 0, 0, '2018-07-26 15:56:51', 1, NULL, NULL, NULL),
(4, 1, 0, 20, 'buy', 9, 0, '2018-07-26 15:57:19', NULL, 1, NULL, 3),
(15, 1, 20, 0, 'cancel', 9, 0, '2018-07-26 16:06:50', NULL, 1, NULL, 3);

--
-- Triggers `tbl_stock`
--
DROP TRIGGER IF EXISTS `adjustProduct`;
DELIMITER //
CREATE TRIGGER `adjustProduct` AFTER INSERT ON `tbl_stock`
 FOR EACH ROW begin
declare banyakstock int;
declare harga int;
declare hargapokok int;
SELECT stock into @banyakstock fROM tbl_product WHERE id = new.product_id; 
SELECT price into @harga fROM tbl_product WHERE id = new.product_id; 
SELECT base_price into @hargapokok fROM tbl_product WHERE id = new.product_id; 



     if new.description = 'add'  or new.description = 'cancel' then
    	update tbl_product set 
        	stock = @banyakstock + new.debit , 
            price =( (@banyakstock * @harga ) + (new.debit * new.price) )/ (@banyakstock + new.debit) ,
            base_price = ( (@banyakstock * @hargapokok ) + (new.debit * new.base_price) )/ (@banyakstock + new.debit) 
            where id = new.product_id;
        end if;
	 if new.description = 'adjust' or new.description = 'buy' then
		update tbl_product set 
        stock = @banyakstock - new.kredit ,
        price =( (@banyakstock * @harga ) - (new.kredit * new.price) )/ (@banyakstock - new.kredit) ,
        base_price = ( (@banyakstock * @hargapokok ) - (new.kredit * new.base_price) )/ (@banyakstock - new.kredit) 
        where id = new.product_id;
    
	end if;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE IF NOT EXISTS `tbl_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `level` enum('admin','super') NOT NULL,
  `name` varchar(30) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `status` enum('active','nonactive') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1114 ;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`id`, `username`, `password`, `level`, `name`, `address`, `phone`, `email`, `status`) VALUES
(1, 'lglg', '25d55ad283aa400af464c76d713c07ad', 'admin', 'linargian pratama', '', '', '', 'active'),
(1113, 'muhajir', '25d55ad283aa400af464c76d713c07ad', 'admin', '', '', '', '', 'active');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_product`
--
ALTER TABLE `tbl_product`
  ADD CONSTRAINT `tbl_product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `tbl_category` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `tbl_sale`
--
ALTER TABLE `tbl_sale`
  ADD CONSTRAINT `tbl_sale_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `tbl_customer` (`id`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tbl_sale_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tbl_sale_ibfk_3` FOREIGN KEY (`product_id`) REFERENCES `tbl_product` (`id`) ON UPDATE NO ACTION;

--
-- Constraints for table `tbl_stock`
--
ALTER TABLE `tbl_stock`
  ADD CONSTRAINT `tbl_stock_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `tbl_product` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_stock_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_stock_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `tbl_customer` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_stock_ibfk_4` FOREIGN KEY (`sale_id`) REFERENCES `tbl_sale` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_stock_ibfk_5` FOREIGN KEY (`stock_id`) REFERENCES `tbl_stock` (`id`) ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
