function categoryChanged(category) {
  if (category == "Free Form") {
    $('#short-phrase').hide();
    $('#multiple-choice').hide();
    $('#free-form').show();
  }
  else if (category == "Multiple Choice") {
    $('#short-phrase').hide();
    $('#multiple-choice').show();
    $('#free-form').hide();
  }
  else if (category == "Short Phrase") {
    $('#short-phrase').show();
    $('#multiple-choice').hide();
    $('#free-form').hide();
  }
}