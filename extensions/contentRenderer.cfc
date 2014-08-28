/**
*
* This file is part of MuraPlugin
*
* Copyright 2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true extends='mura.cfobject' output=false {

	property name='$';

	include '../plugin/settings.cfm';

	public any function init(required struct $) {
		set$(arguments.$);
		return this;
	}




	public string function bulkemailform() {

		var local = {};
		if ( !Len(Trim(arguments.smtp_server)) ) { return ''; }

		local.defaultParams = {
			defaultSender = '',
			defaultRecipient = '',
			smtp_server = 'smtp.yourdomain.com',
			smtp_username = 'your smtp username',
			smtp_password = 'your smtp password'
		};
		StructAppend(variables, local.defaultParams(), false);

		savecontent variable='local.formoutput' {
			include 'display_objects/bulkEmailForm.cfm';
		}

		return local.formoutput;
	}



	/*
	* CONFIGURED DISPLAY OBJECTS
	* --------------------------------------------------------------------- */


	public any function dspConfiguredSMTP(required struct $) {
		var local = {};
		set$(arguments.$);

		local.params = arguments.$.event('objectParams');

		local.defaultParams = {
			defaultSender = 'webmaster@thisdomain.com',
			defaultRecipient = 'joe@bloggs.net',
			smtp_server = 'smtp.yourdomain.com',
			smtp_username = 'your smtp username',
			smtp_password = 'your smtp password'
		};

		StructAppend(local.params, local.defaultParams, false);

		local.formoutput = bulkemailform(argumentCollection=local.params);

		return local.formoutput;
	}

}