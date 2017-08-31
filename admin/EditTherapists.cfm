<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Therapy Schedules Administration-Staff List</title>
<link rel=StyleSheet href="../CalStyle.css" type="text/css" />

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

<style>
th {
	background-color:#90b3e1;
	padding:3px;
}
td {
	border:1px solid #90b3e1;
	padding:3px;
}

</style>
<!--- delete --->
<cfif IsDefined("url.delTher")><!--- delete ther --->
    <cfquery name="del" datasource="intranet-cal">
        delete TherapyTherapists
        where EmployeeID = '#url.delTher#';
        delete TherapySchedules
        where EmployeeID = '#url.delTher#';
		delete TherapyScheduleExceptions
        where EmployeeID = '#url.delTher#';
	</cfquery>
	<script>
	document.location="EditTherapists.cfm";
	</script>
	<cfabort>	
<cfelseif IsDefined("url.delAdmin")><!--- delete admin --->
	<cfquery name="deladmin" datasource="intranet-cal">
		DELETE FROM TherapyAdmins
		WHERE EmployeeID = '#url.delAdmin#'
	</cfquery>
	<script>
	document.location="EditTherapists.cfm";
	</script>
	<cfabort>	
</cfif>
<cfquery name="listAdmin" datasource="intranet-cal">
	SELECT EmployeeID,BadgeNum,Name
	FROM TherapyAdmins
	ORDER BY Name
</cfquery>
<cfquery name="listTherapists" datasource="intranet-cal">
	SELECT EmployeeID,BadgeNum,Name, Facility, Description FacDescrip, Color
	FROM TherapyTherapists
	INNER JOIN TherapyFacilities
	ON TherapyTherapists.Facility = TherapyFacilities.ID
	ORDER BY Description, Name
</cfquery>


</head>
<body>

<center>
<br /><br />

<table>
<tr><td width="400" style="background-color:#e7efef;border:1px solid black;" align="center">
<span style=""><h2>Therapy Schedules Administration</h2><h1>Staff List</h1></span>
</td></tr>
</table>

<p>
<a href="AdminMain.cfm">Return to Admin Menu</a>
</p>

<center>
<table>
<tr><td colspan="7" align="center">
<button onclick="document.location='AddStaff.cfm'">Add New Staff</button>
</td></tr>
<tr><th colspan="3" align="center">
Administrators
</th></tr>	
<tr><th></th>
<th>Num</th>
<th>Name</th>
</tr>

<cfoutput query="listAdmin" group="EmployeeID">
    <tr><td>
    <a href="EditTherapists.cfm?delAdmin=#EmployeeID#">Delete</a>
    </td><td>
        #BadgeNum# 
    </td><td>
        #Name#
    </td></tr>
</cfoutput>

<tr><th colspan="3" align="center">
Therapists
</th></tr>	
<tr><th></th>
<th>Num</th>
<th>Name</th>
</tr>

<cfoutput query="listTherapists" group= "FacDescrip">
	<tr><th colspan="3" align="center"<
		<span style="background-color:#Color#;color:white;">
		#FacDescrip#
		</span>
	</th ></tr>
	<cfoutput>    
		<tr><td>
		<a href="Schedule.cfm?id=#EmployeeID#">Schedule</a>
		<a href="EditTherapists.cfm?delTher=#EmployeeID#">Delete</a>
		</td><td>
			#BadgeNum# 
		</td><td>
			#Name#
		</td></tr>
	</cfoutput>
</cfoutput>

</table>

<a href="AdminMain.cfm">Return to Admin Menu</a>
</center>


</BODY>
</HTML>