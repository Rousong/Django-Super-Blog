-- MySQL dump 10.13  Distrib 5.5.62, for Linux (x86_64)
--
-- Host: localhost    Database: 2zzy
-- ------------------------------------------------------
-- Server version	5.5.62-log

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
-- Table structure for table `account_emailaddress`
--

DROP TABLE IF EXISTS `account_emailaddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_emailaddress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `verified` tinyint(1) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `account_emailaddress_user_id_2c513194_fk_auth_user_id` (`user_id`),
  CONSTRAINT `account_emailaddress_user_id_2c513194_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_emailaddress`
--

LOCK TABLES `account_emailaddress` WRITE;
/*!40000 ALTER TABLE `account_emailaddress` DISABLE KEYS */;
INSERT INTO `account_emailaddress` VALUES (1,'beaock123@gmail.com',0,1,2);
/*!40000 ALTER TABLE `account_emailaddress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_emailconfirmation`
--

DROP TABLE IF EXISTS `account_emailconfirmation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_emailconfirmation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL,
  `sent` datetime DEFAULT NULL,
  `key` varchar(64) NOT NULL,
  `email_address_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `account_emailconfirm_email_address_id_5b7f8c58_fk_account_e` (`email_address_id`),
  CONSTRAINT `account_emailconfirm_email_address_id_5b7f8c58_fk_account_e` FOREIGN KEY (`email_address_id`) REFERENCES `account_emailaddress` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_emailconfirmation`
--

