function toggleSelectedQuestions() {
    var selectAll = $('#selected_questions_selectall');
    if (!selectAll.prop("checked")) {
        $('#selected_questions_table tbody tr td:nth-child(1) input[type=checkbox]').each( function(index, item){
            $(item).prop('checked', false);    
        });
    }
    else {
         $('#selected_questions_table tbody tr td:nth-child(1) input[type=checkbox]').each( function(index, item){
            $(item).prop('checked', true);    
            
        });

    }
}

function toggleAvailableQuestions() {
    var selectAll = $('#available_questions_selectall');
    if (!selectAll.prop("checked")) {
        $('#available_questions_table tbody tr td:nth-child(1) input[type=checkbox]').each( function(index, item){
            $(item).prop('checked', false);    
        });
    }
    else {
         $('#available_questions_table tbody tr td:nth-child(1) input[type=checkbox]').each( function(index, item){
            $(item).prop('checked', true);    
        });

    }
}
