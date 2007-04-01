-- MySQL dump 10.10
--
-- Host: localhost    Database: strac_development
-- ------------------------------------------------------
-- Server version	5.0.24a-Debian_9ubuntu0.1-log

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
  `affected_id` int(11) default NULL,
  `affected_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `activities`
--


/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
LOCK TABLES `activities` WRITE;
INSERT INTO `activities` VALUES (18,1,'updated',61,'Story','2007-03-26 14:29:22'),(19,1,'updated',61,'Story','2007-03-26 14:29:26'),(20,1,'updated',61,'Story','2007-03-28 00:41:15'),(21,1,'updated',71,'Story','2007-03-28 00:42:39'),(22,1,'updated',70,'Story','2007-03-28 00:42:44'),(23,1,'updated',65,'Story','2007-03-28 00:42:46'),(24,1,'updated',64,'Story','2007-03-28 00:43:17'),(25,1,'updated',64,'Story','2007-03-28 00:43:19'),(26,1,'updated',64,'Story','2007-03-28 00:43:22'),(27,1,'updated',64,'Story','2007-03-28 00:43:36'),(28,1,'updated',71,'Story','2007-03-28 00:43:45'),(29,1,'updated',71,'Story','2007-03-28 00:43:48'),(30,1,'updated',64,'Story','2007-03-28 00:43:49'),(31,1,'updated',71,'Story','2007-03-28 00:43:55'),(32,1,'updated',24,'Story','2007-03-28 00:44:23'),(33,1,'create',73,'Story','2007-03-28 00:48:40'),(34,1,'create',74,'Story','2007-03-28 00:49:17'),(35,1,'create',75,'Story','2007-03-28 00:49:33'),(36,1,'create',76,'Story','2007-03-28 00:50:38'),(37,1,'updated',25,'Story','2007-03-28 09:42:54'),(38,1,'updated',25,'Story','2007-03-28 09:42:56'),(39,1,'updated',72,'Story','2007-03-28 17:47:39'),(40,1,'updated',62,'Story','2007-03-28 17:47:40'),(41,1,'updated',62,'Story','2007-03-28 17:47:43'),(42,1,'updated',72,'Story','2007-03-28 17:47:45'),(43,1,'updated',25,'Story','2007-03-28 17:48:02'),(44,1,'updated',25,'Story','2007-03-28 17:48:04'),(45,1,'updated',56,'Story','2007-03-28 17:50:25'),(46,1,'updated',33,'Story','2007-03-28 18:22:52'),(47,1,'updated',33,'Story','2007-03-28 18:22:55'),(48,1,'updated',33,'Story','2007-03-28 20:17:05'),(49,1,'updated',61,'Story','2007-03-28 20:17:10'),(50,1,'updated',64,'Story','2007-03-28 20:17:11'),(51,1,'updated',71,'Story','2007-03-28 20:17:12'),(52,1,'updated',32,'Story','2007-03-28 20:17:14'),(53,1,'updated',32,'Story','2007-03-28 20:17:23'),(54,1,'updated',71,'Story','2007-03-28 20:17:23'),(55,1,'updated',64,'Story','2007-03-28 20:17:24'),(56,1,'updated',61,'Story','2007-03-28 20:17:25'),(57,1,'updated',33,'Story','2007-03-28 20:17:25'),(58,1,'created',77,'Story','2007-03-28 20:30:22'),(59,2,'updated',72,'Story','2007-03-28 22:40:46'),(60,2,'updated',72,'Story','2007-03-28 22:42:28'),(61,2,'created',78,'Story','2007-03-28 22:49:21'),(62,2,'created',79,'Story','2007-03-28 22:50:32'),(63,4,'created',80,'Story','2007-03-29 09:41:27'),(64,2,'updated',72,'Story','2007-03-29 19:53:28'),(65,2,'updated',62,'Story','2007-03-29 20:38:00'),(66,2,'updated',62,'Story','2007-03-29 20:38:04'),(67,2,'created',81,'Story','2007-03-30 22:16:39'),(68,2,'updated',81,'Story','2007-03-30 22:17:44'),(69,2,'created',82,'Story','2007-03-30 22:19:29'),(70,2,'updated',62,'Story','2007-03-30 22:21:07'),(71,2,'updated',62,'Story','2007-03-30 22:33:35'),(72,2,'updated',78,'Story','2007-03-30 22:38:38'),(73,2,'updated',78,'Story','2007-03-30 22:39:04'),(74,2,'updated',78,'Story','2007-03-30 22:39:11'),(75,2,'updated',78,'Story','2007-03-30 22:47:38'),(76,2,'created',83,'Story','2007-03-30 22:50:41'),(77,2,'created',84,'Story','2007-03-30 22:51:22'),(78,2,'updated',84,'Story','2007-03-30 22:51:45'),(79,2,'updated',83,'Story','2007-03-30 22:51:51'),(80,2,'updated',82,'Story','2007-03-30 22:51:59'),(81,2,'updated',81,'Story','2007-03-30 22:52:06'),(82,2,'updated',75,'Story','2007-03-30 22:54:49'),(83,2,'updated',74,'Story','2007-03-30 22:56:38'),(84,2,'updated',74,'Story','2007-03-30 23:16:35'),(85,2,'updated',81,'Story','2007-03-30 23:19:29'),(86,1,'updated',62,'Story','2007-03-31 00:05:09'),(87,1,'updated',75,'Story','2007-03-31 00:07:08'),(94,1,'updated',75,'Story','2007-03-31 00:23:21'),(95,1,'updated',79,'Story','2007-03-31 00:24:06'),(96,2,'updated',75,'Story','2007-03-31 13:45:58'),(97,2,'created',88,'Story','2007-03-31 14:01:57'),(98,2,'updated',88,'Story','2007-03-31 14:02:16'),(99,2,'updated',62,'Story','2007-03-31 14:16:13');
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
INSERT INTO `companies` VALUES (1,'MHS'),(2,'Fusionary'),(3,'Atomic Object');
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
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `iterations`
--


/*!40000 ALTER TABLE `iterations` DISABLE KEYS */;
LOCK TABLES `iterations` WRITE;
INSERT INTO `iterations` VALUES (1,'2007-02-05','2007-02-11',1,NULL),(2,'2007-02-12','2007-02-18',1,NULL),(3,'2007-02-19','2007-02-25',1,NULL),(4,'2007-02-26','2007-03-02',2,NULL),(5,'2007-03-05','2007-03-11',1,NULL),(6,'2007-03-12','2007-03-18',1,'Iteration 5'),(7,'2007-03-19','2007-03-25',1,''),(8,'2007-03-26','2007-04-01',1,'');
UNLOCK TABLES;
/*!40000 ALTER TABLE `iterations` ENABLE KEYS */;

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
INSERT INTO `projects` VALUES (1,'strac');
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
INSERT INTO `schema_info` VALUES (20),(20),(20),(20),(20);
UNLOCK TABLES;
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;

--
-- Table structure for table `statuses`
--

DROP TABLE IF EXISTS `statuses`;
CREATE TABLE `statuses` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `statuses`
--


/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
LOCK TABLES `statuses` WRITE;
INSERT INTO `statuses` VALUES (1,'defined'),(2,'in progress'),(3,'complete'),(4,'rejected'),(5,'blocked');
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
INSERT INTO `stories` VALUES (5,'CRUD Stories','Users should be able CRUD Stories.\n\nh3. Attributes:\n\n* summary, string\n* description, text\n* points, integer\n* position, integer\n* complete, boolean',2,0,1,1,1,'User',3,NULL),(6,'drag/drop reordering of stories','Stories should be able to be reordered by a drag/drop interface',2,1,1,1,1,'User',3,NULL),(7,'inplace editing of story point values','Users should be able to update the point value of a story in place in the listing page.',2,0,2,1,1,'User',3,NULL),(8,'CRUD Iterations','Users should be able to create iterations.\nIterations have start date, end date, and a name. \n\nQuestion: Should iterations be allowed to overlap?',2,2,2,1,1,'User',3,NULL),(9,'Link Stories/Iterations','Stories should be able to be assi\ngned to iterations. This should be optional.',1,3,2,1,1,'User',3,NULL),(10,'Textarea input should allow formatting','Some type of formatting should be added to text areas. This could be either a WYSIWYG or some type of formatting language like textile.\n\nh3. Sample Textile\n\n* item1\n* item2\n* item3\n\nWe have chosen textile.',1,5,2,1,2,'User',3,NULL),(11,'Add/edit/view stories from listing page','User should be able to add/edit/view stories from the listing page, rather than\nhaving to go to a separate page.',4,0,5,1,1,'User',3,NULL),(15,'Allow marking stories complete from listing','As a user, I would like to be able to click a check box from the listing page to mark a story complete.',1,1,2,1,1,'User',3,NULL),(16,'CRUD Projects','h3. Attributes:\n\n* name',2,0,3,1,1,'User',3,NULL),(17,'Link Projects/Iterations','',2,1,3,1,1,'User',3,NULL),(18,'Link Projects/Stories','Stories currently can belong to iterations. Stories should also belong to a project so that stories which are not yet placed into an iteration can be diaplayed',3,2,3,1,1,'User',3,NULL),(19,'CRUD Users','',2,3,3,1,1,'User',3,NULL),(20,'CRUD Companies','',2,1,5,1,1,'User',3,NULL),(21,'Link Users/Companies','',1,2,5,1,1,'User',3,NULL),(22,'Setup authentication','use lwt authentication system',2,4,3,1,1,'User',3,NULL),(23,'Allow stories to be assigned a responsibly party','This can be a company or a user.',3,3,5,1,1,'User',3,NULL),(24,'Add comments to stories','Stories should be able to have comments',3,1,NULL,1,1,'User',NULL,NULL),(25,'CRUD files','Files should be able to be uploaded to a project. These should be versioned',3,2,NULL,1,NULL,NULL,NULL,NULL),(26,'Look into UJS','The story listing page is already looking cluttered with javascript. UJS should be seriously looked into. This would allow much cleaner html pages, as well as possible speed benefits from have lighterweight pages.',4,3,NULL,1,NULL,NULL,NULL,NULL),(27,'Allow stories to be tagged','Stroies should be able to be assigned tags. These should who up in the list page after the summary.',2,4,2,1,2,'User',3,NULL),(30,'Tag text fields should be auto completers','When typing in a tag text field, it should auto complete with tags that already exist in the system.',3,4,5,1,1,'User',3,NULL),(31,'Allow reordering of multiple items','It would be nice to be able to use ctl/shift to select multiple items to be dragged in a list',8,4,NULL,1,NULL,NULL,NULL,NULL),(32,'Setup customer/developer permissions','Permissions should be setup in the following manner:\n\n * Users of the system should be given access on a per project basis.\n * Companies can be given access to a project (all users then have access)\n * 2 privileges should exist: developer, customer\n * customers should not be able to change points or create projects',6,5,NULL,1,1,'User',NULL,NULL),(33,'Add time tracking','As a user, I want to add time entries to a story.\n\nh4. Acceptance Tests\n\n* Given that I have logged in, selected a project, and navigated to a story, I want to be able to click the clock icon for that story and view the time entry screen. This screen should list all existing time entires for this story, and a form to enter new time entries.',8,6,NULL,1,1,'User',2,NULL),(34,'CRUD Channels','An administrator should be able to CRUD channels.\n\nh4. Attributes\n* name\n* button (swf)\n* position',2,1,4,2,NULL,NULL,3,NULL),(35,'Add static Categories','An administrator would like the static categories to include the following:\n\n* videos\n* cartoons',1,0,4,2,NULL,NULL,3,NULL),(50,'Update format of story listing','The story listing page should visually indicate whether a story is complete or incomplete.\n\nPoints should be displayed in a uniform location.\n\nImprove visual relationship between the story summary and the Show/Edit/Destroy links',3,2,1,1,1,'User',3,NULL),(51,'Display responsible party in story listing','As a developer I want to see the responsible party in the main story listing so I can quickly glance down the list and see how stories are assigned.',2,5,5,1,1,'User',3,NULL),(52,'Add status to stories','Stories should be able to have a status (defined, in progress, complete, rejected, blocked). This could replace the current \"complete\" attribute.',1,7,5,1,1,'User',3,NULL),(53,'CRUD Videos','An administrator should be able to crud videos.',4,2,4,2,NULL,NULL,3,NULL),(56,'When opening a story scroll the page','This should scroll smoothly with the blind down effect. If the scrolling would cause the top of the card to be hidden, restrict the scrolling so the top is always visible.',3,0,6,1,1,'User',3,NULL),(58,'Remove delete functionality.','',1,6,5,1,1,'User',3,NULL),(59,'Add priority categories','* High\n* Medium\n* Low',1,9,5,1,2,'User',3,NULL),(60,'Project Overview Activities List','A user should be able to see a project overview summary which lists today\'s and yesterday\'s happenings so that they can quickly identify what has recently occurred on the project.\n\nh4. Acceptance Tests:\n\n* A user should should log into the site and click \"Projects\" and be presented with a project overview which contains the latest happenings in a listed in descending order based on date/time. \n\n',1,2,6,1,1,'User',3,NULL),(61,'Project Activity Creation For Stories','A story should create a project activity record when a user takes the following actions so that the activities can be gathered and displayed on the the Project Overview page.\n\nh4. Activities\n\n* Story creation. Example: \"Mark has created a new story, \'story title\' \n* Story update. Example: \"Mark has updated the story, \'story title\'\n* Story status updates. Example(s):\n** Mark has taken the story, \'story title\'.\n** Mark has completed the story, \'story title\'.\n** Mark has rejected the story, \'story title\'.\n** Mark has blocked the story, \'story title\'.\n _(where \'story title\' is a link to the story in the above examples)_\n\nh4. Acceptance Tests\n\n* AT\'s handled by _Project Overview Activities List_\n',4,7,NULL,1,1,'User',2,NULL),(62,'Assign Story IDs','As a user I should be able to enter the Story ID into a story description and have it turn into a hyperlink of that story\'s summary when it is displayed so that I can easily navigate between stories.\n\nh4. Acceptance Tests\n\n* A user should be able to login, create or update a story and enter another story\'s id into it\'s description. Upon saving/updating the story and viewing it again they should see the story id turned into a hyperlink to the story it references.\n\n* A user should be able to login and create a story. Upon editing the story they should be able to see but not change the story id.\n\nh4. Notes\n\n* Stories should be indicated by typing the letter S followed by the id. ie: S23\n\n* Currently this takes the user to the default stories \"show\" page. \n',2,4,8,1,2,'User',3,3),(63,'Current Iteration View','As a user I should be able to see the current iteration, future iterations and the story backlog so that I can see my current workload, as well as future and unassigned workload on one page.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and navigated to the \"Current Iteration\" I should see the current iteration stories if there are no future iterations defined and there are no stories in the backlog.\n\n* Given that I\'ve logged in, chosen a project and navigated to the \"Current Iteration\" I should see the current iteration stories followed by the backlog, if there are no future iterations defined.\n\n* Given that I\'ve logged in, chosen a project and navigated to the \"Current Iteration\" I should see the current iteration stories followed by the future iteration stories, then followed the backlog if there are future iterationsdefined.',2,8,5,1,1,'User',3,NULL),(64,'Story Preview','As a user I should be able to preview the html version of a description before creating the story.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in, chosen a project and navigated to the create (or editing of a) story I should be able to click on a preview button which allows me to see a html preview of my story description. ',2,8,NULL,1,1,'User',2,NULL),(65,'Expand/Collapse Story Descriptions','As a user I want to be able to expand or collapse story description for a given iteration.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing I should be able to click on a \"Expand Stories\" link which expands every stories descriptions. The \"Expand Stories\" link should turn into \"Collapse Stories\".\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing and I\'ve selected the \"Expand Stories\" link I should be able to click on the \"Collapse Stories\" link to collapse all of the current story descriptions.  The \"Collapse Stories\" link should turn into \"Expand Stories\" ',NULL,9,NULL,1,1,'User',NULL,NULL),(66,'Add name to iteration','',1,1,6,1,1,'User',3,NULL),(67,'Add Create Links To Each Iteration','As a user I want to be able to create a story by clicking a \"create\" link which is shown for each iteration.\n\nh4. Acceptance Tests\n\n* Given that I have logged in, chosen a project and am viewing an iterations list I should be able to see a \"create\" link next to each iteration heading which allows me to create a new story.',2,3,6,1,NULL,NULL,3,NULL),(68,'Stories, Shown As Notecard Like Divs','As a user I would like to be able to see stories shown as notecards.\n\n* _this is an alternative view to the current view_\n* _for reference see http://transparency.collectiveidea.com_\n',NULL,10,NULL,1,NULL,NULL,NULL,NULL),(69,'Iteration Creation with Velocity','As a user I would like to see iteration velocity(ies) for the past iteration(s) so that I can make a better decision when choosing stories for the next iteration.\n\nh5. Iteration Velocities Computed\n\n* last weeks velocity (completed points)\n* the overall average velocity (completed points per iteration divided by number of iterations)\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in, chosen a project and am creating a new iteration I should see the iteration velocity(ies) on the page.  ',NULL,11,NULL,1,NULL,NULL,NULL,NULL),(70,'Add Priority Category Groups to Story Lists','As a user I want to be able to visually separate high, medium and low prioritized stories when I see a listing of stories so that I can easily tell what stories are what priority.\n\n_Acceptance tests need to be created, I don\'t know how I want to show the visual separation of prioritizations yet._',NULL,12,NULL,1,1,'User',NULL,NULL),(71,'Reorganize the Story  Fields','As a user I want to see the story summary above the story description when creating or updating a story so that I can see the steps in visual order to how they are typically created.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and am creating a story the Summary field should be focused, and it should be shown above the Description field. When I tab the focus should be moved to the description field, and then onto the other fields in visual order.\n\n* Given that I\'ve logged in, chosen a project and am updating a story the Summary field should be focused, and it should be shown above the Description field. When I tab the focus should be moved to the description field, and then onto the other fields in visual order.',1,13,NULL,1,1,'User',2,NULL),(72,'Add Take/Release To Stories','As a user I want to be able to \"take\" a story which assigns the story to me, and also \"release\" a story which assigns the story to \"anyone\" so that I can easily take responsibility and notify other developers of a story that I can working on.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing I should be able to \"Take\" a story by clicking on a \"Take\" link. The \"Take\" link should turn into a piece of text and a hyperlink. \"taken by Username\" and \"Release\".\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing I should be able to see the text  \"taken by User\" followed by the link \"Release\". I should be able to click on the link \"Release\" even if it was taken by another user to release the story. The link \"Take\" should be shown in it\'s place now.\n\n_The reason for allowing anyone to release/take a story is because it puts trust in the developers hands. If a developer leaves for the afternoon or is gone for a day and forgot to release a story that is not complete, it allows developers to not be hindered by that fact and they can release and re-take the story._\n\n This is complete pending the acceptance tests. Tests on the stories controller works for this.\n\n ',2,0,8,1,2,'User',3,3),(73,'Add basic navigation','',3,14,NULL,1,1,'User',NULL,NULL),(74,'BUG: After editing stories, drag/drop breaks','After editing a story you can no longer use the dragbar to drag a story around.\n\nNote: this is currently broken while Mark is working on new priority/bucket concept. ',3,0,NULL,1,NULL,NULL,5,3),(75,'BUG: After creating story, form does not reset','This is fixed with revision 247. \n\nThe problem was that after editing a story and clicking update, the story would stay open in edit mode. Now it \"blinds\" up when you click Update.\n\nNotes:\n\n* This is not fixed. The problems that I reported this for was actually that when creating stories, and clicking \"create\" the create form should be reset to allow for quick creation of another story\n\n* Completed.',1,2,8,1,2,'User',3,NULL),(76,'Clean UI for create story form','',1,15,NULL,1,1,'User',NULL,NULL),(77,'Auto suggest creation of iterations','Iterations should not have a CRUD interface. Instead, when creating a project, the user should set the iterations length. Every time a user visits the \"current iteration\" page, if there is not iteration in the current date range, the user should be asked to create one. This should have an easy \"yes\" button which will create an iteration from the end of the last iteration, for the defined iteration length. There should be a \"yes, but...\" button which should allow the developer to quickly set the start date and iteration length/end date.\n\nRather than manually dragging stories into an iteration, they should be put into the current iteration when they are completed. The current iteration page will just show the backlogged stories.\n\n_should it also show the stories completed for this iteration_',6,16,NULL,1,1,'User',NULL,3),(78,'Close Story After \"Updating\" It','As a user I should see a story\'s editable form be closed after I click the Update button so that I can move onto the next story without an additional click.\n\nh4. Notes\n\n* This is in RJS. It is a visual thing so it isn\'t tested this point, but it is functioning from the user perspective.',1,1,8,1,2,'User',3,3),(79,'Add Create Story To Every Iteration Listing','As a user I should be able to create a story for any iteration that I am viewing so that I can create stories more easily with less clicks.',2,3,8,1,1,'User',3,NULL),(80,'Show Iteration Data in Iteration Header','There should be a few iteration statistics shown in the same line as the iteration date range line.\n\n* Planned Points\n* Completed Points\n* Points Remaining',NULL,17,NULL,1,NULL,NULL,1,1),(81,'Add Iteration Budget To Iteration','As a user I should be able to specify the number of points budgeted for this iteration so that the data can be captured to show statistics for the iteration.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in and am creating a new iteration I should be able to enter the number of points budgeted for the iteration.\n\nGiven that I\'ve logged in and am editing an iteration I should be able to edit/enter the number of points budgeted for the iteration.',NULL,18,NULL,1,2,'User',1,NULL),(82,'Show Iteration Statistics','As a user I should be able to see iteration statistics so I can easily tell how the iteration is progressing.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in an am viewing an iteration I should be able to see the number of points budgeted, the number of points allocated (story point cumulative) and the number of points remaining (budget-allocated).',NULL,19,NULL,1,NULL,NULL,1,NULL),(83,'Add Easier Way To Move Stories To Current Iteration','As a user I want to have a shortcut in the  that allows me to quickly move a story to the current iteration so that I don\'t have to drag and scroll pages of stories.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in and am viewing the backlog I should be able to click on a link or icon in a story header what moves that story to the current iteration.',NULL,20,NULL,1,NULL,NULL,1,NULL),(84,'Add Easier Way To Move Stories To Backlog','As a user I want to have a shortcut in the  that allows me to quickly move a story to the backlog so that I don\'t have to drag and scroll pages of stories.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in and am viewing an iteration I should be able to click on a link or icon in a story header what moves that story to the backlog.',NULL,21,NULL,1,NULL,NULL,1,NULL),(88,'BUG: Current Iteration for a project blows up','If you try to go to the \'current iteration\' page for a project and there are no iterations, or no iterations which are currently active it will blow up.',NULL,22,NULL,1,NULL,NULL,1,NULL);
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
INSERT INTO `users` VALUES (1,'mvanholstyn','3426c19b17768f5e5c3d5a4c53952395','Mark','Van Holstyn','mvanholstyn@mutuallyhuman.com',6,1),(2,'zdennis','5f4dcc3b5aa765d61d8327deb882cf99','Zach','Dennis','zdennis@mutuallyhuman.com',6,3),(4,'karlin','e99a18c428cb38d5f260853678922e03','Karlin','Fox','fox@atomicobject.com',6,3),(5,'justin','211c42bb02f7a9e63d30e9a12222577c','Justin','Dewind','dewind@atomicobject.com',6,3),(6,'patrick','8e3a8d3e644e608d25ec40162988a137','Patrick','Bacon','bacon@atomicobject.com',6,3),(7,'dave','104e08045184a4f111170f990e274e3a','Dave','Crosby','crosby@atomicobject.com',6,3);
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

