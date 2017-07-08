selector = ".js-selectize"

$(document).on "ready, turbolinks:load", ->
  $(selector).selectize
    delimiter: ','
    persist: false
    create: (input) ->
      value: input
      text: input