LOCK TABLES `account_emailconfirmation` WRITE;
/*!40000 ALTER TABLE `account_emailconfirmation` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_emailconfirmation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `album_album`
--

DROP TABLE IF EXISTS `album_album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `album_album` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(200) NOT NULL,
  `slug` varchar(500) NOT NULL,
  `title` varchar(300) NOT NULL,
  `description` longtext NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `created` date NOT NULL,
  `total_likes` int(10) unsigned NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `album_album_user_id_ffd3e07d_fk_auth_user_id` (`user_id`),
  KEY `album_album_slug_f7a4afe1` (`slug`(255)),
  KEY `album_album_created_f24e4c4b` (`created`),
  CONSTRAINT `album_album_user_id_ffd3e07d_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album_album`
--

LOCK TABLES `album_album` WRITE;
/*!40000 ALTER TABLE `album_album` DISABLE KEYS */;
/*!40000 ALTER TABLE `album_album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_articlescolumn`
--

DROP TABLE IF EXISTS `article_articlescolumn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_articlescolumn` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_articlescolumn`
--

LOCK TABLES `article_articlescolumn` WRITE;
/*!40000 ALTER TABLE `article_articlescolumn` DISABLE KEYS */;
INSERT INTO `article_articlescolumn` VALUES (1,'漫画','2019-06-16 09:13:00');
/*!40000 ALTER TABLE `article_articlescolumn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_articlespost`
--

DROP TABLE IF EXISTS `article_articlespost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_articlespost` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `comic_title` varchar(200) DEFAULT NULL,
  `comic_sequence` int(10) unsigned DEFAULT NULL,
  `summary` varchar(200) DEFAULT NULL,
  `body` longtext NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  `total_views` int(10) unsigned NOT NULL,
  `avatar_thumbnail` varchar(100) DEFAULT NULL,
  `url` varchar(200) NOT NULL,
  `author_id` int(11) NOT NULL,
  `column_id` int(11) DEFAULT NULL,
  `comic_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `article_articlespost_author_id_c22a63d3_fk_auth_user_id` (`author_id`),
  KEY `article_articlespost_column_id_97221f7f_fk_article_a` (`column_id`),
  KEY `article_articlespost_comic_id_710e7adf_fk_comic_comic_id` (`comic_id`),
  CONSTRAINT `article_articlespost_author_id_c22a63d3_fk_auth_user_id` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `article_articlespost_column_id_97221f7f_fk_article_a` FOREIGN KEY (`column_id`) REFERENCES `article_articlescolumn` (`id`),
  CONSTRAINT `article_articlespost_comic_id_710e7adf_fk_comic_comic_id` FOREIGN KEY (`comic_id`) REFERENCES `comic_comic` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_articlespost`
--

LOCK TABLES `article_articlespost` WRITE;
/*!40000 ALTER TABLE `article_articlespost` DISABLE KEYS */;
INSERT INTO `article_articlespost` VALUES (1,'开始健身','测试',NULL,'测试文章发布','开始健身的第一天','2019-06-15 12:28:00','2019-06-16 05:04:54',52,'','',1,NULL,NULL),(2,'manhua','manhua',NULL,'显示在文章列表内的摘要,限制在100字内,不支持markdown','[![sss](http://dmimg.5054399.com/mh/jinjidejuren/023u/012.png \"sss\")](http://dmimg.5054399.com/mh/jinjidejuren/023u/012.png \"sss\")','2019-06-21 12:17:03','2019-06-21 12:17:03',10,'','',1,NULL,NULL);
/*!40000 ALTER TABLE `article_articlespost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_carousel`
--

DROP TABLE IF EXISTS `article_carousel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_carousel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) NOT NULL,
  `title` varchar(20) DEFAULT NULL,
  `content` varchar(80) NOT NULL,
  `img_url` varchar(100) NOT NULL,
  `url` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_carousel`
--

LOCK TABLES `article_carousel` WRITE;
/*!40000 ALTER TABLE `article_carousel` DISABLE KEYS */;
INSERT INTO `article_carousel` VALUES (3,0,NULL,'asdsad','images/微信截图_20190620223156.png','#');
/*!40000 ALTER TABLE `article_carousel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_timeline`
--

DROP TABLE IF EXISTS `article_timeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_timeline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `side` varchar(1) NOT NULL,
  `star_num` int(11) NOT NULL,
  `icon` varchar(50) NOT NULL,
  `icon_color` varchar(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `update_date` datetime NOT NULL,
  `content` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_timeline`
--

LOCK TABLES `article_timeline` WRITE;
/*!40000 ALTER TABLE `article_timeline` DISABLE KEYS */;
INSERT INTO `article_timeline` VALUES (1,'L',5,'fas fa-child','info','建立站点','2019-06-02 06:15:00','创建网站爱钻研'),(2,'R',3,'fab fa-github','info','使用Github备份网站','2019-06-05 15:45:00','使用自动脚本备份网站与数据库\r\n并以守护进程运行网站'),(3,'R',3,'fas fa-bolt','success','外观调整','2019-06-13 13:30:00','修改网站外观细节,标签,图标等'),(4,'L',5,'fa fa-pencil','warning','创建logo','2019-06-15 13:50:00','创建logo,并使用celery异步处理邮件发送等耗时任务');
/*!40000 ALTER TABLE `article_timeline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add user dashboard module',1,'add_userdashboardmodule'),(2,'Can change user dashboard module',1,'change_userdashboardmodule'),(3,'Can delete user dashboard module',1,'delete_userdashboardmodule'),(4,'Can add bookmark',2,'add_bookmark'),(5,'Can change bookmark',2,'change_bookmark'),(6,'Can delete bookmark',2,'delete_bookmark'),(7,'Can add pinned application',3,'add_pinnedapplication'),(8,'Can change pinned application',3,'change_pinnedapplication'),(9,'Can delete pinned application',3,'delete_pinnedapplication'),(10,'Can add log entry',4,'add_logentry'),(11,'Can change log entry',4,'change_logentry'),(12,'Can delete log entry',4,'delete_logentry'),(13,'Can add permission',5,'add_permission'),(14,'Can change permission',5,'change_permission'),(15,'Can delete permission',5,'delete_permission'),(16,'Can add group',6,'add_group'),(17,'Can change group',6,'change_group'),(18,'Can delete group',6,'delete_group'),(19,'Can add user',7,'add_user'),(20,'Can change user',7,'change_user'),(21,'Can delete user',7,'delete_user'),(22,'Can add content type',8,'add_contenttype'),(23,'Can change content type',8,'change_contenttype'),(24,'Can delete content type',8,'delete_contenttype'),(25,'Can add session',9,'add_session'),(26,'Can change session',9,'change_session'),(27,'Can delete session',9,'delete_session'),(28,'Can add user info',10,'add_userinfo'),(29,'Can change user info',10,'change_userinfo'),(30,'Can delete user info',10,'delete_userinfo'),(31,'Can add articles column',11,'add_articlescolumn'),(32,'Can change articles column',11,'change_articlescolumn'),(33,'Can delete articles column',11,'delete_articlescolumn'),(34,'Can add articles post',12,'add_articlespost'),(35,'Can change articles post',12,'change_articlespost'),(36,'Can delete articles post',12,'delete_articlespost'),(37,'Can add 图片轮播',13,'add_carousel'),(38,'Can change 图片轮播',13,'change_carousel'),(39,'Can delete 图片轮播',13,'delete_carousel'),(40,'Can add 时间线',14,'add_timeline'),(41,'Can change 时间线',14,'change_timeline'),(42,'Can delete 时间线',14,'delete_timeline'),(43,'Can add comment',15,'add_comment'),(44,'Can change comment',15,'change_comment'),(45,'Can delete comment',15,'delete_comment'),(46,'Can add album',16,'add_album'),(47,'Can change album',16,'change_album'),(48,'Can delete album',16,'delete_album'),(49,'Can add comic',17,'add_comic'),(50,'Can change comic',17,'change_comic'),(51,'Can delete comic',17,'delete_comic'),(52,'Can add github repo',18,'add_githubrepo'),(53,'Can change github repo',18,'change_githubrepo'),(54,'Can delete github repo',18,'delete_githubrepo'),(55,'Can add book column',19,'add_bookcolumn'),(56,'Can change book column',19,'change_bookcolumn'),(57,'Can delete book column',19,'delete_bookcolumn'),(58,'Can add book tag',20,'add_booktag'),(59,'Can change book tag',20,'change_booktag'),(60,'Can delete book tag',20,'delete_booktag'),(61,'Can add book type',21,'add_booktype'),(62,'Can change book type',21,'change_booktype'),(63,'Can delete book type',21,'delete_booktype'),(64,'Can add read book',22,'add_readbook'),(65,'Can change read book',22,'change_readbook'),(66,'Can delete read book',22,'delete_readbook'),(67,'Can add image source',23,'add_imagesource'),(68,'Can change image source',23,'change_imagesource'),(69,'Can delete image source',23,'delete_imagesource'),(70,'Can add vlog',24,'add_vlog'),(71,'Can change vlog',24,'change_vlog'),(72,'Can delete vlog',24,'delete_vlog'),(73,'Can add site message',25,'add_sitemessage'),(74,'Can change site message',25,'change_sitemessage'),(75,'Can delete site message',25,'delete_sitemessage'),(76,'Can add 身材记录管理',26,'add_bodymanage'),(77,'Can change 身材记录管理',26,'change_bodymanage'),(78,'Can delete 身材记录管理',26,'delete_bodymanage'),(79,'Can add 配重记录管理',27,'add_weightmanage'),(80,'Can change 配重记录管理',27,'change_weightmanage'),(81,'Can delete 配重记录管理',27,'delete_weightmanage'),(82,'Can add site',28,'add_site'),(83,'Can change site',28,'change_site'),(84,'Can delete site',28,'delete_site'),(85,'Can add email address',29,'add_emailaddress'),(86,'Can change email address',29,'change_emailaddress'),(87,'Can delete email address',29,'delete_emailaddress'),(88,'Can add email confirmation',30,'add_emailconfirmation'),(89,'Can change email confirmation',30,'change_emailconfirmation'),(90,'Can delete email confirmation',30,'delete_emailconfirmation'),(91,'Can add social account',31,'add_socialaccount'),(92,'Can change social account',31,'change_socialaccount'),(93,'Can delete social account',31,'delete_socialaccount'),(94,'Can add social application',32,'add_socialapp'),(95,'Can change social application',32,'change_socialapp'),(96,'Can delete social application',32,'delete_socialapp'),(97,'Can add social application token',33,'add_socialtoken'),(98,'Can change social application token',33,'change_socialtoken'),(99,'Can delete social application token',33,'delete_socialtoken'),(100,'Can add Tag',34,'add_tag'),(101,'Can change Tag',34,'change_tag'),(102,'Can delete Tag',34,'delete_tag'),(103,'Can add Tagged Item',35,'add_taggeditem'),(104,'Can change Tagged Item',35,'change_taggeditem'),(105,'Can delete Tagged Item',35,'delete_taggeditem'),(106,'Can add notification',36,'add_notification'),(107,'Can change notification',36,'change_notification'),(108,'Can delete notification',36,'delete_notification');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$100000$s93M1dH3oNCW$3dCiUQ+0CkaMvM0QgrGk/uFDoeL+bVCdhyy8XQ4auLs=','2019-06-21 13:28:00',1,'肉松君','','','beaock@gmail.com',1,1,'2019-06-15 12:28:00'),(2,'!kp1ntSJINaWNsJUMAOpMZWhg332lrKwmLdYoxEy4','2019-06-21 06:16:32',0,'微博测试','yyyyyyyzzzzzzkkkkk','','beaock123@gmail.com',0,1,'2019-06-21 06:16:02');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `body_bodymanage`
--

DROP TABLE IF EXISTS `body_bodymanage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `body_bodymanage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weightMb` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `BMI` decimal(5,2) DEFAULT NULL,
  `fat_rate` decimal(4,2) DEFAULT NULL,
  `fat_rateMb` decimal(4,2) DEFAULT NULL,
  `xiongwei` decimal(5,2) DEFAULT NULL,
  `biwei` decimal(5,2) DEFAULT NULL,
  `jiankaun` decimal(5,2) DEFAULT NULL,
  `yaowei` decimal(5,2) DEFAULT NULL,
  `tunwei` decimal(5,2) DEFAULT NULL,
  `datuiwei` decimal(5,2) DEFAULT NULL,
  `jiaohuai` decimal(5,2) DEFAULT NULL,
  `shouwan` decimal(5,2) DEFAULT NULL,
  `bowei` decimal(5,2) DEFAULT NULL,
  `jiaochang` decimal(5,2) DEFAULT NULL,
  `BMR` decimal(4,0) DEFAULT NULL,
  `TDEE` decimal(4,0) DEFAULT NULL,
  `zt` smallint(6) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `body_bodymanage_user_id_2ccd204d_fk_auth_user_id` (`user_id`),
  CONSTRAINT `body_bodymanage_user_id_2ccd204d_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `body_bodymanage`
--

LOCK TABLES `body_bodymanage` WRITE;
/*!40000 ALTER TABLE `body_bodymanage` DISABLE KEYS */;
INSERT INTO `body_bodymanage` VALUES (1,'2019-06-15 12:28:25','2019-06-15 12:28:25',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1),(2,'2019-06-21 06:16:32','2019-06-21 14:26:22',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,2);
/*!40000 ALTER TABLE `body_bodymanage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `body_weightmanage`
--

DROP TABLE IF EXISTS `body_weightmanage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `body_weightmanage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `rm` decimal(4,2) DEFAULT NULL,
  `wotui` decimal(5,2) DEFAULT NULL,
  `shendun` decimal(5,2) DEFAULT NULL,
  `yingla` decimal(5,2) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `body_weightmanage_user_id_e32928c9_fk_auth_user_id` (`user_id`),
  CONSTRAINT `body_weightmanage_user_id_e32928c9_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `body_weightmanage`
--

LOCK TABLES `body_weightmanage` WRITE;
/*!40000 ALTER TABLE `body_weightmanage` DISABLE KEYS */;
INSERT INTO `body_weightmanage` VALUES (1,'2019-06-15 12:28:25','2019-06-15 12:28:25',0,NULL,NULL,NULL,NULL,1),(2,'2019-06-21 06:16:32','2019-06-21 06:16:32',0,NULL,NULL,NULL,NULL,2);
/*!40000 ALTER TABLE `body_weightmanage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comic_comic`
--

DROP TABLE IF EXISTS `comic_comic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comic_comic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `created` date NOT NULL,
  `is_finished` tinyint(1) NOT NULL,
  `avatar_thumbnail` varchar(100) DEFAULT NULL,
  `url` varchar(200) NOT NULL,
  `github_repo_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comic_comic_github_repo_id_16431b34_fk_comic_githubrepo_id` (`github_repo_id`),
  CONSTRAINT `comic_comic_github_repo_id_16431b34_fk_comic_githubrepo_id` FOREIGN KEY (`github_repo_id`) REFERENCES `comic_githubrepo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comic_comic`
--

LOCK TABLES `comic_comic` WRITE;
/*!40000 ALTER TABLE `comic_comic` DISABLE KEYS */;
/*!40000 ALTER TABLE `comic_comic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comic_githubrepo`
--

DROP TABLE IF EXISTS `comic_githubrepo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comic_githubrepo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(100) NOT NULL,
  `repo` varchar(500) NOT NULL,
  `description` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comic_githubrepo`
--

LOCK TABLES `comic_githubrepo` WRITE;
/*!40000 ALTER TABLE `comic_githubrepo` DISABLE KEYS */;
/*!40000 ALTER TABLE `comic_githubrepo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_comment`
--

DROP TABLE IF EXISTS `comments_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `body` longtext NOT NULL,
  `created_time` datetime NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `is_deleted_by_staff` tinyint(1) NOT NULL,
  `lft` int(10) unsigned NOT NULL,
  `rght` int(10) unsigned NOT NULL,
  `tree_id` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `reply_to_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comments_comment_content_type_id_72fd5dbe_fk_django_co` (`content_type_id`),
  KEY `comments_comment_reply_to_id_c5c704af_fk_auth_user_id` (`reply_to_id`),
  KEY `comments_comment_user_id_a1db4881_fk_auth_user_id` (`user_id`),
  KEY `comments_comment_lft_bd703de0` (`lft`),
  KEY `comments_comment_rght_988bf211` (`rght`),
  KEY `comments_comment_tree_id_d91ce17d` (`tree_id`),
  KEY `comments_comment_level_0f094084` (`level`),
  KEY `comments_comment_parent_id_3e0802fb` (`parent_id`),
  CONSTRAINT `comments_comment_content_type_id_72fd5dbe_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `comments_comment_parent_id_3e0802fb_fk_comments_comment_id` FOREIGN KEY (`parent_id`) REFERENCES `comments_comment` (`id`),
  CONSTRAINT `comments_comment_reply_to_id_c5c704af_fk_auth_user_id` FOREIGN KEY (`reply_to_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `comments_comment_user_id_a1db4881_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_comment`
--

LOCK TABLES `comments_comment` WRITE;
/*!40000 ALTER TABLE `comments_comment` DISABLE KEYS */;
INSERT INTO `comments_comment` VALUES (1,1,'<p>测试回复</p>','2019-06-15 12:29:20',0,0,1,2,1,0,12,NULL,NULL,1),(2,1,'<p>微博测试</p>','2019-06-21 06:17:16',0,0,1,2,2,0,12,NULL,NULL,2),(3,1,'<p>测试</p>','2019-06-21 06:17:47',0,0,1,2,3,0,12,NULL,NULL,2),(4,2,'<p><img alt=\"surprise\" height=\"23\" src=\"https://2zzy.com/static/ckeditor/ckeditor/plugins/smiley/images/omg_smile.png\" title=\"surprise\" width=\"23\" /></p>','2019-06-21 14:00:35',0,0,1,2,4,0,12,NULL,NULL,1);
/*!40000 ALTER TABLE `comments_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard_userdashboardmodule`
--

DROP TABLE IF EXISTS `dashboard_userdashboardmodule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboard_userdashboardmodule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `module` varchar(255) NOT NULL,
  `app_label` varchar(255) DEFAULT NULL,
  `user` int(10) unsigned NOT NULL,
  `column` int(10) unsigned NOT NULL,
  `order` int(11) NOT NULL,
  `settings` longtext NOT NULL,
  `children` longtext NOT NULL,
  `collapsed` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard_userdashboardmodule`
--

LOCK TABLES `dashboard_userdashboardmodule` WRITE;
/*!40000 ALTER TABLE `dashboard_userdashboardmodule` DISABLE KEYS */;
INSERT INTO `dashboard_userdashboardmodule` VALUES (1,'Quick links','jet.dashboard.modules.LinkList',NULL,1,0,0,'{\"draggable\": false, \"deletable\": false, \"collapsible\": false, \"layout\": \"inline\"}','[{\"title\": \"Return to site\", \"url\": \"/\"}, {\"title\": \"\\u4fee\\u6539\\u5bc6\\u7801\", \"url\": \"/admin/password_change/\"}, {\"title\": \"\\u6ce8\\u9500\", \"url\": \"/admin/logout/\"}]',0),(2,'Applications','jet.dashboard.modules.AppList',NULL,1,1,0,'{\"models\": null, \"exclude\": [\"auth.*\"]}','',0),(3,'管理','jet.dashboard.modules.AppList',NULL,1,2,0,'{\"models\": [\"auth.*\"], \"exclude\": null}','',0),(4,'Recent Actions','jet.dashboard.modules.RecentActions',NULL,1,0,1,'{\"limit\": 10, \"include_list\": null, \"exclude_list\": null, \"user\": null}','',0),(5,'Latest Django News','jet.dashboard.modules.Feed',NULL,1,1,1,'{\"feed_url\": \"http://www.djangoproject.com/rss/weblog/\", \"limit\": 5}','',0),(6,'Support','jet.dashboard.modules.LinkList',NULL,1,2,1,'{\"draggable\": true, \"deletable\": true, \"collapsible\": true, \"layout\": \"stacked\"}','[{\"title\": \"Django documentation\", \"url\": \"http://docs.djangoproject.com/\", \"external\": true}, {\"title\": \"Django \\\"django-users\\\" mailing list\", \"url\": \"http://groups.google.com/group/django-users\", \"external\": true}, {\"title\": \"Django irc channel\", \"url\": \"irc://irc.freenode.net/django\", \"external\": true}]',0),(7,'Application models','jet.dashboard.modules.ModelList','readbook',1,0,0,'{\"models\": [\"readbook.*\"], \"exclude\": null}','',0),(8,'Recent Actions','jet.dashboard.modules.RecentActions','readbook',1,1,0,'{\"limit\": 10, \"include_list\": [\"readbook.*\"], \"exclude_list\": null, \"user\": null}','',0),(9,'Application models','jet.dashboard.modules.ModelList','socialaccount',1,0,0,'{\"models\": [\"socialaccount.*\"], \"exclude\": null}','',0),(10,'Recent Actions','jet.dashboard.modules.RecentActions','socialaccount',1,1,0,'{\"limit\": 10, \"include_list\": [\"socialaccount.*\"], \"exclude_list\": null, \"user\": null}','',0),(11,'Application models','jet.dashboard.modules.ModelList','sites',1,0,0,'{\"models\": [\"sites.*\"], \"exclude\": null}','',0),(12,'Recent Actions','jet.dashboard.modules.RecentActions','sites',1,1,0,'{\"limit\": 10, \"include_list\": [\"sites.*\"], \"exclude_list\": null, \"user\": null}','',0);
/*!40000 ALTER TABLE `dashboard_userdashboardmodule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2019-06-15 12:29:03','1','测试',1,'[{\"added\": {}}]',12,1),(2,'2019-06-15 12:42:40','1','建立站点',1,'[{\"added\": {}}]',14,1),(3,'2019-06-15 12:44:37','2','使用Github备份网站',1,'[{\"added\": {}}]',14,1),(4,'2019-06-15 12:44:47','2','使用Github备份网站',2,'[{\"changed\": {\"fields\": [\"side\"]}}]',14,1),(5,'2019-06-15 12:48:24','3','外观调整',1,'[{\"added\": {}}]',14,1),(6,'2019-06-15 12:49:25','4','创建logo',1,'[{\"added\": {}}]',14,1),(7,'2019-06-16 03:34:22','1','增加友链,下一步尽快开始做网站内容\r\n最',1,'[{\"added\": {}}]',25,1),(8,'2019-06-16 05:03:24','1','站点正在建设中',1,'[{\"added\": {}}]',13,1),(9,'2019-06-16 05:04:55','1','开始健身',2,'[{\"changed\": {\"fields\": [\"title\", \"body\", \"tags\"]}}]',12,1),(10,'2019-06-16 05:07:49','1','Github登录',1,'[{\"added\": {}}]',32,1),(11,'2019-06-16 05:08:07','2','2zzy.com',2,'[{\"changed\": {\"fields\": [\"domain\", \"name\"]}}]',28,1),(12,'2019-06-16 05:08:19','1','Github登录',2,'[{\"changed\": {\"fields\": [\"sites\"]}}]',32,1),(13,'2019-06-16 09:12:50','1','测试',1,'[{\"added\": {}}]',21,1),(14,'2019-06-16 09:13:28','1','漫画',1,'[{\"added\": {}}]',11,1),(15,'2019-06-16 09:13:55','1','栏目',1,'[{\"added\": {}}]',19,1),(16,'2019-06-16 09:14:31','1','测试读书',1,'[{\"added\": {}}]',22,1),(17,'2019-06-16 09:20:58','1','Python',1,'[{\"added\": {}}]',20,1),(18,'2019-06-16 09:21:10','2','Python',1,'[{\"added\": {}}]',20,1),(19,'2019-06-16 09:21:19','1','测试读书',2,'[{\"changed\": {\"fields\": [\"tag\"]}}]',22,1),(20,'2019-06-16 09:23:49','2','编程',1,'[{\"added\": {}}]',19,1),(21,'2019-06-16 09:23:51','1','测试读书',2,'[{\"changed\": {\"fields\": [\"column\"]}}]',22,1),(22,'2019-06-16 13:37:46','1','站点正在建设中',3,'',13,1),(23,'2019-06-16 13:38:15','2','站点建设',1,'[{\"added\": {}}]',13,1),(24,'2019-06-18 14:19:18','2','Weibo登录',1,'[{\"added\": {}}]',32,1),(25,'2019-06-18 15:00:19','1','肉松君',2,'[{\"changed\": {\"fields\": [\"username\", \"last_login\"]}}]',7,1),(26,'2019-06-19 11:56:51','2','https://2zzy.com',2,'[{\"changed\": {\"fields\": [\"domain\"]}}]',28,1),(27,'2019-06-19 12:47:58','3','https://2zzy.com/accounts/weibo/login/callback/',1,'[{\"added\": {}}]',28,1),(28,'2019-06-19 12:48:05','2','Weibo登录',2,'[{\"changed\": {\"fields\": [\"sites\"]}}]',32,1),(29,'2019-06-19 12:48:19','2','Weibo登录',2,'[]',32,1),(30,'2019-06-19 12:50:42','2','Weibo登录',2,'[{\"changed\": {\"fields\": [\"key\"]}}]',32,1),(31,'2019-06-19 12:52:17','2','Weibo登录',2,'[{\"changed\": {\"fields\": [\"key\"]}}]',32,1),(32,'2019-06-19 12:55:07','2','Weibo登录',2,'[{\"changed\": {\"fields\": [\"key\", \"sites\"]}}]',32,1),(33,'2019-06-20 13:32:49','3','asdsad',1,'[{\"added\": {}}]',13,1),(34,'2019-06-20 13:33:37','2','站点建设',3,'',13,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (29,'account','emailaddress'),(30,'account','emailconfirmation'),(4,'admin','logentry'),(16,'album','album'),(11,'article','articlescolumn'),(12,'article','articlespost'),(13,'article','carousel'),(14,'article','timeline'),(6,'auth','group'),(5,'auth','permission'),(7,'auth','user'),(17,'comic','comic'),(18,'comic','githubrepo'),(15,'comments','comment'),(8,'contenttypes','contenttype'),(1,'dashboard','userdashboardmodule'),(25,'extends','sitemessage'),(23,'imagesource','imagesource'),(2,'jet','bookmark'),(3,'jet','pinnedapplication'),(36,'notifications','notification'),(19,'readbook','bookcolumn'),(20,'readbook','booktag'),(21,'readbook','booktype'),(22,'readbook','readbook'),(9,'sessions','session'),(28,'sites','site'),(31,'socialaccount','socialaccount'),(32,'socialaccount','socialapp'),(33,'socialaccount','socialtoken'),(34,'taggit','tag'),(35,'taggit','taggeditem'),(10,'userinfo','userinfo'),(24,'vlog','vlog'),(26,'workout','bodymanage'),(27,'workout','weightmanage');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2019-06-13 12:39:40'),(2,'auth','0001_initial','2019-06-13 12:39:40'),(3,'account','0001_initial','2019-06-13 12:39:40'),(4,'account','0002_email_max_length','2019-06-13 12:39:40'),(5,'admin','0001_initial','2019-06-13 12:39:41'),(6,'admin','0002_logentry_remove_auto_add','2019-06-13 12:39:41'),(7,'album','0001_initial','2019-06-13 12:39:41'),(8,'taggit','0001_initial','2019-06-13 12:39:41'),(9,'taggit','0002_auto_20150616_2121','2019-06-13 12:39:41'),(10,'comic','0001_initial','2019-06-13 12:39:41'),(11,'article','0001_initial','2019-06-13 12:39:42'),(12,'contenttypes','0002_remove_content_type_name','2019-06-13 12:39:42'),(13,'auth','0002_alter_permission_name_max_length','2019-06-13 12:39:42'),(14,'auth','0003_alter_user_email_max_length','2019-06-13 12:39:42'),(15,'auth','0004_alter_user_username_opts','2019-06-13 12:39:42'),(16,'auth','0005_alter_user_last_login_null','2019-06-13 12:39:42'),(17,'auth','0006_require_contenttypes_0002','2019-06-13 12:39:42'),(18,'auth','0007_alter_validators_add_error_messages','2019-06-13 12:39:42'),(19,'auth','0008_alter_user_username_max_length','2019-06-13 12:39:42'),(20,'auth','0009_alter_user_last_name_max_length','2019-06-13 12:39:42'),(21,'comic','0002_auto_20190613_2121','2019-06-13 12:39:42'),(22,'comments','0001_initial','2019-06-13 12:39:42'),(23,'dashboard','0001_initial','2019-06-13 12:39:42'),(24,'extends','0001_initial','2019-06-13 12:39:42'),(25,'imagesource','0001_initial','2019-06-13 12:39:42'),(26,'jet','0001_initial','2019-06-13 12:39:42'),(27,'jet','0002_delete_userdashboardmodule','2019-06-13 12:39:42'),(28,'notifications','0001_initial','2019-06-13 12:39:42'),(29,'notifications','0002_auto_20150224_1134','2019-06-13 12:39:43'),(30,'notifications','0003_notification_data','2019-06-13 12:39:43'),(31,'notifications','0004_auto_20150826_1508','2019-06-13 12:39:43'),(32,'notifications','0005_auto_20160504_1520','2019-06-13 12:39:43'),(33,'notifications','0006_indexes','2019-06-13 12:39:43'),(34,'readbook','0001_initial','2019-06-13 12:39:43'),(35,'sessions','0001_initial','2019-06-13 12:39:43'),(36,'sites','0001_initial','2019-06-13 12:39:43'),(37,'sites','0002_alter_domain_unique','2019-06-13 12:39:43'),(38,'socialaccount','0001_initial','2019-06-13 12:39:49'),(39,'socialaccount','0002_token_max_lengths','2019-06-13 12:39:55'),(40,'socialaccount','0003_extra_data_default_dict','2019-06-13 12:39:55'),(41,'userinfo','0001_initial','2019-06-13 12:39:55'),(42,'userinfo','0002_auto_20190601_1545','2019-06-13 12:39:56'),(43,'userinfo','0003_userinfo_link','2019-06-13 12:39:56'),(44,'vlog','0001_initial','2019-06-13 12:39:56'),(45,'vlog','0002_auto_20190609_1125','2019-06-13 12:39:57'),(46,'workout','0001_initial','2019-06-13 12:39:57');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('1bf4pv19knedizqcurm9s8dm6qk2yaqf','NDExZjUwYWZhYzczN2E3YjBlZDk4ZGQ4YzU2Yjc5ODg1ZGViMjJiZTp7ImFjY291bnRfdmVyaWZpZWRfZW1haWwiOm51bGwsIl9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiYWxsYXV0aC5hY2NvdW50LmF1dGhfYmFja2VuZHMuQXV0aGVudGljYXRpb25CYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiY2E2YzUwMTU2NTViOTcwZmVmNGNmYjBkNjI0MDQwOWUxMjhjZTQwZSJ9','2019-07-05 06:16:32'),('4tj0n9ziwwu4ch9q3w59b2edtennvr32','ZmIzOWY0NjYyZmFkYWI2NTU1Yjg5ZjRjZjI3NTRkODgwMjBlYzNiYzp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiY3lraEIyWGNSckdXIl19','2019-06-30 05:18:11'),('5iyihjoadoovzems0r4kvhfo3cobjkun','YTdjOTU4OTRkOWY3MDE1YTQ3NWFmMjRmMzlmMTE1OWEwYjFiYzU3Zjp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiOHpTcGkzOVJKUUZjIl19','2019-07-04 03:59:58'),('ap112pvl05bsd7rsdvwynagp48i83br2','MjBlNGM4NjNiYmE5ZWFiMzlmMWE2M2U4YTQ1YzNmMDAxM2E4NmFiMDp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiZDI3NnRRRnk5M1ZiIl19','2019-07-04 03:22:59'),('g5vukoyznv7b7hsbldgkxrhu6ahdg3ie','NmE0ZmY0M2NmZGZkZTQ0MDhkYzU2MGM3MDUxZWNmMzBjNjk2MDVhYTp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiT0VESG1meE1od0tRIl19','2019-07-03 12:55:15'),('kjya77q04v1bsclhs37883btr252erm1','MzU1MWRjZTZkZTIzMDUwNWNhNWM3MzA0ZTFiN2U0MWU1MzAwMmU0YTp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiSkxqWXpXaU1jN21wIl19','2019-06-30 20:27:02'),('ogfp63v1xlsegx3cwc8462479o4sswfa','NGU3YWVjODg0ZGE2OGJhYmJkYzQ2ZDZkYTIzMDFmYzA2MWFhZjllMzp7InNvY2lhbGFjY291bnRfc29jaWFsbG9naW4iOnsiYWNjb3VudCI6eyJpZCI6bnVsbCwidXNlcl9pZCI6bnVsbCwicHJvdmlkZXIiOiJnaXRodWIiLCJ1aWQiOiIyOTQwODc1OSIsImxhc3RfbG9naW4iOm51bGwsImRhdGVfam9pbmVkIjpudWxsLCJleHRyYV9kYXRhIjp7ImxvZ2luIjoiUm91c29uZyIsImlkIjoyOTQwODc1OSwibm9kZV9pZCI6Ik1EUTZWWE5sY2pJNU5EQTROelU1IiwiYXZhdGFyX3VybCI6Imh0dHBzOi8vYXZhdGFyczEuZ2l0aHVidXNlcmNvbnRlbnQuY29tL3UvMjk0MDg3NTk/dj00IiwiZ3JhdmF0YXJfaWQiOiIiLCJ1cmwiOiJodHRwczovL2FwaS5naXRodWIuY29tL3VzZXJzL1JvdXNvbmciLCJodG1sX3VybCI6Imh0dHBzOi8vZ2l0aHViLmNvbS9Sb3Vzb25nIiwiZm9sbG93ZXJzX3VybCI6Imh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vdXNlcnMvUm91c29uZy9mb2xsb3dlcnMiLCJmb2xsb3dpbmdfdXJsIjoiaHR0cHM6Ly9hcGkuZ2l0aHViLmNvbS91c2Vycy9Sb3Vzb25nL2ZvbGxvd2luZ3svb3RoZXJfdXNlcn0iLCJnaXN0c191cmwiOiJodHRwczovL2FwaS5naXRodWIuY29tL3VzZXJzL1JvdXNvbmcvZ2lzdHN7L2dpc3RfaWR9Iiwic3RhcnJlZF91cmwiOiJodHRwczovL2FwaS5naXRodWIuY29tL3VzZXJzL1JvdXNvbmcvc3RhcnJlZHsvb3duZXJ9ey9yZXBvfSIsInN1YnNjcmlwdGlvbnNfdXJsIjoiaHR0cHM6Ly9hcGkuZ2l0aHViLmNvbS91c2Vycy9Sb3Vzb25nL3N1YnNjcmlwdGlvbnMiLCJvcmdhbml6YXRpb25zX3VybCI6Imh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vdXNlcnMvUm91c29uZy9vcmdzIiwicmVwb3NfdXJsIjoiaHR0cHM6Ly9hcGkuZ2l0aHViLmNvbS91c2Vycy9Sb3Vzb25nL3JlcG9zIiwiZXZlbnRzX3VybCI6Imh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vdXNlcnMvUm91c29uZy9ldmVudHN7L3ByaXZhY3l9IiwicmVjZWl2ZWRfZXZlbnRzX3VybCI6Imh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vdXNlcnMvUm91c29uZy9yZWNlaXZlZF9ldmVudHMiLCJ0eXBlIjoiVXNlciIsInNpdGVfYWRtaW4iOmZhbHNlLCJuYW1lIjoiRG8xMDI0IiwiY29tcGFueSI6bnVsbCwiYmxvZyI6Ind3dy5kbzEwMjQuY29tIiwibG9jYXRpb24iOiJUb2t5byIsImVtYWlsIjoiYmVhb2NrQGdtYWlsLmNvbSIsImhpcmVhYmxlIjpudWxsLCJiaW8iOm51bGwsInB1YmxpY19yZXBvcyI6MzMsInB1YmxpY19naXN0cyI6MCwiZm9sbG93ZXJzIjoyLCJmb2xsb3dpbmciOjE2LCJjcmVhdGVkX2F0IjoiMjAxNy0wNi0xM1QxNjo0MDoyOVoiLCJ1cGRhdGVkX2F0IjoiMjAxOS0wNi0wNVQxNDoxODo1NloifX0sInVzZXIiOnsiaWQiOm51bGwsInBhc3N3b3JkIjoiIVMxV3g2Y3Jxb3NGTnNFNmN0WG5RMkU1aGQ0cjNrN3BmeFRCVW05MlYiLCJsYXN0X2xvZ2luIjpudWxsLCJpc19zdXBlcnVzZXIiOmZhbHNlLCJ1c2VybmFtZSI6IlJvdXNvbmciLCJmaXJzdF9uYW1lIjoiRG8xMDI0IiwibGFzdF9uYW1lIjoiIiwiZW1haWwiOiJiZWFvY2tAZ21haWwuY29tIiwiaXNfc3RhZmYiOmZhbHNlLCJpc19hY3RpdmUiOnRydWUsImRhdGVfam9pbmVkIjoiMjAxOS0wNi0xOVQxMjo1MjoyNy44MTZaIn0sInN0YXRlIjp7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiZW1haWxfYWRkcmVzc2VzIjpbeyJpZCI6bnVsbCwidXNlcl9pZCI6bnVsbCwiZW1haWwiOiJiZWFvY2tAZ21haWwuY29tIiwidmVyaWZpZWQiOmZhbHNlLCJwcmltYXJ5Ijp0cnVlfV0sInRva2VuIjp7ImlkIjpudWxsLCJhcHBfaWQiOjEsImFjY291bnRfaWQiOm51bGwsInRva2VuIjoiYTUzODQ0OTZmMWNhYmQ3MWQ5MjIzZDBjOTA5MDI3MDUxMjI2NWI4YiIsInRva2VuX3NlY3JldCI6IiIsImV4cGlyZXNfYXQiOm51bGx9fX0=','2019-07-03 12:52:27'),('swdy9uzziv5iy5s1nzdp35yhqsg1n7mz','NTgyYWMwZDgyZjlmNjYyMmMzY2I1OTJiMmM1MGJhZDQ5NTdiODJjMzp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwic2FPRU5vOEFWNUtKIl19','2019-06-30 10:53:46'),('w1sq7qpo1ym2zr6sd2eabntaytdwiyp1','NzBjMTZkOGE5ZTdlMTU5YTczNjMyNWYyNDc5NWMyNTM0N2Y0YTAxMjp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiQUI4RkZnSE1oWXV2Il19','2019-07-03 13:57:46'),('zfxym0gqnn28pesgit7xfv3wjdep9qxa','MDA3NmI2ZDcxZGFmMzBjN2Q2NDMwMDgwMzI2MmNlY2Q1OGY3MTMxNjp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiOTBTSWh1RG4yTHVrIl0sIl9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIyOGQ4YWY4ZWJkOTM2Y2EyODIxYzEwYTNmZjQ1MjljZTU0ODNlZmU3IiwiX3Nlc3Npb25fZXhwaXJ5IjoxMjA5NjAwfQ==','2019-07-05 13:28:00'),('zi31w408kgcmpn7cmdf6sxhrj2mb4ycq','YTFkNTRhNGE1ZmYyNDkwNTc2MjUwMzIzYTZjMmZjNjk5MWY5MWEyNjp7InNvY2lhbGFjY291bnRfc3RhdGUiOlt7InByb2Nlc3MiOiJsb2dpbiIsInNjb3BlIjoiIiwiYXV0aF9wYXJhbXMiOiIifSwiVFowOW1QZVV0MU85Il19','2019-06-30 10:09:18');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_site_domain_a2e37b91_uniq` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_site`
--

LOCK TABLES `django_site` WRITE;
/*!40000 ALTER TABLE `django_site` DISABLE KEYS */;
INSERT INTO `django_site` VALUES (2,'https://2zzy.com','爱钻研'),(3,'https://2zzy.com/accounts/weibo/login/callback/','callback');
/*!40000 ALTER TABLE `django_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `extends_sitemessage`
--

DROP TABLE IF EXISTS `extends_sitemessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `extends_sitemessage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` longtext NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `extends_sitemessage`
--

LOCK TABLES `extends_sitemessage` WRITE;
/*!40000 ALTER TABLE `extends_sitemessage` DISABLE KEYS */;
INSERT INTO `extends_sitemessage` VALUES (1,'增加友链,下一步尽快开始做网站内容\r\n最近太关注于网站代码了(笑)','2019-06-16 03:33:00');
/*!40000 ALTER TABLE `extends_sitemessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagesource_imagesource`
--

DROP TABLE IF EXISTS `imagesource_imagesource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imagesource_imagesource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL,
  `avatar_thumbnail` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagesource_imagesource`
--

LOCK TABLES `imagesource_imagesource` WRITE;
/*!40000 ALTER TABLE `imagesource_imagesource` DISABLE KEYS */;
/*!40000 ALTER TABLE `imagesource_imagesource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jet_bookmark`
--

DROP TABLE IF EXISTS `jet_bookmark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jet_bookmark` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(200) NOT NULL,
  `title` varchar(255) NOT NULL,
  `user` int(10) unsigned NOT NULL,
  `date_add` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jet_bookmark`
--

LOCK TABLES `jet_bookmark` WRITE;
/*!40000 ALTER TABLE `jet_bookmark` DISABLE KEYS */;
/*!40000 ALTER TABLE `jet_bookmark` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jet_pinnedapplication`
--

DROP TABLE IF EXISTS `jet_pinnedapplication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jet_pinnedapplication` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(255) NOT NULL,
  `user` int(10) unsigned NOT NULL,
  `date_add` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jet_pinnedapplication`
--

LOCK TABLES `jet_pinnedapplication` WRITE;
/*!40000 ALTER TABLE `jet_pinnedapplication` DISABLE KEYS */;
/*!40000 ALTER TABLE `jet_pinnedapplication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications_notification`
--

DROP TABLE IF EXISTS `notifications_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications_notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` varchar(20) NOT NULL,
  `unread` tinyint(1) NOT NULL,
  `actor_object_id` varchar(255) NOT NULL,
  `verb` varchar(255) NOT NULL,
  `description` longtext,
  `target_object_id` varchar(255) DEFAULT NULL,
  `action_object_object_id` varchar(255) DEFAULT NULL,
  `timestamp` datetime NOT NULL,
  `public` tinyint(1) NOT NULL,
  `action_object_content_type_id` int(11) DEFAULT NULL,
  `actor_content_type_id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `target_content_type_id` int(11) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL,
  `emailed` tinyint(1) NOT NULL,
  `data` longtext,
  PRIMARY KEY (`id`),
  KEY `notifications_notifi_action_object_conten_7d2b8ee9_fk_django_co` (`action_object_content_type_id`),
  KEY `notifications_notifi_actor_content_type_i_0c69d7b7_fk_django_co` (`actor_content_type_id`),
  KEY `notifications_notification_recipient_id_d055f3f0_fk_auth_user_id` (`recipient_id`),
  KEY `notifications_notifi_target_content_type__ccb24d88_fk_django_co` (`target_content_type_id`),
  KEY `notifications_notification_deleted_b32b69e6` (`deleted`),
  KEY `notifications_notification_emailed_23a5ad81` (`emailed`),
  KEY `notifications_notification_public_1bc30b1c` (`public`),
  KEY `notifications_notification_unread_cce4be30` (`unread`),
  CONSTRAINT `notifications_notification_recipient_id_d055f3f0_fk_auth_user_id` FOREIGN KEY (`recipient_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `notifications_notifi_action_object_conten_7d2b8ee9_fk_django_co` FOREIGN KEY (`action_object_content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `notifications_notifi_actor_content_type_i_0c69d7b7_fk_django_co` FOREIGN KEY (`actor_content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `notifications_notifi_target_content_type__ccb24d88_fk_django_co` FOREIGN KEY (`target_content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications_notification`
--

LOCK TABLES `notifications_notification` WRITE;
/*!40000 ALTER TABLE `notifications_notification` DISABLE KEYS */;
INSERT INTO `notifications_notification` VALUES (1,'info',0,'2','回复了你','article','1','2','2019-06-21 06:17:16',1,15,7,1,12,0,0,NULL),(2,'info',0,'2','回复了你','article','1','3','2019-06-21 06:17:47',1,15,7,1,12,0,0,NULL);
/*!40000 ALTER TABLE `notifications_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `readbook_bookcolumn`
--

DROP TABLE IF EXISTS `readbook_bookcolumn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `readbook_bookcolumn` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `readbook_bookcolumn`
--

LOCK TABLES `readbook_bookcolumn` WRITE;
/*!40000 ALTER TABLE `readbook_bookcolumn` DISABLE KEYS */;
INSERT INTO `readbook_bookcolumn` VALUES (1,'栏目'),(2,'编程');
/*!40000 ALTER TABLE `readbook_bookcolumn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `readbook_booktag`
--

DROP TABLE IF EXISTS `readbook_booktag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `readbook_booktag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `readbook_booktag`
--

LOCK TABLES `readbook_booktag` WRITE;
/*!40000 ALTER TABLE `readbook_booktag` DISABLE KEYS */;
INSERT INTO `readbook_booktag` VALUES (1,'Python'),(2,'Python');
/*!40000 ALTER TABLE `readbook_booktag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `readbook_booktype`
--

DROP TABLE IF EXISTS `readbook_booktype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `readbook_booktype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `readbook_booktype`
--

LOCK TABLES `readbook_booktype` WRITE;
/*!40000 ALTER TABLE `readbook_booktype` DISABLE KEYS */;
INSERT INTO `readbook_booktype` VALUES (1,'测试');
/*!40000 ALTER TABLE `readbook_booktype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `readbook_readbook`
--

DROP TABLE IF EXISTS `readbook_readbook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `readbook_readbook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `url` varchar(200) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  `author_id` int(11) NOT NULL,
  `column_id` int(11) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `readbook_readbook_author_id_0288bbaf_fk_auth_user_id` (`author_id`),
  KEY `readbook_readbook_column_id_7a0f6cd1_fk_readbook_bookcolumn_id` (`column_id`),
  KEY `readbook_readbook_tag_id_07da8452_fk_readbook_booktag_id` (`tag_id`),
  KEY `readbook_readbook_type_id_8d7be92a_fk_readbook_booktype_id` (`type_id`),
  CONSTRAINT `readbook_readbook_author_id_0288bbaf_fk_auth_user_id` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `readbook_readbook_column_id_7a0f6cd1_fk_readbook_bookcolumn_id` FOREIGN KEY (`column_id`) REFERENCES `readbook_bookcolumn` (`id`),
  CONSTRAINT `readbook_readbook_tag_id_07da8452_fk_readbook_booktag_id` FOREIGN KEY (`tag_id`) REFERENCES `readbook_booktag` (`id`),
  CONSTRAINT `readbook_readbook_type_id_8d7be92a_fk_readbook_booktype_id` FOREIGN KEY (`type_id`) REFERENCES `readbook_booktype` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `readbook_readbook`
--

LOCK TABLES `readbook_readbook` WRITE;
/*!40000 ALTER TABLE `readbook_readbook` DISABLE KEYS */;
INSERT INTO `readbook_readbook` VALUES (1,'测试读书','http://www.do1024.com','2019-06-16 09:14:00','2019-06-16 09:23:51',1,2,2,1);
/*!40000 ALTER TABLE `readbook_readbook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialaccount_socialaccount`
--

DROP TABLE IF EXISTS `socialaccount_socialaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `socialaccount_socialaccount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `provider` varchar(30) NOT NULL,
  `uid` varchar(191) NOT NULL,
  `last_login` datetime NOT NULL,
  `date_joined` datetime NOT NULL,
  `extra_data` longtext NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `socialaccount_socialaccount_provider_uid_fc810c6e_uniq` (`provider`,`uid`),
  KEY `socialaccount_socialaccount_user_id_8146e70c_fk_auth_user_id` (`user_id`),
  CONSTRAINT `socialaccount_socialaccount_user_id_8146e70c_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialaccount_socialaccount`
--

LOCK TABLES `socialaccount_socialaccount` WRITE;
/*!40000 ALTER TABLE `socialaccount_socialaccount` DISABLE KEYS */;
INSERT INTO `socialaccount_socialaccount` VALUES (1,'weibo','2807842787','2019-06-21 06:16:32','2019-06-21 06:16:32','{\"id\": 2807842787, \"idstr\": \"2807842787\", \"class\": 1, \"screen_name\": \"yyyyyyyzzzzzzkkkkk\", \"name\": \"yyyyyyyzzzzzzkkkkk\", \"province\": \"400\", \"city\": \"15\", \"location\": \"\\u6d77\\u5916 \\u65e5\\u672c\", \"description\": \"\\ud83c\\udf1f\", \"url\": \"\", \"profile_image_url\": \"http://tvax1.sinaimg.cn/crop.0.0.664.664.50/a75c47e3ly8fm2e8oggv5j20ig0ig74n.jpg\", \"cover_image_phone\": \"http://ww1.sinaimg.cn/crop.0.0.640.640.640/549d0121tw1egm1kjly3jj20hs0hsq4f.jpg\", \"profile_url\": \"40937117\", \"domain\": \"\", \"weihao\": \"40937117\", \"gender\": \"m\", \"followers_count\": 140, \"friends_count\": 384, \"pagefriends_count\": 4, \"statuses_count\": 1119, \"video_status_count\": 0, \"favourites_count\": 149, \"created_at\": \"Wed Jul 25 18:46:06 +0800 2012\", \"following\": false, \"allow_all_act_msg\": false, \"geo_enabled\": true, \"verified\": false, \"verified_type\": -1, \"remark\": \"\", \"insecurity\": {\"sexual_content\": false}, \"status\": {\"created_at\": \"Mon Jun 17 06:26:30 +0800 2019\", \"id\": 4384056524981168, \"idstr\": \"4384056524981168\", \"mid\": \"4384056524981168\", \"can_edit\": false, \"show_additional_indication\": 0, \"text\": \"\\u8f6c\\u53d1\\u5fae\\u535a\", \"source_allowclick\": 0, \"source_type\": 2, \"source\": \"<a href=\\\"http://weibo.com/\\\" rel=\\\"nofollow\\\">iPhone\\u5ba2\\u6237\\u7aef</a>\", \"favorited\": false, \"truncated\": false, \"in_reply_to_status_id\": \"\", \"in_reply_to_user_id\": \"\", \"in_reply_to_screen_name\": \"\", \"pic_urls\": [], \"geo\": null, \"is_paid\": false, \"mblog_vip_type\": 0, \"annotations\": [{\"mapi_request\": true}], \"reposts_count\": 0, \"comments_count\": 0, \"attitudes_count\": 0, \"pending_approval_count\": 0, \"isLongText\": false, \"reward_exhibition_type\": 0, \"hide_flag\": 0, \"mlevel\": 0, \"visible\": {\"type\": 0, \"list_id\": 0}, \"biz_feature\": 0, \"hasActionTypeCard\": 0, \"darwin_tags\": [], \"hot_weibo_tags\": [], \"text_tag_tips\": [], \"mblogtype\": 0, \"rid\": \"0\", \"userType\": 0, \"more_info_type\": 0, \"positive_recom_flag\": 0, \"content_auth\": 0, \"gif_ids\": \"\", \"is_show_bulletin\": 2, \"comment_manage_info\": {\"comment_permission_type\": -1, \"approval_comment_type\": 0}}, \"ptype\": 0, \"allow_all_comment\": true, \"avatar_large\": \"http://tvax1.sinaimg.cn/crop.0.0.664.664.180/a75c47e3ly8fm2e8oggv5j20ig0ig74n.jpg\", \"avatar_hd\": \"http://tvax1.sinaimg.cn/crop.0.0.664.664.1024/a75c47e3ly8fm2e8oggv5j20ig0ig74n.jpg\", \"verified_reason\": \"\", \"verified_trade\": \"\", \"verified_reason_url\": \"\", \"verified_source\": \"\", \"verified_source_url\": \"\", \"follow_me\": false, \"like\": false, \"like_me\": false, \"online_status\": 0, \"bi_followers_count\": 42, \"lang\": \"zh-cn\", \"star\": 0, \"mbtype\": 0, \"mbrank\": 0, \"block_word\": 0, \"block_app\": 0, \"credit_score\": 80, \"user_ability\": 0, \"urank\": 25, \"story_read_state\": -1, \"vclub_member\": 0, \"is_teenager\": 0, \"is_guardian\": 0, \"is_teenager_list\": 0}',2);
/*!40000 ALTER TABLE `socialaccount_socialaccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialaccount_socialapp`
--

DROP TABLE IF EXISTS `socialaccount_socialapp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `socialaccount_socialapp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `provider` varchar(30) NOT NULL,
  `name` varchar(40) NOT NULL,
  `client_id` varchar(191) NOT NULL,
  `secret` varchar(191) NOT NULL,
  `key` varchar(191) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialaccount_socialapp`
--

LOCK TABLES `socialaccount_socialapp` WRITE;
/*!40000 ALTER TABLE `socialaccount_socialapp` DISABLE KEYS */;
INSERT INTO `socialaccount_socialapp` VALUES (1,'github','Github登录','46dfa8c114641cda7152','4b376f9923635d37ce076e16a597b26086326c2e',''),(2,'weibo','Weibo登录','3507209896','e7cb6b7e230488a9dd60f5bc76554121','');
/*!40000 ALTER TABLE `socialaccount_socialapp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialaccount_socialapp_sites`
--

DROP TABLE IF EXISTS `socialaccount_socialapp_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `socialaccount_socialapp_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `socialapp_id` int(11) NOT NULL,
  `site_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `socialaccount_socialapp_sites_socialapp_id_site_id_71a9a768_uniq` (`socialapp_id`,`site_id`),
  KEY `socialaccount_socialapp_sites_site_id_2579dee5_fk_django_site_id` (`site_id`),
  CONSTRAINT `socialaccount_socialapp_sites_site_id_2579dee5_fk_django_site_id` FOREIGN KEY (`site_id`) REFERENCES `django_site` (`id`),
  CONSTRAINT `socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc` FOREIGN KEY (`socialapp_id`) REFERENCES `socialaccount_socialapp` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialaccount_socialapp_sites`
--

LOCK TABLES `socialaccount_socialapp_sites` WRITE;
/*!40000 ALTER TABLE `socialaccount_socialapp_sites` DISABLE KEYS */;
INSERT INTO `socialaccount_socialapp_sites` VALUES (1,1,2),(4,2,2);
/*!40000 ALTER TABLE `socialaccount_socialapp_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialaccount_socialtoken`
--

DROP TABLE IF EXISTS `socialaccount_socialtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `socialaccount_socialtoken` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `token_secret` longtext NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  `account_id` int(11) NOT NULL,
  `app_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq` (`app_id`,`account_id`),
  KEY `socialaccount_social_account_id_951f210e_fk_socialacc` (`account_id`),
  CONSTRAINT `socialaccount_social_account_id_951f210e_fk_socialacc` FOREIGN KEY (`account_id`) REFERENCES `socialaccount_socialaccount` (`id`),
  CONSTRAINT `socialaccount_social_app_id_636a42d7_fk_socialacc` FOREIGN KEY (`app_id`) REFERENCES `socialaccount_socialapp` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialaccount_socialtoken`
--

LOCK TABLES `socialaccount_socialtoken` WRITE;
/*!40000 ALTER TABLE `socialaccount_socialtoken` DISABLE KEYS */;
INSERT INTO `socialaccount_socialtoken` VALUES (1,'2.00tK7BEDYVt2pD302d63ca7e0yktLL','','2024-06-19 06:16:01',1,2);
/*!40000 ALTER TABLE `socialaccount_socialtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggit_tag`
--

DROP TABLE IF EXISTS `taggit_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggit_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taggit_tag`
--

LOCK TABLES `taggit_tag` WRITE;
/*!40000 ALTER TABLE `taggit_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `taggit_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggit_taggeditem`
--

DROP TABLE IF EXISTS `taggit_taggeditem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggit_taggeditem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `taggit_taggeditem_tag_id_f4f5b767_fk_taggit_tag_id` (`tag_id`),
  KEY `taggit_taggeditem_object_id_e2d7d1df` (`object_id`),
  KEY `taggit_taggeditem_content_type_id_object_id_196cc965_idx` (`content_type_id`,`object_id`),
  CONSTRAINT `taggit_taggeditem_content_type_id_9957a03c_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `taggit_taggeditem_tag_id_f4f5b767_fk_taggit_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `taggit_tag` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taggit_taggeditem`
--

LOCK TABLES `taggit_taggeditem` WRITE;
/*!40000 ALTER TABLE `taggit_taggeditem` DISABLE KEYS */;
/*!40000 ALTER TABLE `taggit_taggeditem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userinfo_userinfo`
--

DROP TABLE IF EXISTS `userinfo_userinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userinfo_userinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `avatar` varchar(100) DEFAULT NULL,
  `blood` smallint(6) NOT NULL,
  `gender` smallint(6) NOT NULL,
  `startWorkout` date DEFAULT NULL,
  `link` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userinfo_userinfo`
--

LOCK TABLES `userinfo_userinfo` WRITE;
/*!40000 ALTER TABLE `userinfo_userinfo` DISABLE KEYS */;
INSERT INTO `userinfo_userinfo` VALUES (1,1,'user/1/avatar/9b3387d76a.jpg',0,1,NULL,''),(2,2,'/static/img/user_default_avatar/03.svg',0,0,NULL,'');
/*!40000 ALTER TABLE `userinfo_userinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vlog_vlog`
--

DROP TABLE IF EXISTS `vlog_vlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vlog_vlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `body` longtext NOT NULL,
  `avatar_url` varchar(200) NOT NULL,
  `video_url` varchar(200) DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  `total_views` int(10) unsigned NOT NULL,
  `author_id` int(11) NOT NULL,
  `iframe` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vlog_vlog_author_id_42b6d87f_fk_auth_user_id` (`author_id`),
  CONSTRAINT `vlog_vlog_author_id_42b6d87f_fk_auth_user_id` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vlog_vlog`
--

LOCK TABLES `vlog_vlog` WRITE;
/*!40000 ALTER TABLE `vlog_vlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `vlog_vlog` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-06-22  5:15:01
