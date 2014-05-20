current_style = 0
max_styles = 5

$ ->
  if chrome.storage
    chrome.storage.local.get 'last_text', (last_text) ->
      $('.text').text(text) if last_text

  setInterval text_changed, 1000
  $('body').addClass('style-0')

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

text_changed = ->
  text = $('.text-input').val()
  $('.text').text(text)

  chrome.storage.local.set({'last_text': text}) if chrome.storage

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
