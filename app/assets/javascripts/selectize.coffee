window.Selectize =
  init: ->
    $(".js-selectize-guests").selectize
      delimiter: ','
      persist: false
      create: (input) ->
        value: input
        text: input

    $(".js-selectize-group").selectize
      create: true
      sortField: 'text'

$(document).on "ready, turbolinks:load", ->
  Selectize.init()