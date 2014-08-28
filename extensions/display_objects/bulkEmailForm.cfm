

<cfparam name="variables.defaultSender" default="webmaster@thisdomain.com" />
<cfparam name="variables.defaultRecipient" default="joe@bloggs.net" />

<cfparam name="variables.smtp_server" default="" />
<cfparam name="variables.smtp_username" default="" />
<cfparam name="variables.smtp_password" default="" />


<cfif StructKeyExists(form, "sendemail")>
	<cfinclude template="bulkemailaction.cfm" />
<cfelse>

	<cfoutput>
		<div class="container">
			<form id="bulkemailform" name="bulkemailform" class="form-horizontal" action="bulkEmailForm.cfm" method="POST" enctype="multipart/form-data">
				<fieldset>
				<legend>Recipients</legend>
				<div class="row control-group" id="fromfield">
					<div class="span2" style="text-align:right;">
						<span class="label label-inverse">From:</span>
					</div>
					<div class="span10">
						<input type="text" class="span8" id="from" name="from" value="" placeholder="From:" />
					</div>
				</div>
				<div class="row control-group" id="tofield">
					<div class="span2" style="text-align:right;">
						<span class="label label-inverse">To:</span>
					</div>
					<div class="span10">
						<input type="text" id="to" name="to" value="" class="span8" placeholder="To:" />
					</div>
				</div>
				<div class="row control-group" id="ccfield">
					<div class="span2" style="text-align:right;">
						<span class="label label-inverse">Cc:</span>
					</div>
					<div class="span10">

						<input type="text" id="cc" name="cc" value="" class="span8" placeholder="Cc:" />
					</div>
				</div>
				<div class="row control-group" id="bccfield">
					<div class="span2" style="text-align:right;">
						<span class="label label-inverse">Bcc:</span>
					</div>
					<div class="span10">
						<input type="text" id="bcc" name="bcc" value="" class="span8" placeholder="Bcc:" />
						<input type="file" name="attachbcc">
					</div>
				</div>
				</fieldset>

				<fieldset>
				<legend>Body</legend>
				<div class="row control-group" id="subjectfield">
					<div class="span2" style="text-align:right;">
						<span class="label label-inverse">Subject:</span>
					</div>
					<div class="span10">
						<input type="text" id="subject" class="span6" name="subject" value="" placeholder="Subject:" />
					</div>
				</div>
				<div class="row control-group" id="msgfield">
					<div class="span2" style="text-align:right;">
						<span class="label label-inverse">Message:</span>
					</div>
					<div class="span10">
						<textarea name="msgbody" id="msgbody" class="span8" rows="6" cols="200" placeholder="Message:"></textarea><br/>
						<label for="html" class="checkbox inline"><input type="checkbox" name="html" value="" />HTML</label>
					</div>
				</div>
				</fieldset>

				<fieldset>
					<legend>Attachments</legend>
					<div class="row control-group" id="attachfield">
						<div class="span10">
							<input class="btn" type="file" id="attachfile1" name="attachfile1"><br/>
							<input class="btn" type="file" id="attachfile2" name="attachfile2"><br/>
							<input class="btn" type="file" id="attachfile3" name="attachfile3">
						</div>
					</div>
				</fieldset>

				<fieldset>
					<legend>Server details</legend>
					<div class="row control-group" id="serverfield">
						<div class="span2" style="text-align:right;">
							<span class="label label-inverse">SMTP server:</span>
						</div>
						<div class="span10">
							<input type="text" id="smtp_server" name="smtp_server" value="#variables.smtp_server#" placeholder="SMTP server name" /><br/>
						</div>

						<div class="span2" style="text-align:right;">
							<span class="label label-inverse">SMTP username::</span>
						</div>
						<div class="span10">
							<input type="text" id="smtp_username" name="smtp_username" value="#variables.smtp_username#" placeholder="SMTP username" /><br/>
						</div>
						<div class="span2" style="text-align:right;">
							<span class="label label-inverse">SMTP password::</span>
						</div>
						<div class="span10">
							<input type="text" id="smtp_password" name="smtp_password" value="#variables.smtp_password#" placeholder="SMTP password" />
						</div>
					</div>
				</fieldset>

				<br/><br/>
				<div class="row">
					<div class="span10">
						<label for="justtesting" class="checkbox inline"><input type="checkbox" name="justtesting" value="" checked />Just Testing!</label>
					</div>
				</div>
				<br/>
				<div class="row">
					<div class="span4"></div>
					<div class="span8">
						<input class="btn btn-primary" type="submit" id="sendemail" name="sendemail" value="Send" />
					</div>
				</div>
			</form>
		</div>
	</cfoutput>

</cfif>
