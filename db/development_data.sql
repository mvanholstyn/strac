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
-- Dumping data for table `iterations`
--


/*!40000 ALTER TABLE `iterations` DISABLE KEYS */;
LOCK TABLES `iterations` WRITE;
INSERT INTO `iterations` VALUES (1,'2007-02-05','2007-02-09'),(2,'2007-02-12','2007-02-16'),(3,'2007-02-19','2007-02-23');
UNLOCK TABLES;
/*!40000 ALTER TABLE `iterations` ENABLE KEYS */;

--
-- Dumping data for table `schema_info`
--


/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
LOCK TABLES `schema_info` WRITE;
INSERT INTO `schema_info` VALUES (4);
UNLOCK TABLES;
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;

--
-- Dumping data for table `stories`
--


/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
LOCK TABLES `stories` WRITE;
INSERT INTO `stories` VALUES (5,'CRUD Stories','Users should be able CRUD Stories.\r\n\r\nAttributes:\r\n * summary, string\r\n * description, text\r\n * points, integer\r\n * posi\r\ntion, integer\r\n * complete, boolean',1,0,1,1),(6,'drag/drop reordering of stories','Stories should be able to be reordered by a drag/drop interface',2,1,1,1),(7,'inplace editing of story point values','Users should be able to update the point value of a story in place in the listing page.',2,0,1,2),(8,'CRUD Iterations','Users should be able to create iterations.\r\nIterations have start date, end date, and a name. \r\n\r\nQuestion: Should iterations be allowed to overlap?',2,3,1,2),(9,'Link Stories/Iterations','Stories should be able to be assi\ngned to iterations. This should be optional.',1,4,1,2),(10,'Textarea input should allow formatting','Some type of formatting should be added to text areas. This could be either a WYS\r\nIWYG or some type of formatting language like textile.',2,3,0,NULL),(11,'Add/edit/view stories from listing page','User should be able to add stories from the listing page, rather than\nhaving to go to a separate page.',4,1,0,3),(12,'Add filtering to story listing','The story listing should be able to be filtered by iteration (any, none, specific)',2,6,0,NULL),(13,'Add sorting/grouping on story listing','The story listing should be storted/grouped by iteration. \r\n\r\nThis will also involve updating the the drag/drop reordering interface to allow\n drag/drop between iterations. \r\n * update the positions AND iteration_id of the stories.\r\n * Stories should be updated to be positioned within their iteration',2,7,0,NULL),(14,'Update format of story listing','The story listing page should visually indicate whether a story is complete or incomplete.\r\n\r\nPoints should be displayed in a uniform location.\r\nn\r\nImprove visual relationship between the story summary and the Show/Edit/Destroy links',3,2,1,1),(15,'Allow marking stories complete from listing','As a user, I would like to be able to click a check box from the listing page to mark a story complete.',1,1,1,2),(16,'CRUD Projects','',2,2,0,3),(17,'Link Projects/Iterations','',2,4,0,3),(18,'Link Projects/Stories','Stories currently can belong to iterations. Stories should also belong to a project so that stories which are not yet placed into an iteration can be diaplayed',3,3,0,3),(19,'CRUD Users','',2,5,0,3),(20,'CRUD Companies','',2,7,0,3),(21,'Link Users/Companies','',1,8,0,3),(22,'Setup authentication','use lwt authentication system',2,6,0,3),(23,'Allow stories to be assigned a responsibly party','This can be a company or a user',3,9,0,3),(24,'Add comments to stories','Stories should be able to have comments',3,1,0,NULL),(25,'CRUD files','Files should be able to be uploaded to a project. These should be versioned',3,2,0,NULL),(26,'Look into UJS','The story listing page is already looking cluttered with javascript. UJS should be seriously looked into. This would allow much cleaner html pages, as well as possible speed benefits from have lighterweight pages.',4,8,0,NULL),(27,'Allow stories to be tagged','Stroies should be able to be assigned tags. These should who up in the list page after the summary.',2,2,1,2),(28,'Allow inline editing of tags','tags should be editable in the list view',2,4,0,NULL),(29,'Allow inline editing of story summary','Stories summaries should be editable from the list view',2,0,0,3),(30,'Tag text fields should be auto completers','When typing in a tag text field, it should auto complete with tags that already exist in the system',3,5,0,NULL),(31,'Allow reordering of multiple items','It would be nice to be able to use ctl/shift to select multiple items to be dragged in a list',8,9,NULL,NULL),(32,'Setup customer/developer permissions','Permissions should be setup in the following manner:\r\n\r\n * Users of the system should be given access on a per project basis.\r\n * Companies can be given access to a project (all users then have access)\r\n * 2 privileges should exist: developer, customer\r\n * customers should not be able to change points or create projects',6,0,NULL,NULL);
UNLOCK TABLES;
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;

--
-- Dumping data for table `taggings`
--


/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
LOCK TABLES `taggings` WRITE;
INSERT INTO `taggings` VALUES (1,1,26,'Story'),(2,2,27,'Story'),(4,4,5,'Story'),(5,5,5,'Story'),(6,6,6,'Story'),(7,2,28,'Story'),(8,2,30,'Story');
UNLOCK TABLES;
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;

--
-- Dumping data for table `tags`
--


/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
LOCK TABLES `tags` WRITE;
INSERT INTO `tags` VALUES (1,'javascript'),(2,'tags'),(3,'crud stories'),(4,'crud'),(5,'stories'),(6,'priority');
UNLOCK TABLES;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

