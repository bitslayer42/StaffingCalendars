<!DOCTYPE html>
<html>
<head>


<title>Therapy Schedules Administration-Staff</title>
<link rel=StyleSheet href="../CalStyle.css" type="text/css" />

	<script src="https://ccp1.msj.org/scripts/jquery/jquery-ui-1.12.1.custom/external/jquery/jquery.js"></script>
	<script src="https://ccp1.msj.org/scripts/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
	<link  href="https://ccp1.msj.org/scripts/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.css"  rel="stylesheet"/>

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
		background-color:#6898d6;
		padding:3px;
	}
	td {
		background-color:#90b3e1;
		border:1px solid #4d85cf;
		padding:0px 20px;
		height:55px;
		text-align:center;
	}
</style>

<cfif IsDefined("FORM.AddEmployeeID")>
	<!---<cfdump var="#form#"><cfoutput>#DateFormat(Now(),"yyyy-mm-dd")#</cfoutput> <cfabort> --->

    <cfquery name="insert" datasource="intranet-cal">
    INSERT INTO TherapySchedules(EmployeeID,StartDate,EndDate,NoEndDate
	,StartTime,EndTime,DayOfWeek,OverlapCount)
	VALUES (
	'#form.AddEmployeeID#',
	'#form.StartDate#',
	<cfif form.EndDate EQ "">
		NULL,
		1,
	<cfelse>
		'#form.EndDate#',
		0,
	</cfif>
	'#form.StartTime#',
	'#form.EndTime#',
	'#form.DayOfWeek#',
	1
	)
    </cfquery>
	<script>
	document.location="ScheduleWithDates.cfm?id=<cfoutput>#url.id#</cfoutput>";
	</script>
	<cfabort>	
</cfif>

<cfif IsDefined("url.DelID")>
    <cfquery name="del" datasource="intranet-cal">
        DELETE FROM TherapySchedules
		WHERE ID = '#url.DelID#';
    </cfquery>
	<script>
	document.location="ScheduleWithDates.cfm?id=<cfoutput>#url.id#</cfoutput>";
	</script>
	<cfabort>
</cfif>
<cfquery name="getstaffinfo" datasource="intranet-cal">
	SELECT EmployeeID, Name, Description FacDescrip
	FROM TherapyTherapists
	INNER JOIN TherapyFacilities
	ON TherapyTherapists.Facility = TherapyFacilities.ID
	WHERE EmployeeID = '#url.id#'
</cfquery>
<cfquery name="list" datasource="intranet-cal">
	DECLARE @DayStart TIME = '06:30:00'
	DECLARE @DayEnd   TIME = '19:00:00'

	SELECT Days.*, ts.*,
	DATEDIFF(mi,@DayStart,StartTime)*100.0/datediff(mi,@DayStart,@DayEnd) AS StartPcnt,
	DATEDIFF(mi,StartTime,EndTime)*100.0/datediff(mi,@DayStart,@DayEnd) AS EndPcnt
	FROM (
		SELECT 1 DOW UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
	) AS Days
	LEFT JOIN (
		SELECT ID,EmployeeID,StartDate,EndDate,NoEndDate,StartTime,EndTime,DayOfWeek
		FROM TherapySchedules
		WHERE EmployeeID = '#url.id#'
	) AS ts
	ON DOW = DayOfWeek 
</cfquery>

	
</head>
<body>

<center>
<br /><br />
<cfoutput query="getstaffinfo">
<table>
<tr><td width="800" style="background-color:##e7efef;border:1px solid black;" align="center">
<span style="">
<h2>Therapy Schedules Administration</h2><h1>Edit Schedules</h1>
<h2 style="color:orange;">#Name#</h2><h2>#FacDescrip#</h2>
</span>
</td></tr>
</table>

<p>
<a href="../Calendar.cfm">Return to Calendar</a><br>
<a href="EditTherapists.cfm">Return to Staff List</a>
</p>
<a href="Schedule.cfm?id=#url.id#">Hide Start/End Dates</a>
</cfoutput>
<table cellpadding="2" cellspacing="0" border="1">

