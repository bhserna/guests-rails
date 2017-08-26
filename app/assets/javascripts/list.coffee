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

init = ->
  focusInvitationTitle()

  selectize $(".js-selectize--guests"),
    delimiter: ','
    persist: false
    create: (input) ->
      value: input
      text: input

  selectize $(".js-selectize--group"),
    create: true
    sortField: 'text'

$(document).on "ready, turbolinks:load", init
$(document).on "change", ".js-filter-by-group", -> filterByGroup(this)
