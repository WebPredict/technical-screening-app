function adjustQuestionForm(category) {
  //alert ("category: " + category);
  if (category == 1) {
    $('#short-phrase').hide();
    $('#multiple-choice').hide();
    $('#free-form').show();
  }
  else if (category == 2) {
    $('#short-phrase').hide();
    $('#multiple-choice').show();
    $('#free-form').hide();
  }
  else if (category == 3) {
    $('#short-phrase').show();
    $('#multiple-choice').hide();
    $('#free-form').hide();
  }
}