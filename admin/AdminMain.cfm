<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel=StyleSheet href="../CalStyle.css" type="text/css" />
<title>Therapy Schedules Administration</title>

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
     
</head>

<body>
<!---	<span style=" position:absolute; top:20; left:20; font-size:12px;">
        <a href="../Calendar.cfm"> << Return to Calendar </a><br />
    </span>
    <br clear="all" /> --->

<center>

<table>
<tr><td width="400" style="background-color:#e7efef;border:1px solid black;" align="center">
<span style=""><h2>Therapy Schedules Administration</h2></span>
</td></tr>
</table>

<table>

    <tr>
    <th ><a href="EditTherapists.cfm">Staff and Schedules</a></th>
    </tr>
    <tr>
	<th ><a href="EditFacilities.cfm">Facilities</a></th> 
	</tr>    


</table>
<br />
<a href="../Calendar.cfm">Return to Calendar</a>
</center>
</body>
</html>
