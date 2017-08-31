<!DOCTYPE html>
<html>
<head>

<link rel=StyleSheet href="../CalStyle.css" type="text/css" />
<title>Therapy Schedules Administration-Staff</title>
	<script src="https://ccp1.msj.org/scripts/jquery/jquery-ui-1.12.1.custom/external/jquery/jquery.js"></script>
	<script src="https://ccp1.msj.org/scripts/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
	<link  href="https://ccp1.msj.org/scripts/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.css"  rel="stylesheet"/>

<script>
	$(document).ready(function() {
		$("#IsTherapist").click(function(){
				$("#facil").show();
		});	
		$("#IsFullAdmin").click(function(){
				$("#facil").hide();
		});
		if ($("#IsTherapist").is(':checked')){
			$("#facil").show();
		}else{
			$("#facil").hide();
		}
		
	});
</script>

<style>
	th {
		background-color:#90b3e1;
		padding:3px;
		width:300px;
	}
	td {
		border:1px solid #90b3e1;
		padding:3px;
	}
</style>

</head>

<body>

<center>
<!--- Second time through: add  --->
<cfif IsDefined("Form.subm")><!--- <cfdump var="#form#"><cfabort>--->
	<cfif NOT IsDefined("StaffType")>
			<script>
				alert("No Type Selected");
				window.history.back();
			</script>
			<cfabort>
	<cfelseif Form.StaffType EQ "IsTherapist">
		<cfif Form.Facility EQ "">
			<script>
				alert("No Facility Selected");
				window.history.back();
			</script>
			<cfabort>			
		<cfelse>
			<cfquery name="reins" datasource="intranet-cal">	
				INSERT INTO TherapyTherapists
				(BadgeNum,Name,Facility)
				VALUES
				('#Form.BadgeNum#','#Form.Name#','#Form.Facility#')
			</cfquery>	
		</cfif>
	</cfif>
	<cfif Form.StaffType EQ "IsFullAdmin">
		<cfquery name="reins" datasource="intranet-cal">	
			INSERT INTO TherapyAdmins
			(BadgeNum,Name)
			VALUES
			('#Form.BadgeNum#','#Form.Name#')
		</cfquery>	
	</cfif>

	<script>
		document.location="EditTherapists.cfm";
	</script>
	<cfabort>
<!--- First time through--->
<cfelse>


</cfif>

<cfquery name="listFacility" datasource="intranet-cal">
	SELECT ID, Description
	FROM TherapyFacilities
	 ORDER BY Description
</cfquery>

	<table>
	<tr><td width="500" style="background-color:#3674c4;border:1px solid black;" align="center">
	<span style=""><h2>Add New Staff</h2></span>
	</td></tr>
	</table>


<cfform method="POST" action="AddStaff.cfm" name="addform"> 
<table>
<tr>
<th>Employee ID</th>
<td>
<cfinput type="Text" name="BadgeNum" size="10" MAXLENGTH="15" required>
</td>
</tr><tr>
<th>Name (Last, First)</th>
<td>
<cfinput type="Text" name="Name" size="25" MAXLENGTH="50" required>
</td>

<tr>
<th>This employee is Full Admin</th>
<td>
<input type="radio" name="stafftype" value="IsFullAdmin" id="IsFullAdmin">
</td>
</tr>
    
<tr>
<th>This employee is a Therapist</th>
<td>
<input type="radio" name="stafftype" value="IsTherapist" id="IsTherapist">
</td>
</tr>

</table>

<div id="facil">
    <table>
    <tr>
    <th>Facility</th>
    <td>
	<cfselect name="Facility">
		<option value="" >Choose Facility</option>
		<cfoutput query="listFacility">
				<option value="#ID#" >#Description#</option>
		</cfoutput>
	</cfselect>

    </td>
    </tr>
    </table>
</div>


<cfinput type="submit" name="subm" value="Add">

</cfform>

</center>

</body>
</html>