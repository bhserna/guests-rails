$(document).on "click", ".js-bar-menu-control", (e) ->
  e.preventDefault()
  $(".bar__buttons").toggleClass("bar__buttons--shown")
