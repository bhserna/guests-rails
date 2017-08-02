window.Selectize =
  init: ->
    $(".js-selectize--guests").selectize
      delimiter: ','
      persist: false
      create: (input) ->
        value: input
        text: input

    $(".js-selectize--group").selectize
      create: true
      sortField: 'text'

    $(".js-selectize--filter-by-group").selectize
      sortField: 'text'
      onChange: (value) ->
        Turbolinks.visit("#{location.pathname}?group=#{value}")

$(document).on "ready, turbolinks:load", ->
  Selectize.init()
