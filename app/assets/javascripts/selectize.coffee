selectize = ($el, options) ->
  $(document).on 'turbolinks:before-cache', ->
    $el[0]?.selectize?.destroy()

  $el.selectize(options)

window.Selectize =
  init: ->
    selectize $(".js-selectize--guests"),
      delimiter: ','
      persist: false
      create: (input) ->
        value: input
        text: input

    selectize $(".js-selectize--group"),
      create: true
      sortField: 'text'

    selectize $(".js-selectize--filter-by-group"),
      sortField: 'text'
      onChange: (value) ->
        Turbolinks.visit("#{location.pathname}?group=#{value}", action: "replace")

$(document).on "ready, turbolinks:load", ->
  Selectize.init()
