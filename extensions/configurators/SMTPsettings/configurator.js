/**
* 
* This file is part of BulkEmailplugin
*
* Copyright 2014 Jake Bourne
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
function initSMTPsettingsConfigurator(data) {

	initConfigurator(data,{
		url: '../plugins/MuraPlugin/extensions/configurators/SMTPsettings/configurator.cfm'
		, pars: ''
		, title: 'SMTP Settings'
		, init: function(){}
		, destroy: function(){}
		, validate: function(){
			// simple js validation
			if ( !jQuery('#smtp_server').val() || !jQuery('#smtp_username').val() || !jQuery('#smtp_password').val() ) {
				var response = alert('SMTP settings not complete');
				return false;
			}
			return true;
		}
	});

	return true;

};