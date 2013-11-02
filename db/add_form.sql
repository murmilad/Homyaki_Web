USE `homyaki_web`;
INSERT INTO `form_handlers` (handler, name, description, interface_name)
	VALUES	
		('Homyaki::Interface::Auth'     , 'auth'  , 'Default auth'    , 'main')
		,('Homyaki::Interface::Default'     , 'main'  , 'Default form handler'    , 'main')
		,('Homyaki::Interface::Log_Analize', 'ip_log', 'Log analize form handler', 'main');
