<cfscript>
/**
*
* This file is part of MuraPlugin
*
* Copyright 2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/

	$ = StructKeyExists(session, 'siteid') ?
		application.serviceFactory.getBean('$').init('session.siteid') :
		application.serviceFactory.getBean('$').init('default');

	params = IsJSON($.event('params')) ? DeSerializeJSON($.event('params')) : {};

	defaultParams = {
		defaultSender = '',
		defaultRecipient = '',
		smtp_server = '',
		smtp_username = '',
		smtp_password = ''
	};

	StructAppend(params, defaultParams, false);
</cfscript>

<style type="text/css">
	#availableObjectParams dt { padding-top:1em; }
	#availableObjectParams dt.first { padding-top:0; }
</style>

<cfoutput>

	<div id="availableObjectParams"
		data-object="plugin"
		data-name="SMTPsettings"
		data-objectid="#$.event('objectID')#">

		<div class="row-fluid">

			<!--- Message --->
			<div class="control-group">
				<label for="size" class="control-label">Email settings</label>
				<div class="controls">
					<label for="defaultSender">Default Sender:</label>
					<input type="text" name="defaultSender" value="#params.defaultSender#"
							id="defaultSender" class="objectParam span30" />

					<label for="defaultRecipient">Default Sender:</label>
					<input type="text" name="defaultRecipient" value="#params.defaultRecipient#"
							id="defaultRecipient" class="objectParam span30" />

					<label for="smtp_server">SMTP Server:</label>
					<input type="text" name="smtp_server" value="#params.smtp_server#"
							id="smtp_server" class="objectParam span12" />

					<label for="smtp_username">SMTP Username:</label>
					<input type="text" name="smtp_username" value="#params.smtp_username#"
							id="smtp_username" class="objectParam span12" />

					<label for="smtp_password">SMTP Password:</label>
					<input type="text" name="smtp_password" value="#params.smtp_password#"
							id="smtp_password" class="objectParam span12" />
				</div>
			</div>
		</div>

		<!--- MISC. : Not necessary, just using as an example of how to add hidden fields --->
		<input type="hidden" name="configuredDTS" class="objectParam" value="#Now()#" />
		<input type="hidden" name="configuredBy" class="objectParam" value="#HTMLEditFormat($.currentUser('LName'))#, #HTMLEditFormat($.currentUser('FName'))#" />

	</div>

</cfoutput>