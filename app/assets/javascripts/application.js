/* globals $ */
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require react
//= require react_ujs
//= require components
//= require moment
//= require_tree .
//= require jquery/jquery-1.8.3.min
//= require ace/ace
//= require ace/theme-monokai
//= require ace/mode-ruby
//= require jquery-ace.min
//= require react_rails_img

'use strict';

var ready = function() {
  var pathname = window.location.pathname;
  if (pathname.search(/^\/problems/) >= 0) {
    setEditor();
  }
};

var setEditor = function () {
  $('#editor').ace({ theme: 'monokai', lang: 'ruby'});
  var editor = document.querySelector('.ace_editor').env.editor;
  editor.getSession().setTabSize(2);
  editor.gotoLine(2);
  editor.insert('  ');
  updateHiddenInput();
  editor.getSession().on('change', function() {
    updateHiddenInput();
  });
  function updateHiddenInput() {
    var hiddenInput = $('input[name="editor-content"]');
    hiddenInput.val(editor.getSession().getValue());
  }
};


$(document).ready(ready);
$(document).on('page:load', ready);
