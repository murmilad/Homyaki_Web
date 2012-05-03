CREATE TABLE `interface_handlers` (
  `name` char(128) DEFAULT NULL,
  `description` char(128) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

CREATE TABLE `form_handlers` (
  `name` char(128) unsigned NOT NULL,
  `description` char(128) DEFAULT NULL,
  `interface_name` char(128) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
