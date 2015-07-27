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
//= require jquery_ujs
//= require turbolinks
//= require react
//= require react_ujs
//= require components
//= require moment
//= require_tree .
//= require ace-builds/src-min-noconflict/ace
//= require ace-builds/src-min-noconflict/theme-terminal
//= require ace-builds/src-min-noconflict/ext-language_tools
//= require ace-builds/src-min-noconflict/mode-ruby
//= require react_rails_img
//= require bootstrap.min.js

// 'use strict';

var setEditor = function () {

  var editor = ace.edit('editor');
  editor.setTheme('ace/theme/terminal');
  editor.session.setMode('ace/mode/ruby');
  editor.$blockScrolling = Infinity;
  editor = document.querySelector('.ace_editor').env.editor;
  editor.getSession().setTabSize(2);
  editor.gotoLine(5);
  editor.insert('  ');
  updateHiddenInput();
  editor.getSession().on('change', function() {
    updateHiddenInput();
  });

  editor.setOptions({
    enableBasicAutocompletion: true,
    enableLiveAutocompletion: false
  });
  editor.focus();
  function updateHiddenInput() {
    var hiddenInput = $('input[name="editor-content"]');
    hiddenInput.val(editor.getSession().getValue());
  }
};


$(document).on('click', '#editor-switch-false', setEditor);

$(document).on('click', '#sign-up', function() {
  setTimeout(function(){
    $('#sign-up-name-field').focus();
  }, 500);
});

$(document).on('click', '#sign-in', function() {
  setTimeout(function(){
    $('#sign-in-name-field').focus();
  }, 500);
});

$(document).on('click', '#sign-in-up-submit', function() {
  setTimeout(function(){
    $('#sign-in-name-field').focus();
  }, 500);
});

$(document).on('click', 'a', function() {
  $('#page-cover').addClass('cursor-progress');
});

$(document).bind('ajaxSend', function() {
  $('#page-cover').addClass('cursor-progress');
}).bind('ajaxComplete', function(){
  $('#page-cover').removeClass('cursor-progress');
});



