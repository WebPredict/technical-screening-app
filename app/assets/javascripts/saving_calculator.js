

var formatMoney = function(n) {
        var c = isNaN(c = Math.abs(c)) ? 2 : c, 
        d = "." , 
        t = t == undefined ? "," : t, 
        s = n < 0 ? "-" : "", 
        i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", 
        j = (j = i.length) > 3 ? j % 3 : 0;
       return '$' + s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
     
}

var formatCandidates = function(num) {
    if (num == 1) {
        return num + ' Candidate';
    }
    return num + " Candidates";
}

var formatMinutes = function(num) {
    if (num == 1) {
        return num + ' Minute';
    }
    return num + ' Minutes';
}

var updateScreeningCost = function(num_candidates, per_hour, time_per_candidate) {
    var time_to_minutes = time_per_candidate / 60; //convert from minutes to hour
    var total_cost = time_to_minutes * per_hour * num_candidates;
    $('#total-screening-cost').html(formatMoney(total_cost) + ' / Month!');
}


$(document).ready(function() {
    var per_hour = 40;
    var time_per_candidate = 45;
     var num_candidates = 20;
     updateScreeningCost(num_candidates, per_hour, time_per_candidate);
    $('#btn-minus_per-hour').click(function(e) {
        e.preventDefault();
        if( per_hour > 1) {
            per_hour--;
        }
        $('#per-hour-input').val(formatMoney(per_hour));
        updateScreeningCost(num_candidates, per_hour, time_per_candidate);
        
    });
    $('#btn-plus_per-hour').click(function(e) {
        e.preventDefault();
        per_hour++;
        $('#per-hour-input').val(formatMoney(per_hour));
        updateScreeningCost(num_candidates, per_hour, time_per_candidate);
        
    });
    
    $('#per-hour-input').change(function(e){
       per_hour = parseFloat($(this).val());
       $('#per-hour-input').val(formatMoney(per_hour));
       updateScreeningCost(num_candidates, per_hour, time_per_candidate);
    });
    
     
     // number of candidates
   $('#btn-minus_num_candidates').click(function(e){
       e.preventDefault();
       if (num_candidates > 1 ) {
           num_candidates--;
       }
       $('#input_screenings').val(formatCandidates(num_candidates));
       updateScreeningCost(num_candidates, per_hour, time_per_candidate);
   });
   
   $('#btn-plus_num_candidates').click(function(e){
       e.preventDefault();
        num_candidates++;
       
       $('#input_screenings').val(formatCandidates(num_candidates));
       updateScreeningCost(num_candidates, per_hour, time_per_candidate);
   });
   
   $('#input_screenings').change(function() {
       num_candidates = parseInt($(this).val());
      $('#input_screenings').val(formatCandidates(num_candidates)); 
      updateScreeningCost(num_candidates, per_hour, time_per_candidate);
   });
   
    
    // Time per candidate 
    $('#btn-minus_time_per_candidate').click(function(e){
       e.preventDefault();
       if (time_per_candidate > 1 ) {
           time_per_candidate--;
       }
       $('#time-per-screening').val(formatMinutes(time_per_candidate));
       updateScreeningCost(num_candidates, per_hour, time_per_candidate);
   });
   
   $('#btn-plus_time_per_candidate').click(function(e){
       e.preventDefault();
        time_per_candidate++;
       
       $('#time-per-screening').val(formatMinutes(time_per_candidate));
       updateScreeningCost(num_candidates, per_hour, time_per_candidate);
   });
   
   $('#time-per-screening').change(function() {
       time_per_candidate = parseInt($(this).val());
      $('#time-per-screening').val(formatMinutes(time_per_candidate));
      updateScreeningCost(num_candidates, per_hour, time_per_candidate);
   });
});

$(document).ready(function(){
    $(".input-number").keydown(function (e) {
        // Allow: backspace, delete, tab, escape, enter and .
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 190]) !== -1 ||
             // Allow: Ctrl+A
            (e.keyCode == 65 && e.ctrlKey === true) || 
             // Allow: home, end, left, right
            (e.keyCode >= 35 && e.keyCode <= 39)) {
                 // let it happen, don't do anything
                 return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
        }
    });
});