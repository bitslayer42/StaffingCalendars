<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Facility List</title>
<link rel=StyleSheet href="../CalStyle.css" type="text/css" />
<!--- polyfill for IE colorpicker--->
<script src='lib/spectrum.js'></script>
<link rel='stylesheet' href='lib/spectrum.css' />

<cfquery name="ckadmin" datasource="intranet-cal">
	SELECT * FROM TherapyAdmins
	WHERE BadgeNum = '#CLIENT.EMPID#'
</cfquery>
<cfif ckadmin.RecordCount EQ 0>
	<center>
    <br /><br />
	You are not set up as a calendar administrator.<br />
	<span style=" font-size:12px;">
        <a href="../Calendar.cfm"> << Return to Calendar </a><br />
    </span>
	</center>
    <cfabort>
</cfif>   

<cfif IsDefined("FORM.AddID")>
	<cfquery name="insert" datasource="intranet-cal">
		INSERT INTO TherapyFacilities (Description,Color)
		VALUES (
		'#Description#',
		'#Color#'
		)
	</cfquery>
</cfif>

<cfif IsDefined("url.DelID")>
	<cfquery name="del" datasource="intranet-cal">
		delete TherapyFacilities
		where ID = '#url.DelID#';
	</cfquery>
</cfif>

<cfquery name="list" datasource="intranet-cal">
	select ID,Description,Color
	from TherapyFacilities
	ORDER BY Description
</cfquery>

</head>
<body>

<center>
<br /><br />

<table>
<tr><td width="400" style="background-color:#e7efef;border:1px solid black;" align="center">
<span style=""><h2>Therapy Schedules Administration</h2><h1>Facility List</h1></span>
</td></tr>
</table>


<p>
<a href="AdminMain.cfm">Return to Admin Menu</a>
</p>

<table cellpadding="2" cellspacing="0" width="600" border="1">
<tr>
<td>
<font style="color:black;font-weight:bold;">Description</font>
</td>
<td>
<font style="color:black;font-weight:bold;">Color</font>
</td>
<td>&nbsp;
</td>
</tr>

<cfform method="POST" action="EditFacilities.cfm" name="addform"> 
<tr>
<td>
<cfinput type="Text" name="Description" size="40" MAXLENGTH="1000">
</td>
<td>
<input type="color" name="Color">
</td>
<td>
<cfinput type="hidden" name="AddID">
<INPUT type="submit" value="  Add  ">
</td>
</tr>
</cfform>

<cfoutput query="list">
<tr>
<td>
#Description# 
</td>
<td style="background-color:#Color#;">
<span style="color:white">#Color# &nbsp;</span>
</td>
<td align="right">
   
<a href="./EditFacilities.cfm?DelID=#ID#"  style=" font-size:12px"
onClick="javascript:return confirm('Would you like to delete the Facility #Description#?')">Delete</a>
    
</td>
</tr>
</cfoutput>
</table>

</center>
</body>
</html>