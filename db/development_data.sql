-- MySQL dump 10.10
--
-- Host: localhost    Database: strac_development
-- ------------------------------------------------------
-- Server version	5.0.24a-Debian_9-log

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
-- Dumping data for table `schema_info`
--


/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
LOCK TABLES `schema_info` WRITE;
INSERT INTO `schema_info` VALUES (1);
UNLOCK TABLES;
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;

--
-- Dumping data for table `stories`
--


/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
LOCK TABLES `stories` WRITE;
INSERT INTO `stories` VALUES (5,'CRUD Stories','Users should be able CRUD Stories.\r\n\r\nAttributes:\r\n * summary, string\r\n * description, text\r\n * points, integer\r\n * posi\ntion, integer\r\n * complete, boolean',1,0,1),(6,'drag/drop reordering of stories','Stories should be able to be reordered by a drag/drop interface',2,1,1),(7,'inplace editing of story point values','Users should be able to update the point value of a story in place in the listing page.',2,3,1),(8,'CRUD Iterations','Users should be able to create iterations.\nIterations have start date, end date, and a name. \r\n\r\nQuestion: Should iterations be allowed to overlap?',2,8,0),(9,'Link Stories/Iterations','Stories should be able to be assi\ngned to iterations. This should be optional.',1,9,0),(10,'Textarea input should allow formatting','Some type of formatting should be added to text areas. This could be either a WYS\r\nIWYG or some type of formatting language like textile.',2,7,0),(11,'Add/edit/view stories from listing page','User should be able to add stories from the listing page, rather than\nhaving to go to a separate page.',4,6,0),(12,'Add filtering to story listing','The story listing should be able to be filtered by iteration (any, none, specific)',1,20,0),(13,'Add sorting/grouping on story listing','The story listing should be storted/grouped by iteration. \r\n\r\nThis will also involve updating the the drag/drop reordering interface to allow\n drag/drop between iterations. \r\n * update the positions AND iteration_id of the stories.\r\n * Stories should be updated to be positioned within their iteration',2,21,0),(14,'Update format of story listing','The story listing page should visually indicate whether a story is complete or incomplete.\r\n\r\nPoints should be displayed in a uniform location.\r\nn\r\nImprove visual relationship between the story summary and the Show/Edit/Destroy links',3,2,1),(15,'Allow marking stories complete from listing','As a user, I would like to be able to click a check box from the listing page to mark a story complete.',1,4,1),(16,'CRUD Projects','',2,10,0),(17,'Link Projects/Iterations','',2,11,0),(18,'Link Projects/Stories','Stories currently can belong to iterations. Stories should also belong to a project so that stories which are not yet placed into an iteration can be diaplayed',3,12,0),(19,'CRUD Users','',2,13,0),(20,'CRUD Companies','',2,15,0),(21,'Link Users/Companies','',1,16,0),(22,'Setup authentication','use lwt authentication system',2,14,0),(23,'Allow stories to be assigned a responsibly party','This can be a company or a user',3,17,0),(24,'Add comments to stories','Stories should be able to have comments',3,18,0),(25,'CRUD files','Files should be able to be uploaded to a project. These should be versioned',3,19,0),(26,'Look into UJS','The story listing page is already looking cluttered with javascript. UJS should be seriously looked into. This would allow much cleaner html pages, as well as possible speed benefits from have lighterweight pages.',4,5,0);
UNLOCK TABLES;
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

