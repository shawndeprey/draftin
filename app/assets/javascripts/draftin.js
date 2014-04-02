(function($, window, document, navigator, global) {
    var draftin = draftin ? draftin : {
      init: function(){
        draftin.loadAudio();
        var window_focus;

        $(window).focus(function() {
          draftin.hasFocus = true;
        }).blur(function() {
          draftin.hasFocus = false;
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