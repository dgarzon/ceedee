# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  window.ParsleyConfig = {
    successClass: "has-success"
    errorClass: "has-error"
    trigger: 'change, focusout'
    validationMinlength: 1
    errors:
      classHandler: (el) ->
        $(el).closest ".input-group"
  };