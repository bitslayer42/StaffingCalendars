<!DOCTYPE html>
<html>
<head>

<title>Therapy Schedules Administration-Edit Individual Day</title>
<link rel=StyleSheet href="../CalStyle.css" type="text/css" />
	<script src="https://ccp1.msj.org/scripts/jquery/jquery-ui-1.12.1.custom/external/jquery/jquery.js"></script>
	<script src="https://ccp1.msj.org/scripts/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
	<link  href="https://ccp1.msj.org/scripts/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.css"  rel="stylesheet"/>

<script>
function delday(schid,empid,thedate){
		$.ajax({ 
			url: 'EditIndivSched.cfm',
			data: {DelID : schid, EmpID : empid, TheDate : thedate},
			type: 'POST',
			error: errFunc,
			success: function(data) {
				document.location = '../Calendar.cfm';
			}
		});
}	
function editday(schid,empid,thedate){
		var start = $("#StartTime").val();
		var end   = $("#EndTime").val();
		$.ajax({ 
			url: 'EditIndivSched.cfm',
			data: {EditID : schid, EmpID : empid, TheDate : thedate, ChangedStartTime : start, ChangedEndTime : end },
			type: 'POST',
			error: errFunc,
			success: function(data) {
				document.location = '../Calendar.cfm';
			}
		});
}
function errFunc(xhr, status, error) {
	alert(xhr.responseText);
}
</script>

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

<cfif IsDefined("form.EditID")>
	<cfquery name="insert" datasource="intranet-cal">
		DELETE FROM TherapyScheduleExceptions
		WHERE ScheduleID = '#form.EditID#'
		AND   EmployeeID = '#form.EmpID#'
		AND   TheDate    = '#form.TheDate#'
		INSERT INTO TherapyScheduleExceptions
		(ScheduleID,EmployeeID,TheDate,ChangedStartTime,ChangedEndTime,Deleted)
		VALUES (
			'#form.EditID#',
			'#form.EmpID#',
			'#form.TheDate#',
			'#form.ChangedStartTime#',
			'#form.ChangedEndTime#',
			NULL			
		)
	</cfquery>
	<cfabort>
<cfelseif IsDefined("form.DelID")>
	<cfquery name="del" datasource="intranet-cal">
		DELETE FROM TherapyScheduleExceptions
		WHERE ScheduleID = '#form.DelID#'
		AND   EmployeeID = '#form.EmpID#'
		AND   TheDate    = '#form.TheDate#'	
		INSERT INTO TherapyScheduleExceptions
		(ScheduleID,EmployeeID,TheDate,ChangedStartTime,ChangedEndTime,Deleted)
		VALUES (
			'#form.DelID#',
			'#form.EmpID#',
			'#form.TheDate#',
			NULL,
			NULL,
			1		
		)
	</cfquery>
	<cfabort>
</cfif>

<cfquery name="getstaffinfo" datasource="intranet-cal">
	SELECT EmployeeID, Name, Description FacDescrip
	FROM TherapyTherapists
	INNER JOIN TherapyFacilities
	ON TherapyTherapists.Facility = TherapyFacilities.ID
	WHERE EmployeeID = '#form.empid#'
</cfquery>
<cfquery name="getSched" datasource="intranet-cal">
	SELECT 
	CASE WHEN excp.ScheduleID IS NOT NULL THEN 1 ELSE 0 END AS AlteredSched, 
	CASE WHEN ChangedStartTime IS NOT NULL THEN ChangedStartTime ELSE StartTime END AS StartTime, 
	CASE WHEN ChangedEndTime IS NOT NULL THEN ChangedEndTime ELSE EndTime END AS EndTime
	FROM TherapySchedules sched 
	LEFT JOIN TherapyScheduleExceptions excp
	ON sched.ID = excp.ScheduleID
	WHERE sched.ID = '#form.schid#'
</cfquery>

</head>

<body>
<center>
<br /><br />
<cfoutput query="getstaffinfo">
<table>
<tr><td width="400" style="background-color:##e7efef;border:1px solid black;" align="center">
<span style="">
<h2>Therapy Schedules Administration</h2><h1>Edit Individual Day</h1>
<h2 style="color:orange;">#Name#</h2><h2>#FacDescrip#</h2>
</span>
</td></tr>
</table>

<p>
<a href="../Calendar.cfm">Return to Calendar</a><br>
<a href="AdminMain.cfm">Return to Admin Menu</a>
</p>
<p style="width:500px;text-align:left;">
Use this screen to edit or delete a single date of someone's schedule.<br>
To edit a repeating schedule, go 
<a href="Schedule.cfm?id=#form.empid#">here</a>
</p>
</cfoutput>

<table cellpadding="2" cellspacing="1" border="1">
<tr>
<cfoutput query="getSched">
	<cfform name="theform" method="POST" action="EditIndivSched.cfm">
	<tr>
	<td>
		#DateFormat(form.dt,"ddd mm/dd/yyyy")#
	</td>
	<td>
		Start time:<cfinput type="text" validateAt="onBlur" validate="time" name="StartTime" id="StartTime" 
					size="10" value="#TimeFormat(StartTime)#">
	</td>
	<td>
		End time:<cfinput type="text" validateAt="onBlur" validate="time" name="EndTime" id="EndTime" 
					size="10"  value="#TimeFormat(EndTime)#">
	</td>
	</tr>
	<tr>
	</cfform>
	<td colspan="3" align="center">
		<cfif AlteredSched EQ 1>
			Schedule has been altered<br>
		</cfif>
		<button onclick="delday('#form.schid#','#form.empid#','#DateFormat(form.dt,'yyyy-mm-dd')#')">Delete this day</button>
		<button onclick="editday('#form.schid#','#form.empid#','#DateFormat(form.dt,'yyyy-mm-dd')#')">Save changes to times</button>
	</td>	
</cfoutput>
</tr>
</table>	
</body>
</html>







