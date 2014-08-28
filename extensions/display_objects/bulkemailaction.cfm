
<cfparam name="form.smtp_server" default="#variables.smtp_server#" />
<cfparam name="form.smtp_username" default="#variables.smtp_username#" />
<cfparam name="form.smtp_password" default="#variables.smtp_password#" />


<cffunction name="CSVToArray" access="public" returntype="array" output="false" hint="Takes a CSV file or CSV data value and converts it to an array of arrays based on the given field delimiter. Line delimiter is assumed to be new line / carriage return related.">
 		<!--- Define arguments. --->
		<cfargument name="File" type="string" required="false" default="" hint="The optional file containing the CSV data." />
	 	<cfargument name="CSV" type="string" required="false" default="" hint="The CSV text data (if the file was not used)." />
		<cfargument name="Delimiter" type="string" required="false" default="," hint="The data field delimiter." />
	 	<cfargument name="Trim" type="boolean" required="false" default="true" hint="Flags whether or not to trim the END of the file for line breaks and carriage returns." />
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		<!---
			Check to see if we are using a CSV File. If so,
			then all we want to do is move the file data into
			the CSV variable. That way, the rest of the algorithm
			can be uniform.
		--->
		<cfif Len( ARGUMENTS.File )>
			<!--- Read the file into Data. --->
			<cffile action="read" file="#ARGUMENTS.File#" variable="ARGUMENTS.CSV" />
	 	</cfif>
		<!---
			ASSERT: At this point, no matter how the data was
			passed in, we now have it in the CSV variable.
		--->
		<!---
			Check to see if we need to trim the data. Be default,
			we are going to pull off any new line and carraige
			returns that are at the end of the file (we do NOT want
			to strip spaces or tabs).
		--->
		<cfif ARGUMENTS.Trim>
			<!--- Remove trailing returns. --->
			<cfset ARGUMENTS.CSV = REReplace(ARGUMENTS.CSV, "[\r\n]+$", "", "ALL") />
	 	</cfif>
		<!--- Make sure the delimiter is just one character. --->
		<cfif (Len( ARGUMENTS.Delimiter ) NEQ 1)>
			<!--- Set the default delimiter value. --->
			<cfset ARGUMENTS.Delimiter = "," />
		</cfif>

		<!---
			Create a compiled Java regular expression pattern object
			for the experssion that will be needed to parse the
			CSV tokens including the field values as well as any
			delimiters along the way.
		--->
		<cfset LOCAL.Pattern = CreateObject(
			"java",
			"java.util.regex.Pattern"
			).Compile(
				JavaCast(
					"string",
					<!--- Delimiter. --->
					"\G(\#ARGUMENTS.Delimiter#|\r?\n|\r|^)" &
					<!--- Quoted field value. --->
					"(?:""([^""]*+(?>""""[^""]*+)*)""|" &
					<!--- Standard field value --->
					"([^""\#ARGUMENTS.Delimiter#\r\n]*+))"
					)
				)
			/>

		<!---
			Get the pattern matcher for our target text (the
			CSV data). This will allows us to iterate over all the
			tokens in the CSV data for individual evaluation.
		--->
		<cfset LOCAL.Matcher = LOCAL.Pattern.Matcher(
			JavaCast( "string", ARGUMENTS.CSV )
			) />


		<!---
			Create an array to hold the CSV data. We are going
			to create an array of arrays in which each nested
			array represents a row in the CSV data file.
		--->
		<cfset LOCAL.Data = ArrayNew( 1 ) />

		<!--- Start off with a new array for the new data. --->
		<cfset ArrayAppend( LOCAL.Data, ArrayNew( 1 ) ) />


		<!---
			Here's where the magic is taking place; we are going
			to use the Java pattern matcher to iterate over each
			of the CSV data fields using the regular expression
			we defined above.

			Each match will have at least the field value and
			possibly an optional trailing delimiter.
		--->
		<cfloop condition="LOCAL.Matcher.Find()">

			<!---
				Get the delimiter. We know that the delimiter will
				always be matched, but in the case that it matched
				the START expression, it will not have a length.
			--->
			<cfset LOCAL.Delimiter = LOCAL.Matcher.Group(
				JavaCast( "int", 1 )
				) />
			<!---
				Check for delimiter length and is not the field
				delimiter. This is the only time we ever need to
				perform an action (adding a new line array). We
				need to check the length because it might be the
				START STRING match which is empty.
			--->
			<cfif (
				Len( LOCAL.Delimiter ) AND
				(LOCAL.Delimiter NEQ ARGUMENTS.Delimiter)
				)>
				<!--- Start new row data array. --->
				<cfset ArrayAppend(
					LOCAL.Data,
					ArrayNew( 1 )
					) />
			</cfif>
			<!---
				Get the field token value in group 2 (which may
				not exist if the field value was not qualified.
			--->
			<cfset LOCAL.Value = LOCAL.Matcher.Group(
				JavaCast( "int", 2 )
				) />
			<!---
				Check to see if the value exists. If it doesn't
				exist, then we want the non-qualified field. If
				it does exist, then we want to replace any escaped
				embedded quotes.
			--->
			<cfif StructKeyExists( LOCAL, "Value" )>
				<!---
					Replace escpaed quotes with an unescaped double
					quote. No need to perform regex for this.
				--->
				<cfset LOCAL.Value = Replace(
					LOCAL.Value,
					"""""",
					"""",
					"all"
					) />
			<cfelse>
				<!---
					No qualified field value was found, so use group
					3 - the non-qualified alternative.
				--->
				<cfset LOCAL.Value = LOCAL.Matcher.Group(
					JavaCast( "int", 3 )
					) />
			</cfif>
			<!--- Add the field value to the row array. --->
			<cfset ArrayAppend(
				LOCAL.Data[ ArrayLen( LOCAL.Data ) ],
				LOCAL.Value
				) />

		</cfloop>
		<!---
			At this point, our array should contain the parsed
			contents of the CSV value. Return the array.
		--->
		<cfreturn LOCAL.Data />
	</cffunction>


	<cfset BccList = "" />

	<cfif StructkeyExists(form, "attachbcc") And form.attachbcc Neq "">
		<cffile action="upload"  destination="E:\webpages\JB\uploads\attachbcc.csv" filefield="attachbcc" nameconflict="overwrite">
		<cfset data = CsvToArray(File = 'E:\webpages\JB\uploads\attachbcc.csv') />
		<!--- <cfdump var="#data#" /> --->

		<cfset count = ArrayLen(data) />
		<cfif count Gt 0>
			<cfloop from="2" to="#count#" index="row">
				<cfset email = REReplace(data[row][1], "[\s]+", "", "ALL")>
				<cfset email = REReplace(email, "[,]", ".", "ALL")>
				<cfset BccList = ListAppend(BccList, Trim(email), ";") />
			</cfloop>
		</cfif>
	<cfelse>
		<cfif form.bcc Neq "">
			<cfset BccList = Trim(form.bcc) />
		</cfif>
	</cfif>


	<cfif StructKeyExists(form, "html")>
		<cfset mimetype = "html">
	<cfelse>
		<cfset mimetype = "text">
	</cfif>

	<cfif StructkeyExists(form, "attachfile1") And form.attachfile1 Neq "">
		<cffile action="upload"  destination="E:\webpages\JB\uploads" filefield="attachfile1" nameconflict="makeunique" />
		<cfset attachment_localfile1 = "E:\webpages\JB\uploads\#file.serverfile#" />
	</cfif>
	<cfif StructkeyExists(form, "attachfile2") And form.attachfile2 Neq "">
		<cffile action="upload"  destination="E:\webpages\JB\uploads\" filefield="attachfile2" nameconflict="makeunique" />
		<cfset attachment_localfile2 = "E:\webpages\JB\uploads\#file.serverfile#" />
	</cfif>
	<cfif StructkeyExists(form, "attachfile3") And form.attachfile3 Neq "">
		<cffile action="upload"  destination="E:\webpages\JB\uploads\" filefield="attachfile3" nameconflict="makeunique" />
		<cfset attachment_localfile3 = "E:\webpages\JB\uploads\#file.serverfile#" />
	</cfif>


	<cfset crlf = "#chr(13)##chr(10)#" />

	<cfif StructKeyExists(form, "justtesting")>
		<cfoutput>
			From: #form.from#<br/>
			To: #form.to#<br/>
			CC: #form.cc#<br/>
			BCC: <cfloop list="#BccList#" index="email" delimiters=";"><cfoutput>#email#<br/></cfoutput></cfloop><br/>
			Subject: #form.subject#<br/>
			Message: #form.msgbody#<br/>
		</cfoutput>

		<cfmail from="#Trim(form.from)#"
				to="jake.bourne@wales.nhs.uk"
				cc="#form.cc#"
				subject="#Trim(form.subject)#"
				type="#mimetype#">

#form.msgbody#

From: #form.from#
To: #form.to#
CC: #form.cc#
BCC: <cfloop list="#BccList#" index="email" delimiters=";"><cfoutput>#email#<cfif mimetype Eq "html"><br/><cfelse>#crlf#</cfif></cfoutput></cfloop>

		<cfif StructkeyExists(form, "attachfile1") And form.attachfile1 Neq "">
			<cfsilent>
				<cfmailparam disposition="attachment" file="#attachment_localfile1#" />
			</cfsilent>
		</cfif>
		<cfif StructkeyExists(form, "attachfile2") And form.attachfile2 Neq "">
			<cfsilent>
				<cfmailparam disposition="attachment" file="#attachment_localfile2#" />
			</cfsilent>
		</cfif>
		<cfif StructkeyExists(form, "attachfile3") And form.attachfile3 Neq "">
			<cfsilent>
				<cfmailparam disposition="attachment" file="#attachment_localfile3#" />
			</cfsilent>
		</cfif>

		</cfmail>

	<cfelse>

		<cfloop list="#BccList#" index="email" delimiters=";">

			<cftry>
				<cfmail from="#form.from#"
						to="#email#" cc="#form.cc#" bcc="jake.bourne@wales.nhs.uk"
						subject="#form.subject#"
						type="#mimetype#">
#form.msgbody#

					<cfif StructkeyExists(form, "attachfile1") And form.attachfile1 Neq "">
						<cfsilent>
							<cfmailparam disposition="attachment" file="#attachment_localfile1#" />
						</cfsilent>
					</cfif>
					<cfif StructkeyExists(form, "attachfile2") And form.attachfile2 Neq "">
						<cfsilent>
							<cfmailparam disposition="attachment" file="#attachment_localfile2#" />
						</cfsilent>
					</cfif>
					<cfif StructkeyExists(form, "attachfile3") And form.attachfile3 Neq "">
						<cfsilent>
							<cfmailparam disposition="attachment" file="#attachment_localfile3#" />
						</cfsilent>
					</cfif>

				</cfmail>

				<cfcatch type="any">
					<cfmail from="webteam@wales.nhs.uk" to="jake.bourne@wales.nhs.uk" subject="Error - Formbuilder Bulk Email">
Failed to send email to this recipient: #email#
					</cfmail>
				</cfcatch>
			 </cftry>
		</cfloop>
		<cfoutput>
			<strong>Message has been sent to:-</strong><br/>
			To: #form.to#<br/>
			CC: #form.cc#<br/>
			BCC: #BccList#<br/>
		</cfoutput>
	</cfif>
	<cfabort>
