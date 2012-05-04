CREATE DATABASE /*!32312 IF NOT EXISTS*/ `homyaki_web` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `homyaki_web`;


CREATE TABLE `interface_handlers` (
  `name` char(128) NOT NULL,
  `handler` char(128) DEFAULT NULL,
  `description` char(128) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

CREATE TABLE `form_handlers` (
  `name` char(128) NOT NULL,
  `interface_name` char(128) NOT NULL,
  `handler` char(128) DEFAULT NULL,
  `description` char(128) DEFAULT NULL,
  PRIMARY KEY (`name`, `interface_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
