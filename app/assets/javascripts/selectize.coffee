$(document).on "ready, turbolinks:load", ->
  $(".js-selectize-guests").selectize
    delimiter: ','
    persist: false
    create: (input) ->
      value: input
      text: input

  $(".js-selectize-group").selectize
    create: true,
    sortField: 'text