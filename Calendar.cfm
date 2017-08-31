<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Therapy Schedules</title>

<link rel=StyleSheet href="CalStyle.css" type="text/css" />	


	<script src="./jquery-ui-1.12.1.custom/external/jquery/jquery.js"></script>
	<script src="./jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
	<link  href="./jquery-ui-1.12.1.custom/jquery-ui.min.css"  rel="stylesheet"/>

	
<script type="text/javascript">
$(document).ready(function() {

	$("#CalStart").datepicker({ duration: '' });
	
	$("#NumDaysSlider").slider({ <!---day slider--->
		animate: true,
		value: document.getElementById('NumDays').value,
		min: 1,
		max: 30,
		slide: function(event, ui) {
			$("#NumDays").val(ui.value);
		},
		stop:  function(event, ui) {
			document.chgCal.submit();
		}
	});
	$(".scheduled").click(function() {
		$("#schid").val($(this).attr("data-schid"));
		$("#empid").val($(this).attr("data-empid"));
		$("#dt").val($(this).attr("data-dt"));
		$("#indiv").submit();
	});
});
</script>


<cfif NOT IsDefined("CalStart")>
	<cfset CalStart = Now()>
</cfif>
<cfif NOT IsDefined("form.NumDays")>
	<cfset form.NumDays = "7"> 
</cfif>
<cfif NOT IsDefined("form.FacilityCode")>
	<cfset form.FacilityCode = "0"> 
</cfif>

<cfquery name="admin" datasource="intranet-cal">
	SELECT * FROM TherapyAdmins
	WHERE BadgeNum = '#CLIENT.EMPID#'
</cfquery>
<cfif admin.RecordCount GT 0>
	<cfset IsAdmin = 1>
<cfelse>
	<cfset IsAdmin = 0>    
</cfif>

<cfstoredproc procedure="TherapySchedsThisWeek" datasource="intranet-cal">
	<cfprocparam type="in" value="#CalStart#" null="no" cfsqltype="cf_sql_date">
	<cfprocparam type="in" value="#NumDays#" null="no" cfsqltype="cf_sql_tinyint">
	<cfprocparam type="in" value="#FacilityCode#" null="no" cfsqltype="cf_sql_int">
	<cfprocresult name="datelist" resultset="1">
	<cfprocresult name="cal" resultset="2">
</cfstoredproc>
<cfquery name="listFacility" datasource="intranet-cal">
	SELECT ID, Description
	FROM TherapyFacilities
	 ORDER BY Description
</cfquery>

</head>

<body> 

<center>
<form id="indiv" action="admin/EditIndivSched.cfm" method="post"><!---rewrite as ajax?---> 
	<input id="schid" name="schID" type="hidden">
	<input id="empid" name="empID" type="hidden">
	<input id="dt"    name="dt"    type="hidden">
</form>
<div style="font-family:Palatino Linotype;font-variant:small-caps;font-weight:bold;font-size:1.6em;">Regional Therapy Schedules</div>
<br />
<cfif IsAdmin>
    <div style="border-radius:5px;background-color:#d90c4c;width:60px;padding:5px;">
		<button onclick="document.location='admin/AdminMain.cfm'">Admin</button>
    </div>
</cfif><br>
<a href="../home.cfm" class="regularlinks"><font style="font-size:0.8em"><< Main Intranet Menu</font></a> 
</center>

<!---controls--->    
<span class="controls">
	<cfform name="chgCal" action="Calendar.cfm" method="post">
	<table cellpadding="5" style="border:1px solid #111100; background-color:#e7efef;" width="100%">
	<tr><td> 
	Facility
	<cfselect id="FacilityCode" name="FacilityCode" onChange="document.chgCal.submit();">
		<option value="0" >ALL Facilities</option>
		<cfoutput query="listFacility">
			<cfif #form.FacilityCode# EQ #ID#>
				<option value="#ID#" selected="selected">#Description#</option>
			<cfelse>
				<option value="#ID#" >#Description#</option>
			</cfif>		
			
		</cfoutput>
	</cfselect>
	</td><td>

	View Calendar Starting Date: <cfinput name="CalStart" id="CalStart" type="text" value="#DateFormat(CalStart,'MM/DD/YYYY')#" size="10" 
	onChange="document.chgCal.submit();" validate="date" message="Date Format Incorrect">
	</td><td>
	View # Days: 
	<cfselect id="NumDays" name="NumDays" onChange="document.chgCal.submit();">
		<cfloop from="1" to="30" index="numd">
			<cfif #form.NumDays# EQ #numd#>
				<cfoutput><option value="#numd#" selected="selected" >#numd#</option></cfoutput>
			<cfelse>
				<cfoutput><option value="#numd#" >#numd#</option></cfoutput>
			</cfif>
		</cfloop>
	</cfselect>
	<div id="NumDaysSlider"></div>
	</td>
	</tr>           
	</table>
	</cfform>
</span>

<cfif IsAdmin>
<cfif cal.RecordCount EQ 0>
<br><br><br><br><br>
<div style="text-align:center;">
Click "Admin" above to add staff
</div>
</cfif>
</cfif>
<!---calendar body--->
<cfoutput query="cal" group="facilID">
	<div class="arow" style="text-align:left;font-weight:bold;">
		<div class="leftcol">#Facility#</div>
		<cfloop query="datelist"><!---calendar date headers--->
				<cfif #DOW# EQ 1 OR #DOW# EQ 7>
					<div class="awknd header" >
				<cfelse>
					<div class="aday header" >
				</cfif>
				<div>#DateFormat(TheDate,"M/D ddd")#</div>
			</div>
		</cfloop>
	</div>
	<cfoutput group="StaffName">
		<div class="arow" style="background-color:###Color#">
		<div class="leftcol tooltip">
			<a href="admin/Schedule.cfm?id=#EmployeeID#">#StaffName#</a>
			<span class="tooltiptext">Click to schedule</span>
		</div>
		<cfoutput group="TheDate">
			<cfif #DOW# EQ 1 OR #DOW# EQ 7>
				<div class="awknd" >
			<cfelse>
				<div class="aday" >
			</cfif>
			<cfoutput>
				<cfif schedID NEQ "">
					
					<div data-schid="#schedID#" data-empid="#EmployeeID#" data-dt="#DateFormat(TheDate,'yyyy-mm-dd')#" 
					class="scheduled" style="left:#StartPcnt#%; width: #EndPcnt#%;background-color:#Color#">
						#TimeFormat(StartTime,"HH:MM")# #TimeFormat(EndTime,"HH:MM")#
					</div>

				</cfif>
			</cfoutput>
		</div>
		</cfoutput>    
		</div>
	</cfoutput>
</cfoutput>
<br />

</body>
</html>