<tr>
<th width="140">
Start Date
</th>
<th width="140">
End Date
</th>
<th>
Day of Week
</th>
<th width="662">
Start/End Time
</th>
<th width="130">&nbsp;
</th>
</tr>

<cfoutput query="list">
	<tr>
	<td id="startdate#DOW#">
		#DateFormat(StartDate,"MM/DD/YYYY")#
	</td>
	<td id="enddate#DOW#">
		<cfif NoEndDate EQ 1>
			No end date
		<cfelse>
			#DateFormat(EndDate,"MM/DD/YYYY")#
		</cfif>	
	</td>
		<td>
		<cfif #DOW# EQ 1>Sun</cfif>
		<cfif #DOW# EQ 2>Mon</cfif>
		<cfif #DOW# EQ 3>Tues</cfif>
		<cfif #DOW# EQ 4>Wed</cfif>
		<cfif #DOW# EQ 5>Thurs</cfif>
		<cfif #DOW# EQ 6>Fri</cfif>
		<cfif #DOW# EQ 7>Sat</cfif>
		</td>
	<td id="sch#DOW#">
	<cfif ID NEQ "">
		<div class="scheduled" style="left:#StartPcnt#%; width: #EndPcnt#%;background-color:##2a5c9d">
			#TimeFormat(StartTime,"HH:MM")# #TimeFormat(EndTime,"HH:MM")#
		</div>
	</cfif>
	</td>

	<td id="but#DOW#">
	<cfif ID EQ "">
		<button onclick="addslider('#DOW#');">  Add...  </button>
	<cfelse>
		<a href="./ScheduleWithDates.cfm?id=#EmployeeID#&DelID=#ID#"  style=" font-size:12px"
		onClick="javascript:return confirm('Would you like to delete this schedule?')">Delete</a>	</cfif>
	</td>
	</tr>
</cfoutput>
</table>

</center>

<cfform id="addform" method="POST" action="ScheduleWithDates.cfm?id=#url.id#">
	<cfinput type="hidden" name="AddEmployeeID" value="#url.id#">
	<cfinput type="hidden" name="DayOfWeek" id="DayOfWeek">
	<cfinput type="hidden" name="StartTime" id="StartTime">
	<cfinput type="hidden" name="EndTime" id="EndTime">		
	<cfinput type="hidden" name="StartDate" id="StartDate">
	<cfinput type="hidden" name="EndDate" id="EndDate">		
</cfform>

<script>

	
	
function addslider(dow){
	if( $("#DayOfWeek").val() == "" ) {
		$("#DayOfWeek").val(dow);
		$("#but"+dow).html("<a href='#' onclick='savevalsiframe()'>Save</a> &nbsp; " + 
						   "<a href='#' onclick='cancelAdd();'>Cancel</a>");
		$("#sch"+dow).html("<iframe id='theframe' src='ScheduleSlider.cfm' width='620px' height='50px' frameborder='0' scrolling='no'></iframe>");
		$("#startdate"+dow).html("<input type='Text' id='PictStartDate' size='8'>");
		$("#enddate"+dow).html("<input type='checkbox' id='PictIncludeEndDate' value='notsel' onclick='includeenddate("+dow+")'>Include<br>End Date");
		$("#PictStartDate").datepicker({ duration: '' });
		
	}else{
		alert("Save or Cancel other date first.");
	}
}
function includeenddate(dow) {
	$("#enddate"+dow).html("<input type='Text' id='PictEndDate' size='8'>");
	$("#PictEndDate").datepicker({ duration: '' });
}
<!---
<input type='Text' name='StartDate'>
<input type='Text' name='EndDate'>
<input type='checkbox' name='NoEndDate'>
--->
function savevalsiframe(){
	document.getElementById("theframe").contentWindow.savevalsdates();
}
function cancelAdd(){
	location.reload();
}
</script>

</body>
</html>