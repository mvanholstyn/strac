-- MySQL dump 10.10
--
-- Host: localhost    Database: strac_development
-- ------------------------------------------------------
-- Server version	5.0.24a-Debian_9ubuntu2-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
CREATE TABLE `activities` (
  `id` int(11) NOT NULL auto_increment,
  `actor_id` int(11) default NULL,
  `action` varchar(255) default NULL,
  `direct_object_id` int(11) default NULL,
  `direct_object_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `indirect_object_id` int(11) default NULL,
  `indirect_object_type` varchar(255) default NULL,
  `project_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `activities`
--


/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
LOCK TABLES `activities` WRITE;
INSERT INTO `activities` VALUES (18,1,'updated',61,'Story','2007-03-26 14:29:22',NULL,NULL,1),(19,1,'updated',61,'Story','2007-03-26 14:29:26',NULL,NULL,1),(20,1,'updated',61,'Story','2007-03-28 00:41:15',NULL,NULL,1),(21,1,'updated',71,'Story','2007-03-28 00:42:39',NULL,NULL,1),(22,1,'updated',70,'Story','2007-03-28 00:42:44',NULL,NULL,1),(23,1,'updated',65,'Story','2007-03-28 00:42:46',NULL,NULL,1),(24,1,'updated',64,'Story','2007-03-28 00:43:17',NULL,NULL,1),(25,1,'updated',64,'Story','2007-03-28 00:43:19',NULL,NULL,1),(26,1,'updated',64,'Story','2007-03-28 00:43:22',NULL,NULL,1),(27,1,'updated',64,'Story','2007-03-28 00:43:36',NULL,NULL,1),(28,1,'updated',71,'Story','2007-03-28 00:43:45',NULL,NULL,1),(29,1,'updated',71,'Story','2007-03-28 00:43:48',NULL,NULL,1),(30,1,'updated',64,'Story','2007-03-28 00:43:49',NULL,NULL,1),(31,1,'updated',71,'Story','2007-03-28 00:43:55',NULL,NULL,1),(32,1,'updated',24,'Story','2007-03-28 00:44:23',NULL,NULL,1),(33,1,'create',73,'Story','2007-03-28 00:48:40',NULL,NULL,1),(34,1,'create',74,'Story','2007-03-28 00:49:17',NULL,NULL,1),(35,1,'create',75,'Story','2007-03-28 00:49:33',NULL,NULL,1),(36,1,'create',76,'Story','2007-03-28 00:50:38',NULL,NULL,1),(37,1,'updated',25,'Story','2007-03-28 09:42:54',NULL,NULL,1),(38,1,'updated',25,'Story','2007-03-28 09:42:56',NULL,NULL,1),(39,1,'updated',72,'Story','2007-03-28 17:47:39',NULL,NULL,1),(40,1,'updated',62,'Story','2007-03-28 17:47:40',NULL,NULL,1),(41,1,'updated',62,'Story','2007-03-28 17:47:43',NULL,NULL,1),(42,1,'updated',72,'Story','2007-03-28 17:47:45',NULL,NULL,1),(43,1,'updated',25,'Story','2007-03-28 17:48:02',NULL,NULL,1),(44,1,'updated',25,'Story','2007-03-28 17:48:04',NULL,NULL,1),(45,1,'updated',56,'Story','2007-03-28 17:50:25',NULL,NULL,1),(46,1,'updated',33,'Story','2007-03-28 18:22:52',NULL,NULL,1),(47,1,'updated',33,'Story','2007-03-28 18:22:55',NULL,NULL,1),(48,1,'updated',33,'Story','2007-03-28 20:17:05',NULL,NULL,1),(49,1,'updated',61,'Story','2007-03-28 20:17:10',NULL,NULL,1),(50,1,'updated',64,'Story','2007-03-28 20:17:11',NULL,NULL,1),(51,1,'updated',71,'Story','2007-03-28 20:17:12',NULL,NULL,1),(52,1,'updated',32,'Story','2007-03-28 20:17:14',NULL,NULL,1),(53,1,'updated',32,'Story','2007-03-28 20:17:23',NULL,NULL,1),(54,1,'updated',71,'Story','2007-03-28 20:17:23',NULL,NULL,1),(55,1,'updated',64,'Story','2007-03-28 20:17:24',NULL,NULL,1),(56,1,'updated',61,'Story','2007-03-28 20:17:25',NULL,NULL,1),(57,1,'updated',33,'Story','2007-03-28 20:17:25',NULL,NULL,1),(58,1,'created',77,'Story','2007-03-28 20:30:22',NULL,NULL,1),(59,2,'updated',72,'Story','2007-03-28 22:40:46',NULL,NULL,1),(60,2,'updated',72,'Story','2007-03-28 22:42:28',NULL,NULL,1),(61,2,'created',78,'Story','2007-03-28 22:49:21',NULL,NULL,1),(62,2,'created',79,'Story','2007-03-28 22:50:32',NULL,NULL,1),(63,4,'created',80,'Story','2007-03-29 09:41:27',NULL,NULL,1),(64,2,'updated',72,'Story','2007-03-29 19:53:28',NULL,NULL,1),(65,2,'updated',62,'Story','2007-03-29 20:38:00',NULL,NULL,1),(66,2,'updated',62,'Story','2007-03-29 20:38:04',NULL,NULL,1),(67,2,'created',81,'Story','2007-03-30 22:16:39',NULL,NULL,1),(68,2,'updated',81,'Story','2007-03-30 22:17:44',NULL,NULL,1),(69,2,'created',82,'Story','2007-03-30 22:19:29',NULL,NULL,1),(70,2,'updated',62,'Story','2007-03-30 22:21:07',NULL,NULL,1),(71,2,'updated',62,'Story','2007-03-30 22:33:35',NULL,NULL,1),(72,2,'updated',78,'Story','2007-03-30 22:38:38',NULL,NULL,1),(73,2,'updated',78,'Story','2007-03-30 22:39:04',NULL,NULL,1),(74,2,'updated',78,'Story','2007-03-30 22:39:11',NULL,NULL,1),(75,2,'updated',78,'Story','2007-03-30 22:47:38',NULL,NULL,1),(80,2,'updated',82,'Story','2007-03-30 22:51:59',NULL,NULL,1),(81,2,'updated',81,'Story','2007-03-30 22:52:06',NULL,NULL,1),(82,2,'updated',75,'Story','2007-03-30 22:54:49',NULL,NULL,1),(83,2,'updated',74,'Story','2007-03-30 22:56:38',NULL,NULL,1),(84,2,'updated',74,'Story','2007-03-30 23:16:35',NULL,NULL,1),(85,2,'updated',81,'Story','2007-03-30 23:19:29',NULL,NULL,1),(86,1,'updated',62,'Story','2007-03-31 00:05:09',NULL,NULL,1),(87,1,'updated',75,'Story','2007-03-31 00:07:08',NULL,NULL,1),(94,1,'updated',75,'Story','2007-03-31 00:23:21',NULL,NULL,1),(95,1,'updated',79,'Story','2007-03-31 00:24:06',NULL,NULL,1),(96,2,'updated',75,'Story','2007-03-31 13:45:58',NULL,NULL,1),(97,2,'created',88,'Story','2007-03-31 14:01:57',NULL,NULL,1),(98,2,'updated',88,'Story','2007-03-31 14:02:16',NULL,NULL,1),(99,2,'updated',62,'Story','2007-03-31 14:16:13',NULL,NULL,1),(100,1,'updated',75,'Story','2007-04-01 16:44:25',NULL,NULL,1),(101,2,'created',89,'Story','2007-04-03 19:38:17',NULL,NULL,1),(102,2,'updated',81,'Story','2007-04-03 20:56:34',NULL,NULL,1),(103,2,'created',90,'Story','2007-04-03 20:58:39',NULL,NULL,1),(104,2,'updated',89,'Story','2007-04-03 20:58:58',NULL,NULL,1),(105,2,'updated',89,'Story','2007-04-03 20:59:03',NULL,NULL,1),(106,2,'updated',89,'Story','2007-04-03 20:59:39',NULL,NULL,1),(107,1,'updated',89,'Story','2007-04-03 21:28:57',NULL,NULL,1),(108,1,'updated',88,'Story','2007-04-04 18:17:15',NULL,NULL,1),(109,1,'updated',88,'Story','2007-04-04 18:18:01',NULL,NULL,1),(110,2,'created',91,'Story','2007-04-04 18:19:00',NULL,NULL,1),(111,1,'updated',77,'Story','2007-04-04 18:19:20',NULL,NULL,1),(112,1,'updated',73,'Story','2007-04-04 18:20:05',NULL,NULL,1),(113,2,'created',92,'Story','2007-04-04 18:20:40',NULL,NULL,1),(114,1,'updated',74,'Story','2007-04-04 18:21:52',NULL,NULL,1),(115,1,'updated',74,'Story','2007-04-04 18:22:13',NULL,NULL,1),(116,1,'created',93,'Story','2007-04-04 18:25:32',NULL,NULL,1),(117,1,'updated',93,'Story','2007-04-04 18:26:52',NULL,NULL,1),(118,1,'updated',88,'Story','2007-04-04 18:30:36',NULL,NULL,1),(119,1,'updated',93,'Story','2007-04-04 18:30:40',NULL,NULL,1),(120,1,'updated',92,'Story','2007-04-04 18:33:37',NULL,NULL,1),(121,1,'updated',74,'Story','2007-04-04 18:38:12',NULL,NULL,1),(122,1,'updated',74,'Story','2007-04-04 18:39:18',NULL,NULL,1),(123,1,'updated',64,'Story','2007-04-04 19:01:43',NULL,NULL,1),(124,1,'updated',91,'Story','2007-04-04 20:17:24',NULL,NULL,1),(125,1,'updated',91,'Story','2007-04-04 20:17:30',NULL,NULL,1),(126,1,'updated',91,'Story','2007-04-04 20:17:36',NULL,NULL,1),(127,1,'updated',31,'Story','2007-04-04 20:57:06',NULL,NULL,1),(128,1,'updated',31,'Story','2007-04-04 20:57:12',NULL,NULL,1),(129,1,'updated',31,'Story','2007-04-04 20:57:26',NULL,NULL,1),(130,1,'updated',31,'Story','2007-04-04 20:57:27',NULL,NULL,1),(131,1,'updated',90,'Story','2007-04-04 20:58:57',NULL,NULL,1),(132,1,'updated',90,'Story','2007-04-04 20:59:14',NULL,NULL,1),(133,2,'updated',24,'Story','2007-04-04 20:59:58',NULL,NULL,1),(134,2,'updated',24,'Story','2007-04-04 21:01:58',NULL,NULL,1),(135,6,'created',94,'Story','2007-04-04 21:02:01',NULL,NULL,1),(136,1,'updated',90,'Story','2007-04-04 21:10:26',NULL,NULL,1),(137,1,'updated',24,'Story','2007-04-04 22:09:07',NULL,NULL,1),(138,1,'updated',76,'Story','2007-04-04 22:09:10',NULL,NULL,1),(139,1,'updated',32,'Story','2007-04-04 22:09:11',NULL,NULL,1),(140,1,'updated',65,'Story','2007-04-04 22:09:12',NULL,NULL,1),(141,1,'updated',69,'Story','2007-04-04 22:09:13',NULL,NULL,1),(142,1,'updated',70,'Story','2007-04-04 22:09:14',NULL,NULL,1),(143,1,'updated',68,'Story','2007-04-04 22:09:17',NULL,NULL,1),(144,1,'updated',31,'Story','2007-04-04 22:09:18',NULL,NULL,1),(145,1,'updated',26,'Story','2007-04-04 22:09:21',NULL,NULL,1),(146,1,'updated',25,'Story','2007-04-04 22:09:21',NULL,NULL,1),(147,1,'updated',68,'Story','2007-04-04 22:14:22',NULL,NULL,1),(148,1,'updated',25,'Story','2007-04-04 22:14:24',NULL,NULL,1),(149,1,'updated',26,'Story','2007-04-04 22:14:24',NULL,NULL,1),(150,1,'updated',94,'Story','2007-04-04 22:14:25',NULL,NULL,1),(151,1,'updated',31,'Story','2007-04-04 22:14:33',NULL,NULL,1),(154,1,'updated',82,'Story','2007-04-04 22:14:39',NULL,NULL,1),(155,1,'updated',80,'Story','2007-04-04 22:14:41',NULL,NULL,1),(156,1,'updated',69,'Story','2007-04-04 22:14:56',NULL,NULL,1),(157,1,'updated',76,'Story','2007-04-04 22:15:22',NULL,NULL,1),(158,1,'updated',65,'Story','2007-04-04 22:16:07',NULL,NULL,1),(159,1,'updated',90,'Story','2007-04-04 22:16:21',NULL,NULL,1),(160,1,'updated',90,'Story','2007-04-04 22:16:28',NULL,NULL,1),(161,1,'updated',71,'Story','2007-04-04 22:20:14',NULL,NULL,1),(162,1,'updated',33,'Story','2007-04-04 22:25:05',NULL,NULL,1),(163,1,'updated',33,'Story','2007-04-04 22:25:10',NULL,NULL,1),(164,1,'updated',33,'Story','2007-04-04 22:26:03',NULL,NULL,1),(165,1,'updated',90,'Story','2007-04-04 23:11:09',NULL,NULL,1),(166,1,'updated',65,'Story','2007-04-04 23:11:10',NULL,NULL,1),(167,2,'updated',6,'Story','2007-04-05 12:13:36',NULL,NULL,1),(168,2,'updated',11,'Story','2007-04-05 12:14:12',NULL,NULL,1),(169,2,'updated',16,'Story','2007-04-05 12:14:36',NULL,NULL,1),(170,2,'updated',64,'Story','2007-04-05 12:15:43',NULL,NULL,1),(171,2,'updated',64,'Story','2007-04-05 12:22:54',NULL,NULL,1),(172,2,'updated',64,'Story','2007-04-05 12:22:56',NULL,NULL,1),(173,1,'updated',16,'Story','2007-04-05 19:43:03',NULL,NULL,1),(174,1,'updated',32,'Story','2007-04-05 22:18:40',NULL,NULL,1),(175,1,'created',95,'Story','2007-04-05 22:30:00',NULL,NULL,1),(176,1,'updated',32,'Story','2007-04-05 22:30:09',NULL,NULL,1),(177,1,'updated',95,'Story','2007-04-05 22:31:19',NULL,NULL,1),(178,1,'updated',95,'Story','2007-04-05 22:32:10',NULL,NULL,1),(179,1,'updated',32,'Story','2007-04-05 22:33:10',NULL,NULL,1),(180,1,'updated',32,'Story','2007-04-05 22:33:17',NULL,NULL,1),(181,2,'created',96,'Story','2007-04-05 23:00:59',NULL,NULL,1),(182,1,'updated',32,'Story','2007-04-05 23:01:52',NULL,NULL,1),(183,1,'created',97,'Story','2007-04-05 23:02:55',NULL,NULL,1),(184,2,'created',98,'Story','2007-04-05 23:04:04',NULL,NULL,1),(185,2,'created',99,'Story','2007-04-05 23:07:12',NULL,NULL,1),(186,2,'updated',98,'Story','2007-04-05 23:08:23',NULL,NULL,1),(187,2,'updated',99,'Story','2007-04-05 23:08:41',NULL,NULL,1),(188,2,'created',100,'Story','2007-04-05 23:10:35',NULL,NULL,1),(189,2,'created',101,'Story','2007-04-05 23:14:12',NULL,NULL,1),(190,2,'created',102,'Story','2007-04-05 23:16:13',NULL,NULL,1),(192,1,'updated',102,'Story','2007-04-06 00:48:37',NULL,NULL,1),(193,1,'updated',100,'Story','2007-04-06 00:49:21',NULL,NULL,1),(194,1,'updated',100,'Story','2007-04-06 00:49:23',NULL,NULL,1),(195,1,'updated',100,'Story','2007-04-06 00:52:17',NULL,NULL,1),(197,1,'updated',100,'Story','2007-04-06 00:58:37',NULL,NULL,1),(198,1,'updated',95,'Story','2007-04-06 01:14:29',NULL,NULL,1),(199,1,'updated',97,'Story','2007-04-06 01:14:39',NULL,NULL,1),(200,2,'updated',24,'Story','2007-04-07 13:17:33',NULL,NULL,1),(201,2,'updated',24,'Story','2007-04-07 13:21:12',NULL,NULL,1),(202,1,'updated',61,'Story','2007-04-09 10:24:20',NULL,NULL,1),(203,1,'updated',95,'Story','2007-04-09 12:46:15',NULL,NULL,1),(204,1,'updated',95,'Story','2007-04-09 12:51:16',NULL,NULL,1),(205,1,'updated',61,'Story','2007-04-09 12:58:00',NULL,NULL,1),(206,1,'updated',24,'Story','2007-04-09 12:58:47',NULL,NULL,1),(207,1,'updated',65,'Story','2007-04-09 13:25:49',NULL,NULL,1),(208,1,'updated',33,'Story','2007-04-10 02:15:06',NULL,NULL,1);
UNLOCK TABLES;
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
CREATE TABLE `companies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `companies`
--


/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
LOCK TABLES `companies` WRITE;
INSERT INTO `companies` VALUES (1,'MHS'),(2,'Fusionary'),(3,'Atomic Object'),(4,'Red Prairie');
UNLOCK TABLES;
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `groups`
--


/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
LOCK TABLES `groups` WRITE;
INSERT INTO `groups` VALUES (6,'Developer'),(7,'Customer');
UNLOCK TABLES;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;

--
-- Table structure for table `groups_privileges`
--

DROP TABLE IF EXISTS `groups_privileges`;
CREATE TABLE `groups_privileges` (
  `id` int(11) NOT NULL auto_increment,
  `group_id` int(11) default NULL,
  `privilege_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `groups_privileges`
--


/*!40000 ALTER TABLE `groups_privileges` DISABLE KEYS */;
LOCK TABLES `groups_privileges` WRITE;
INSERT INTO `groups_privileges` VALUES (1,1,1),(2,4,10),(3,4,8),(4,5,10),(5,5,9),(6,6,13),(7,6,11),(8,7,13),(9,7,12);
UNLOCK TABLES;
/*!40000 ALTER TABLE `groups_privileges` ENABLE KEYS */;

--
-- Table structure for table `iterations`
--

DROP TABLE IF EXISTS `iterations`;
CREATE TABLE `iterations` (
  `id` int(11) NOT NULL auto_increment,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `project_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `budget` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `iterations`
--


/*!40000 ALTER TABLE `iterations` DISABLE KEYS */;
LOCK TABLES `iterations` WRITE;
INSERT INTO `iterations` VALUES (1,'2007-02-05','2007-02-11',1,'Iteration 1',0),(2,'2007-02-12','2007-02-18',1,'Iteration 2',0),(3,'2007-02-19','2007-02-25',1,'Iteration 3',0),(5,'2007-03-05','2007-03-11',1,'Iteration 4',0),(6,'2007-03-12','2007-03-18',1,'Iteration 5',0),(7,'2007-03-19','2007-03-25',1,'Iteration 6',0),(8,'2007-03-26','2007-04-01',1,'Iteration 7',0),(9,'2007-04-02','2007-04-08',1,'Iteration 8',0),(10,'2007-04-09','2007-04-15',1,'Iteration 9',0);
UNLOCK TABLES;
/*!40000 ALTER TABLE `iterations` ENABLE KEYS */;

--
-- Table structure for table `logged_exceptions`
--

DROP TABLE IF EXISTS `logged_exceptions`;
CREATE TABLE `logged_exceptions` (
  `id` int(11) NOT NULL auto_increment,
  `exception_class` varchar(255) default NULL,
  `controller_name` varchar(255) default NULL,
  `action_name` varchar(255) default NULL,
  `message` text,
  `backtrace` text,
  `environment` text,
  `request` text,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `logged_exceptions`
--


/*!40000 ALTER TABLE `logged_exceptions` DISABLE KEYS */;
LOCK TABLES `logged_exceptions` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `logged_exceptions` ENABLE KEYS */;

--
-- Table structure for table `priorities`
--

DROP TABLE IF EXISTS `priorities`;
CREATE TABLE `priorities` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `color` varchar(255) default NULL,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `priorities`
--


/*!40000 ALTER TABLE `priorities` DISABLE KEYS */;
LOCK TABLES `priorities` WRITE;
INSERT INTO `priorities` VALUES (7,'High','red',1),(8,'Medium','yellow',2),(9,'Low','green',3);
UNLOCK TABLES;
/*!40000 ALTER TABLE `priorities` ENABLE KEYS */;

--
-- Table structure for table `privileges`
--

DROP TABLE IF EXISTS `privileges`;
CREATE TABLE `privileges` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `privileges`
--


/*!40000 ALTER TABLE `privileges` DISABLE KEYS */;
LOCK TABLES `privileges` WRITE;
INSERT INTO `privileges` VALUES (11,'developer'),(12,'customer'),(13,'user');
UNLOCK TABLES;
/*!40000 ALTER TABLE `privileges` ENABLE KEYS */;

--
-- Table structure for table `project_permissions`
--

DROP TABLE IF EXISTS `project_permissions`;
CREATE TABLE `project_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) default NULL,
  `accessor_id` int(11) default NULL,
  `accessor_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `project_permissions`
--


/*!40000 ALTER TABLE `project_permissions` DISABLE KEYS */;
LOCK TABLES `project_permissions` WRITE;
INSERT INTO `project_permissions` VALUES (25,1,1,'User'),(26,1,2,'User'),(27,1,4,'User'),(28,1,5,'User'),(29,1,6,'User'),(30,1,7,'User'),(31,1,8,'User'),(32,1,10,'User'),(33,2,1,'User'),(34,2,2,'User'),(35,2,8,'User'),(36,2,10,'User'),(37,3,11,'User');
UNLOCK TABLES;
/*!40000 ALTER TABLE `project_permissions` ENABLE KEYS */;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `projects`
--


/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
LOCK TABLES `projects` WRITE;
INSERT INTO `projects` VALUES (1,'strac'),(2,'joecartoon'),(3,'AJAXify Transportation Management UI');
UNLOCK TABLES;
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;

--
-- Table structure for table `schema_info`
--

DROP TABLE IF EXISTS `schema_info`;
CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `schema_info`
--


/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
LOCK TABLES `schema_info` WRITE;
INSERT INTO `schema_info` VALUES (25),(25),(25),(25),(25);
UNLOCK TABLES;
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;

--
-- Table structure for table `statuses`
--

DROP TABLE IF EXISTS `statuses`;
CREATE TABLE `statuses` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `color` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `statuses`
--


/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
LOCK TABLES `statuses` WRITE;
INSERT INTO `statuses` VALUES (1,'defined','blue'),(2,'in progress','yellow'),(3,'complete','green'),(4,'rejected','black'),(5,'blocked','red');
UNLOCK TABLES;
/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;

--
-- Table structure for table `stories`
--

DROP TABLE IF EXISTS `stories`;
CREATE TABLE `stories` (
  `id` int(11) NOT NULL auto_increment,
  `summary` varchar(255) default NULL,
  `description` text,
  `points` int(11) default NULL,
  `position` int(11) default NULL,
  `iteration_id` int(11) default NULL,
  `project_id` int(11) default NULL,
  `responsible_party_id` int(11) default NULL,
  `responsible_party_type` varchar(255) default NULL,
  `status_id` int(11) default NULL,
  `priority_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `stories`
--


/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
LOCK TABLES `stories` WRITE;
INSERT INTO `stories` VALUES (5,'CRUD Stories','Users should be able CRUD Stories.\n\nh3. Attributes:\n\n* summary, string\n* description, text\n* points, integer\n* position, integer\n* complete, boolean',2,0,1,1,1,'User',3,NULL),(6,'drag/drop reordering of stories','Stories should be able to be reordered by a drag/drop interface',2,1,1,1,1,'User',3,NULL),(7,'inplace editing of story point values','Users should be able to update the point value of a story in place in the listing page.',2,0,2,1,1,'User',3,NULL),(8,'CRUD Iterations','Users should be able to create iterations.\nIterations have start date, end date, and a name. \n\nQuestion: Should iterations be allowed to overlap?',2,2,2,1,1,'User',3,NULL),(9,'Link Stories/Iterations','Stories should be able to be assi\ngned to iterations. This should be optional.',1,3,2,1,1,'User',3,NULL),(10,'Textarea input should allow formatting','Some type of formatting should be added to text areas. This could be either a WYSIWYG or some type of formatting language like textile.\n\nh3. Sample Textile\n\n* item1\n* item2\n* item3\n\nWe have chosen textile.',1,5,2,1,2,'User',3,NULL),(11,'Add/edit/view stories from listing page','User should be able to add/edit/view stories from the listing page, rather than\nhaving to go to a separate page.',4,0,5,1,1,'User',3,NULL),(15,'Allow marking stories complete from listing','As a user, I would like to be able to click a check box from the listing page to mark a story complete.',1,1,2,1,1,'User',3,NULL),(16,'CRUD Projects','h3. Attributes:\n\n* name',2,0,3,1,1,'User',3,NULL),(17,'Link Projects/Iterations','',2,1,3,1,1,'User',3,NULL),(18,'Link Projects/Stories','Stories currently can belong to iterations. Stories should also belong to a project so that stories which are not yet placed into an iteration can be diaplayed',3,2,3,1,1,'User',3,NULL),(19,'CRUD Users','',2,3,3,1,1,'User',3,NULL),(20,'CRUD Companies','',2,1,5,1,1,'User',3,NULL),(21,'Link Users/Companies','',1,2,5,1,1,'User',3,NULL),(22,'Setup authentication','use lwt authentication system',2,4,3,1,1,'User',3,NULL),(23,'Allow stories to be assigned a responsibly party','This can be a company or a user.',3,3,5,1,1,'User',3,NULL),(24,'Add comments to stories','As a user I should be able to add a comment to a story so I can provide useful comments or suggestions for the story.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in, navigated to an iteration, I should be able to view comments on a story by clicking on a comment icon in the story heading.\n\nGiven that I\'ve logged in, navigated to an iteration, and have clicked on the comment icon to view comments, I should be able to click on a add comment link to add a comment to the story.\n\n_I think we should keep this inline like the rest of the functionality in the site, rather than the popup --mark_',3,0,10,1,2,'User',2,NULL),(25,'CRUD files','Files should be able to be uploaded to a project. These should be versioned',3,6,NULL,1,NULL,NULL,1,NULL),(26,'Look into UJS','The story listing page is already looking cluttered with javascript. UJS should be seriously looked into. This would allow much cleaner html pages, as well as possible speed benefits from have lighterweight pages.',4,7,NULL,1,NULL,NULL,1,NULL),(27,'Allow stories to be tagged','Stroies should be able to be assigned tags. These should who up in the list page after the summary.',2,4,2,1,2,'User',3,NULL),(30,'Tag text fields should be auto completers','When typing in a tag text field, it should auto complete with tags that already exist in the system.',3,4,5,1,1,'User',3,NULL),(31,'Allow reordering of multiple items','It would be nice to be able to use ctl/shift to select multiple items to be dragged in a list\n\nsee \"example\":http://peter.michaux.ca/examples/yui-multiple-drag-with-proxy/yui-multiple-drag-with-proxy.html',8,4,NULL,1,NULL,NULL,1,NULL),(32,'Customer/Developer permissions','* 2 privileges should exist: developer, customer\n* customers should not be able to create/update/destroy projects\n* customers should not be able to create/update/destroy iterations\n* customers should not be able to edit story points ???',3,3,10,1,1,'User',1,NULL),(33,'Add time tracking','As a user, I want to add time entries to a story. When adding a time entry, a checkbox should exists which, when checked, would automatically complete the story.\n\nh4. Acceptance Tests\n\n* Given that I have logged in, selected a project, and navigated to a story, I want to be able to click the clock icon for that story and view the time entry screen. This screen should list all existing time entires for this story, and a form to enter new time entries.',8,5,10,1,1,'User',2,NULL),(34,'CRUD Channels','An administrator should be able to CRUD channels.\n\nh4. Attributes\n* name\n* button (swf)\n* position',2,1,4,2,NULL,NULL,3,NULL),(35,'Add static Categories','An administrator would like the static categories to include the following:\n\n* videos\n* cartoons',1,0,4,2,NULL,NULL,3,NULL),(50,'Update format of story listing','The story listing page should visually indicate whether a story is complete or incomplete.\n\nPoints should be displayed in a uniform location.\n\nImprove visual relationship between the story summary and the Show/Edit/Destroy links',3,2,1,1,1,'User',3,NULL),(51,'Display responsible party in story listing','As a developer I want to see the responsible party in the main story listing so I can quickly glance down the list and see how stories are assigned.',2,5,5,1,1,'User',3,NULL),(52,'Add status to stories','Stories should be able to have a status (defined, in progress, complete, rejected, blocked). This could replace the current \"complete\" attribute.',1,7,5,1,1,'User',3,NULL),(53,'CRUD Videos','An administrator should be able to crud videos.',4,2,4,2,NULL,NULL,3,NULL),(56,'When opening a story scroll the page','This should scroll smoothly with the blind down effect. If the scrolling would cause the top of the card to be hidden, restrict the scrolling so the top is always visible.',3,0,6,1,1,'User',3,NULL),(58,'Remove delete functionality.','',1,6,5,1,1,'User',3,NULL),(59,'Add priority categories','* High\n* Medium\n* Low',1,9,5,1,2,'User',3,NULL),(60,'Project Overview Activities List','A user should be able to see a project overview summary which lists today\'s and yesterday\'s happenings so that they can quickly identify what has recently occurred on the project.\n\nh4. Acceptance Tests:\n\n* A user should should log into the site and click \"Projects\" and be presented with a project overview which contains the latest happenings in a listed in descending order based on date/time. \n\n',1,2,6,1,1,'User',3,NULL),(61,'Project Activity Creation For Stories','A story should create a project activity record when a user takes the following actions so that the activities can be gathered and displayed on the the Project Overview page.\n\nh4. Activities\n\n* Story creation. Example: \"Mark has created a new story, \'story title\' \n* Story update. Example: \"Mark has updated the story, \'story title\'\n* Story status updates. Example(s):\n** Mark has taken the story, \'story title\'.\n** Mark has completed the story, \'story title\'.\n** Mark has rejected the story, \'story title\'.\n** Mark has blocked the story, \'story title\'.\n _(where \'story title\' is a link to the story in the above examples)_\n\n_All of these scenarios have been implemented and just need completed tests_',4,1,10,1,1,'User',2,NULL),(62,'Assign Story IDs','As a user I should be able to enter the Story ID into a story description and have it turn into a hyperlink of that story\'s summary when it is displayed so that I can easily navigate between stories.\n\nh4. Acceptance Tests\n\n* A user should be able to login, create or update a story and enter another story\'s id into it\'s description. Upon saving/updating the story and viewing it again they should see the story id turned into a hyperlink to the story it references.\n\n* A user should be able to login and create a story. Upon editing the story they should be able to see but not change the story id.\n\nh4. Notes\n\n* Stories should be indicated by typing the letter S followed by the id. ie: S23\n\n* Currently this takes the user to the default stories \"show\" page. \n',2,4,8,1,2,'User',3,3),(63,'Current Iteration View','As a user I should be able to see the current iteration, future iterations and the story backlog so that I can see my current workload, as well as future and unassigned workload on one page.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and navigated to the \"Current Iteration\" I should see the current iteration stories if there are no future iterations defined and there are no stories in the backlog.\n\n* Given that I\'ve logged in, chosen a project and navigated to the \"Current Iteration\" I should see the current iteration stories followed by the backlog, if there are no future iterations defined.\n\n* Given that I\'ve logged in, chosen a project and navigated to the \"Current Iteration\" I should see the current iteration stories followed by the future iteration stories, then followed the backlog if there are future iterationsdefined.',2,8,5,1,1,'User',3,NULL),(64,'Story Preview','As a user I should be able to preview the html version of a description before creating the story.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in, chosen a project and navigated to the create (or editing of a) story I should be able to click on a preview button which allows me to see a html preview of my story description. \n\nThis pertains with S64',2,1,9,1,2,'User',3,NULL),(65,'Expand/Collapse Story Descriptions','As a user I want to be able to expand or collapse story description for a given iteration.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing I should be able to click on a \"Expand Stories\" link which expands every stories descriptions. The \"Expand Stories\" link should turn into \"Collapse Stories\".\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing and I\'ve selected the \"Expand Stories\" link I should be able to click on the \"Collapse Stories\" link to collapse all of the current story descriptions.  The \"Collapse Stories\" link should turn into \"Expand Stories\" ',NULL,0,NULL,1,NULL,NULL,1,NULL),(66,'Add name to iteration','',1,1,6,1,1,'User',3,NULL),(67,'Add Create Links To Each Iteration','As a user I want to be able to create a story by clicking a \"create\" link which is shown for each iteration.\n\nh4. Acceptance Tests\n\n* Given that I have logged in, chosen a project and am viewing an iterations list I should be able to see a \"create\" link next to each iteration heading which allows me to create a new story.',2,3,6,1,NULL,NULL,3,NULL),(68,'Stories, Shown As Notecard Like Divs','As a user I would like to be able to see stories shown as notecards.\n\n* _this is an alternative view to the current view_\n* _for reference see http://transparency.collectiveidea.com_\n',NULL,5,NULL,1,NULL,NULL,1,NULL),(69,'Iteration Creation with Velocity','As a user I would like to see iteration velocity(ies) for the past iteration(s) so that I can make a better decision when choosing stories for the next iteration.\n\nh5. Iteration Velocities Computed\n\n* last weeks velocity (completed points)\n* the overall average velocity (completed points per iteration divided by number of iterations)\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in, chosen a project and am creating a new iteration I should see the iteration velocity(ies) on the page.  ',NULL,1,NULL,1,NULL,NULL,1,NULL),(70,'Add Priority Category Groups to Story Lists','As a user I want to be able to visually separate high, medium and low prioritized stories when I see a listing of stories so that I can easily tell what stories are what priority.\n\n_Acceptance tests need to be created, I don\'t know how I want to show the visual separation of prioritizations yet._',NULL,7,10,1,1,'User',1,NULL),(71,'Reorganize the Story  Fields','As a user I want to see the story summary above the story description when creating or updating a story so that I can see the steps in visual order to how they are typically created.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and am creating a story the Summary field should be focused, and it should be shown above the Description field. When I tab the focus should be moved to the description field, and then onto the other fields in visual order.\n\n* Given that I\'ve logged in, chosen a project and am updating a story the Summary field should be focused, and it should be shown above the Description field. When I tab the focus should be moved to the description field, and then onto the other fields in visual order.',1,11,9,1,1,'User',3,NULL),(72,'Add Take/Release To Stories','As a user I want to be able to \"take\" a story which assigns the story to me, and also \"release\" a story which assigns the story to \"anyone\" so that I can easily take responsibility and notify other developers of a story that I can working on.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing I should be able to \"Take\" a story by clicking on a \"Take\" link. The \"Take\" link should turn into a piece of text and a hyperlink. \"taken by Username\" and \"Release\".\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing I should be able to see the text  \"taken by User\" followed by the link \"Release\". I should be able to click on the link \"Release\" even if it was taken by another user to release the story. The link \"Take\" should be shown in it\'s place now.\n\n_The reason for allowing anyone to release/take a story is because it puts trust in the developers hands. If a developer leaves for the afternoon or is gone for a day and forgot to release a story that is not complete, it allows developers to not be hindered by that fact and they can release and re-take the story._\n\n This is complete pending the acceptance tests. Tests on the stories controller works for this.\n\n ',2,0,8,1,2,'User',3,3),(73,'Add basic navigation','This has been completed with the addition of the new layout.',3,9,9,1,1,'User',3,NULL),(74,'BUG: After editing stories, drag/drop breaks','After editing a story you can no longer use the dragbar to drag a story around.\n\n',1,3,9,1,1,'User',3,NULL),(75,'BUG: After creating story, form does not reset','This is fixed with revision 247. \n\nThe problem was that after editing a story and clicking update, the story would stay open in edit mode. Now it \"blinds\" up when you click Update.\n\nNotes:\n\n* This is not fixed. The problems that I reported this for was actually that when creating stories, and clicking \"create\" the create form should be reset to allow for quick creation of another story\n\n* Completed.',1,2,8,1,1,'User',3,NULL),(76,'Clean UI for create story form','',1,10,9,1,1,'User',3,NULL),(77,'Auto suggest creation of iterations','Iterations should not have a CRUD interface. Instead, when creating a project, the user should set the iterations length. Every time a user visits the \"current iteration\" page, if there is not iteration in the current date range, the user should be asked to create one. This should have an easy \"yes\" button which will create an iteration from the end of the last iteration, for the defined iteration length. There should be a \"yes, but...\" button which should allow the developer to quickly set the start date and iteration length/end date.\n\nRather than manually dragging stories into an iteration, they should be put into the current iteration when they are completed. The current iteration page will just show the backlogged stories.\n\n_should it also show the stories completed for this iteration_',6,6,10,1,1,'User',2,NULL),(78,'Close Story After \"Updating\" It','As a user I should see a story\'s editable form be closed after I click the Update button so that I can move onto the next story without an additional click.\n\nh4. Notes\n\n* This is in RJS. It is a visual thing so it isn\'t tested this point, but it is functioning from the user perspective.',1,1,8,1,2,'User',3,3),(79,'Add Create Story To Every Iteration Listing','As a user I should be able to create a story for any iteration that I am viewing so that I can create stories more easily with less clicks.',2,3,8,1,1,'User',3,NULL),(80,'Show Iteration Data in Iteration Header','There should be a few iteration statistics shown in the same line as the iteration date range line.\n\n* Planned Points\n* Completed Points\n* Points Remaining',NULL,2,NULL,1,NULL,NULL,1,1),(81,'Add Iteration Budget To Iteration','As a user I should be able to specify the number of points budgeted for this iteration so that the data can be captured to show statistics for the iteration.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in and am creating a new iteration I should be able to enter the number of points budgeted for the iteration.\n\nGiven that I\'ve logged in and am editing an iteration I should be able to edit/enter the number of points budgeted for the iteration.',NULL,4,9,1,2,'User',3,8),(82,'Show Iteration Statistics','As a user I should be able to see iteration statistics so I can easily tell how the iteration is progressing.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in an am viewing an iteration I should be able to see the number of points budgeted, the number of points allocated (story point cumulative) and the number of points remaining (budget-allocated).',NULL,3,NULL,1,NULL,NULL,1,NULL),(88,'BUG: Current Iteration for a project blows up','If you try to go to the \'current iteration\' page for a project and there are no iterations, or no iterations which are currently active it will blow up.\n\nThis is no longer an issue, it has been fixed in recent revisions to the current iteration page.',0,5,9,1,1,'User',3,NULL),(89,'Update Story List UI to separate stories better','With the new UI stories are hard to differentiate. A border, shadow, etc would be nice to separate the stories.\n\n\nNote:\n\n* i committed some minor css updates for this. If this looks good to you Mark please feel free to close',1,2,9,1,2,'User',3,NULL),(90,'BUG: cannot drag story to iteration with no stories','It an iteration has no stories you cannot drag stories from the backlog or any other iteration to it.',NULL,8,10,1,1,'User',1,NULL),(91,'Add easier way to change story status','As a user I want to be able to click on a graphical icon to change the status of a story so that I can change the status of a story without having to open the story in edit mode.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in and am viewing the current iteration list (or backlog) I should see a graphical icon representation of each possible story status. The selected status should be emphasized to show it\'s selected.\n\nGiven that I\'ve logged in and am viewing the current iteration list (or backlog) I should be able to click on an graphical icon on a collapsed story row to change it\'s status. ',3,8,9,1,1,'User',3,NULL),(92,'Make each activity a link','As a user when I should be able to click on a activity row to see story details.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in and selected a project I should be able to click on a project activity row to be taken to the \"show\" page for that story.',1,7,9,1,1,'User',3,NULL),(93,'Move the dragging handle to the start of the icons','',1,6,9,1,1,'User',3,NULL),(94,'Include all gems in vendor/gems','To make it easier to deploy strac, unpack all necesary gems into the vendor directory. A technique to add these to the load path is described here: \n<a href=\"http://errtheblog.com/post/2120\">errtheblog</a>\n\nZach said something about possibly using piston to manage this as well.\n\nI tried running strac on a server, and had to work through figuring out that mocha and redcloth are both required plugins. Would be great if the app just included those right out of the box.',1,8,NULL,1,NULL,NULL,1,9),(95,'Project permissions','* When creating a project, the user who created it should be the only one given permission.\n* Any user with access to a project should be able to edit which users are allowed to access that project.\n* Any user with access to a project should be able to edit which companies are allowed to access that project.\n* Any user who belongs to a company with access to a project will be allowed to access that project\n\n_All of these scenarios have been implemented and just need completed tests_',3,2,10,1,1,'User',2,NULL),(96,'Move points on mini story to right of description','When a user sees a story row they see the \"Points: n\" first. If the points is moved (probably to the right of the description) it will allow the user to quickly scan each story row and see the most useful information first.',NULL,9,NULL,1,NULL,NULL,NULL,NULL),(97,'Update responsible party dropdown','The responsible party dropdown should not include customers, only developers. Also, it should not include people who do not have access to the proejct.',2,4,10,1,1,'User',1,NULL),(98,'Clicking on a story should open the story in view only mode','As a user I should be able to click on a story header to open it in view only mode so I can view the story description with minimal mouse clicks or mouse movement.\n\nh4. Acceptance Tests\n\n* Given that I am viewing an iteration and I click on a story row (mini story) the story should expand to view-only mode.',NULL,10,NULL,1,NULL,NULL,NULL,NULL),(99,'Clicking on a story in view only mode should open edit mode','As a user I should be able to click on a story in view only mode to have it change to edit mode so I can quickly edit a story with minimal amount of clicks and mouse movement.\n\nh4. Acceptance Tests\n\n* Given that  am viewing a story in an iteration in view only mode I should be able to click on the story (within the view-only mode div) and have the story close the view-only mode and open the edit mode.',NULL,11,NULL,1,NULL,NULL,NULL,NULL),(100,'Add Cancel button to edit story','As a user I should see a cancel button on the edit story form so I can quickly cancel out of the story.\n\nNote: A cancel button is common for most forms and it has a bigger hit area then closing the story by clicking on one of the icons for the story, which would blind up the edit form. This will make the form more intuitive and accessible for a broader range of users.',1,0,9,1,1,'User',3,NULL),(101,'Add Arrows To Add Stories To Current Iteration','As a user I should be able to click on a graphical icon which moves the story to the current iteration so I can quickly move stories to the current iteration.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in and am viewing an iteration list when I hover over a story row I should see a graphical icon show up on the left of the story, which when I click it, the story moves to the current iteration.\n\n* Given that I\'ve logged in and am viewing an iteration list when I hover over a story row I should see a graphical icon show up on the left of the story,  and when I move the mouse to no longer hover over that story the graphical icon should disappear.\n\nh4. Notes\n\n* the graphic could be a large arrow. \n* the graphic appearing/disappearing is similar to how basecamp shows/hides it\'s edit/delete links on todo lists',NULL,12,NULL,1,NULL,NULL,NULL,NULL),(102,'Add Arrows to Add Stories to Backlog','As a user when I am viewing the current iteration I should be able to click on a graphical icon which moves the story to the backlog so I can quickly move stories from the current iteration to the backlog.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in and am viewing the current iteration list when I hover over a story row I should see a graphical icon show up on the left of the story, which when I click it, the story moves to the backlog.\n\n* Given that I\'ve logged in and am viewing the iteration list when I hover over a story row I should see a graphical icon show up on the left of the story,  and when I move the mouse to no longer hover over that story the graphical icon should disappear.\n\nh4. Notes\n\n* the graphic could be a large down arrow. \n* the graphic appearing/disappearing is similar to how basecamp shows/hides it\'s edit/delete links on todo lists',NULL,13,NULL,1,NULL,NULL,NULL,NULL);
UNLOCK TABLES;
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `taggings`
--


/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
LOCK TABLES `taggings` WRITE;
INSERT INTO `taggings` VALUES (1,1,26,'Story'),(2,2,27,'Story'),(4,4,5,'Story'),(6,6,6,'Story'),(8,2,30,'Story'),(11,7,7,'Story'),(12,9,33,'Story'),(13,11,34,'Story'),(14,12,35,'Story'),(16,14,51,'Story'),(17,14,23,'Story'),(18,5,50,'Story'),(19,15,8,'Story'),(20,15,9,'Story'),(21,5,10,'Story'),(23,5,5,'Story'),(24,15,77,'Story');
UNLOCK TABLES;
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tags`
--


/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
LOCK TABLES `tags` WRITE;
INSERT INTO `tags` VALUES (1,'javascript'),(2,'tags'),(3,'crud stories'),(4,'crud'),(5,'stories'),(6,'priority'),(7,'points'),(8,'ppp'),(9,'time tracking'),(10,'planning'),(11,'channels'),(12,'categories'),(13,'hey'),(14,'responsible party'),(15,'iterations'),(16,'storie');
UNLOCK TABLES;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;

--
-- Table structure for table `time_entries`
--

DROP TABLE IF EXISTS `time_entries`;
CREATE TABLE `time_entries` (
  `id` int(11) NOT NULL auto_increment,
  `hours` decimal(10,2) default NULL,
  `comment` varchar(255) default NULL,
  `date` date default NULL,
  `project_id` int(11) default NULL,
  `timeable_id` int(11) default NULL,
  `timeable_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `time_entries`
--


/*!40000 ALTER TABLE `time_entries` DISABLE KEYS */;
LOCK TABLES `time_entries` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `time_entries` ENABLE KEYS */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(255) default NULL,
  `password_hash` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `email_address` varchar(255) default NULL,
  `group_id` int(11) default NULL,
  `company_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--


/*!40000 ALTER TABLE `users` DISABLE KEYS */;
LOCK TABLES `users` WRITE;
INSERT INTO `users` VALUES (1,'mvanholstyn','3426c19b17768f5e5c3d5a4c53952395','Mark','Van Holstyn','mvanholstyn@mutuallyhuman.com',6,1),(2,'zdennis','5f4dcc3b5aa765d61d8327deb882cf99','Zach','Dennis','zdennis@mutuallyhuman.com',6,3),(4,'karlin','e99a18c428cb38d5f260853678922e03','Karlin','Fox','fox@atomicobject.com',6,3),(5,'justin','211c42bb02f7a9e63d30e9a12222577c','Justin','Dewind','dewind@atomicobject.com',6,3),(6,'patrick','8e3a8d3e644e608d25ec40162988a137','Patrick','Bacon','bacon@atomicobject.com',6,3),(7,'dave','104e08045184a4f111170f990e274e3a','Dave','Crosby','crosby@atomicobject.com',6,3),(8,'jhwang','4a9ff7131c612a17cd210c88755a07aa','John','Hwang','jhwang@mutuallyhuman.com',6,1),(10,'jbaty','7799d5720631b30c17c07b6c174dd78c','Jack','Baty','jbaty@fusionary.com',6,2),(11,'jgephart','f94adcc3ddda04a8f34928d862f404b4','Josh','Gephart','jdgephart@gmail.com',6,4);
UNLOCK TABLES;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

