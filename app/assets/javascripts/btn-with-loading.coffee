defaultSelectors = ".js-btn-with-loading"
submitSelector = "form.js-btn-with-loading"
timeToEventBubble = 5
defaultLoadingText = "Cargando..."
spinnerHtml = "<i class='fa fa-spinner fa-spin'></i>"

handleClickEvent = (event) ->
  btn = $(this)
  setTimeout (-> setLoadingText(btn)), timeToEventBubble

handleAjaxSuccess = (event) ->
  btn = $(this)
  if btn.length
    setTimeout (-> resetState(btn)), timeToEventBubble

handleSubmitEvent = (event) ->
  form = $(event.target)
  btn = form.find("[type='submit']")
  setTimeout (-> setLoadingText(btn)), timeToEventBubble

setLoadingText = (btn) ->
  btn.data("textBeforeLoading", btn.html())
  btn.attr("disabled", true)
  updateContent(btn)

resetState = (btn) ->
  btn.attr("disabled", false)
  updateContent(btn, textBeforeLoading(btn)) if textBeforeLoading(btn)

textBeforeLoading = (btn) ->
  btn.data("textBeforeLoading")

updateContent = (btn, text) ->
  if btn.is("input")
    btn.val(text || defaultLoadingText)
  else
    btn.html(text || spinnerHtml)

$(document).on "click", defaultSelectors, handleClickEvent
$(document).on "submit", submitSelector, handleSubmitEvent
$(document).on "ajax:success", defaultSelectors, handleAjaxSuccess
$(document).on 'turbolinks:before-cache', ->
  $(defaultSelectors).each ->
    resetState $(this)

window.BtnWithLoading = {setLoadingText, resetState, handleSubmitEvent}
