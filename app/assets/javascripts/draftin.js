(function($, window, document, navigator, global) {
    var draftin = draftin ? draftin : {
      init: function(){
        // Draftin Initialization
      },
      toggleElement: function(element_class){
        $(element_class).slideToggle(250);
      }
    };
    global.draftin = draftin;
})(jQuery, window, document, navigator, this);

jQuery(function($){
  $(document).ready(function(){
    draftin.init();
  });
});