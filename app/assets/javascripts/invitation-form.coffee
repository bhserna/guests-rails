selector = ".js-invitation-form"

$(document).on "ready, turbolinks:load", ->
  $(selector).find("#invitation_title").focus()