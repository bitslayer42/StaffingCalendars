
$(document).ready(function() {
	$("#slider-range").slider({
		range: true,
		min: 390,  // 6:30am
		max: 1140, // 7:00pm (1440 is the whole day)
		step: 30,
		values: [1140, 1140],
		slide: function (e, ui) {
			var hours1 = Math.floor(ui.values[0] / 60);
			var minutes1 = ui.values[0] - (hours1 * 60);

			if (hours1.length == 1) hours1 = '0' + hours1;
			if (minutes1.length == 1) minutes1 = '0' + minutes1;
			if (minutes1 == 0) minutes1 = '00';
			if (hours1 >= 12) {
				if (hours1 == 12) {
					hours1 = hours1;
					minutes1 = minutes1 + " PM";
				} else {
					hours1 = hours1 - 12;
					minutes1 = minutes1 + " PM";
				}
			} else {
				hours1 = hours1;
				minutes1 = minutes1 + " AM";
			}
			if (hours1 == 0) {
				hours1 = 12;
				minutes1 = minutes1;
			}



			$('#slider-starttime').html(hours1 + ':' + minutes1);

			var hours2 = Math.floor(ui.values[1] / 60);
			var minutes2 = ui.values[1] - (hours2 * 60);

			if (hours2.length == 1) hours2 = '0' + hours2;
			if (minutes2.length == 1) minutes2 = '0' + minutes2;
			if (minutes2 == 0) minutes2 = '00';
			if (hours2 >= 12) {
				if (hours2 == 12) {
					hours2 = hours2;
					minutes2 = minutes2 + " PM";
				} else if (hours2 == 24) {
					hours2 = 11;
					minutes2 = "59 PM";
				} else {
					hours2 = hours2 - 12;
					minutes2 = minutes2 + " PM";
				}
			} else {
				hours2 = hours2;
				minutes2 = minutes2 + " AM";
			}

			$('#slider-endtime').html(hours2 + ':' + minutes2);
		}
	});
	
});
function savevals(){
	var StartTime = parent.document.getElementById("StartTime");
	var EndTime = parent.document.getElementById("EndTime");
	var sliderstart = document.getElementById("slider-starttime").innerHTML;
	var sliderend = document.getElementById("slider-endtime").innerHTML;
	if(sliderstart==sliderend){
		alert("Start Time can't equal End Time");
	}else{
		StartTime.value = sliderstart;
		EndTime.value = sliderend;
		var theaddform = parent.document.getElementById("addform");
		theaddform.submit();
	}
	
}
function savevalsdates(){
	var StartTime = parent.document.getElementById("StartTime");
	var EndTime = parent.document.getElementById("EndTime");
	var sliderstart = document.getElementById("slider-starttime").innerHTML;
	var sliderend = document.getElementById("slider-endtime").innerHTML;
	
	var StartDate = parent.document.getElementById("StartDate");
	var EndDate = parent.document.getElementById("EndDate");
	
	var PictStartDate = parent.document.getElementById("PictStartDate");
	var PictEndDate = parent.document.getElementById("PictEndDate");	
	var PictIncludeEndDate = parent.document.getElementById("PictIncludeEndDate");
	
	if(sliderstart==sliderend){
		alert("Start Time can't equal End Time");
		return;
	}else if(PictStartDate.value == null||PictStartDate.value == ""){
		alert("Start Date is required");
		return;
	}else{
		StartTime.value = sliderstart;
		EndTime.value = sliderend;
		StartDate.value = PictStartDate.value;
		if (PictIncludeEndDate == null){ //has end date
			if(PictEndDate.value == null||PictEndDate.value == ""){
				alert("End Date is required");
				return;
			}else{
				EndDate.value = PictEndDate.value;
			}
		}
	}
	var theaddform = parent.document.getElementById("addform");
	theaddform.submit();
	
}
