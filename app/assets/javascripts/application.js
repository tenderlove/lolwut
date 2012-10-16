// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require turbolinks

jQuery(document).ready(function() {
  setTimeout(function() {
    var source = new EventSource('/control');

    // if we get a reload command, reload the page
    source.addEventListener('reload', function(e) {
      Turbolinks.visit(window.location);
    });

    // if we get a reload-styles command, reload the css
    source.addEventListener('reload-styles', function(e) {
      var sheets = $("[rel=stylesheet]");
      sheets.each(function() {
        var sheet = $(this);
        var clone = sheet.clone()
        clone.appendTo(document.head);
        clone.on('load', function() {
          setTimeout(20, function() {
            sheet.remove();
          });
        });
      });
    });

  }, 1);
});
