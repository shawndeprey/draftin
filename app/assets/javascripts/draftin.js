(function($, window, document, navigator, global) {
    var draftin = draftin ? draftin : {
      init: function(){
        // Draftin Initialization
      },
      loading: function(){
        $("div.load_container").fadeToggle(250);
      }
    };
    global.draftin = draftin;
})(jQuery, window, document, navigator, this);

jQuery(function($){
  $(document).ready(function(){
    draftin.init();
  });
});