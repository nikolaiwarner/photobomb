current_style = 0
max_styles = 5
default_text = 'LOL'
current_text = default_text

$ ->
  $('body').addClass('style-0')

  $('body').on 'keyup', =>
    current_text = $('.text-input').val()
    text_changed()

  $(window).on 'orientationchange', =>
    setTimeout text_changed, 1000

  $(".text").swipe
    threshold: 25
    swipeLeft: swipeLeft
    swipeRight: swipeRight
    click: ->
      $('.navbar').toggleClass('visible')
      $('.text-input').blur()

  $(".btn-settings, .page-settings").swipe
    click: ->
      $('.page-settings').toggleClass('visible')
      $('.text-input').blur()

  $('.navbar').addClass('visible')
  StatusBar.hide() if StatusBar

  if chrome.storage
    chrome.storage.local.get {'last_text': current_text}, (items) =>
      current_text = items.last_text || default_text
      text_changed()
  else
    text_changed()

text_changed = =>
  $('.text').text(current_text)
  $('.text-input').val(current_text)
  chrome.storage.local.set({'last_text': current_text}) if chrome.storage
  resize_text()

resize_text = ->
  textFit $('.text')[0],
    minFontSize: 6
    maxFontSize: 250
    detectMultiLine: true
    multiLine: true
    alignVert: true

swipeLeft = (event, direction, distance, duration, fingerCount) ->
  current_style = current_style - 1
  if current_style < 0
    current_style = max_styles
  $('body').removeClass().addClass('style-'+current_style)

swipeRight = (event, direction, distance, duration, fingerCount) ->
  current_style = current_style + 1
  if current_style > max_styles
    current_style = 0
  $('body').removeClass().addClass('style-'+current_style)
