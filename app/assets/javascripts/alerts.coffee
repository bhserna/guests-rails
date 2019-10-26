$(document).on "click", "[data-action='alert#close']", (e) ->
  $(this).parents(".alert").fadeOut()
