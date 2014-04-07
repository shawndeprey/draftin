var window_has_focus = true;
(function($, window, document, navigator, global) {
    var draftin = draftin ? draftin : {
      init: function(){
        draftin.loadAudio();
        $(window).focus(function() {
          window_has_focus = true;
        }).blur(function() {
          window_has_focus = false;
        });
      },
      loadAudio: function(){
        draftin.ding = new Audio("http://shawndeprey.com/assets/sounds/ding.mp3");
        draftin.ding.volume = 0.1;
        draftin.ding.load();
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
