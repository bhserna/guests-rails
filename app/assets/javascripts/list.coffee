unselectize = ($el) ->
  $el[0]?.selectize?.destroy()

selectize = ($el, options) ->
  $(document).on 'turbolinks:before-cache', -> unselectize($el)
  $el.selectize(options)

filterByGroup = (el) ->
  path = "#{location.pathname}?group=#{el.value}"
  Turbolinks.visit(path, action: "replace")

focusInvitationTitle = ->
  $(".js-invitation-form").find("#invitation_title").focus()

initGroupAutocomplete = ->
  $el = $(".js-group-autocomplete")
  $(document).on 'turbolinks:before-cache', ->
    if $el.autocomplete("instance")
      $el.autocomplete("destroy")
  $el.focus -> $el.autocomplete("search", "")
  $el.autocomplete source: $el.data("options"), minLength: 0

init = ->
  focusInvitationTitle()
  initGroupAutocomplete()
  selectize $(".js-selectize--guests"),
    delimiter: ','
    persist: false
    create: (input) ->
      value: input
      text: input

$(document).on "ready, turbolinks:load", init
$(document).on "change", ".js-filter-by-group", -> filterByGroup(this)
