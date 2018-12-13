$(document).on 'click', 'body#companies #freelancer-request .option:not(.active)', ->
  $container = $(@).parents('.container')

  toggleables = ['.option', '.option-fields']
  # If one of the confirmations is already visible, don't toggle it anymore.
  unless $container.find('.note-confirm').is(':visible')
    toggleables.push '.option-confirmation'
  $container.find(toggleables.join(', ')).toggleClass('active')

  $container.find('.option-fields :input').prop('disabled', (_, val) -> !val)

  initRateSlider()

initRateSlider = ->
  if sliderEl = $('#rate-slider:visible:empty').get(0)
    noUiSliderVersion = '12.1.0'

    stylesheetId = 'nouislider-css'
    unless document.getElementById(stylesheetId)
      linkEl = document.createElement('link')
      linkEl.setAttribute('rel', 'stylesheet')
      linkEl.setAttribute('id', stylesheetId)
      linkEl.setAttribute('href', "https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/#{noUiSliderVersion}/nouislider.min.css")
      document.getElementsByTagName('head')[0].appendChild(linkEl)

    scriptUrl = "https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/#{noUiSliderVersion}/nouislider.min.js"
    $.ajax url: scriptUrl, dataType: 'script', cache: true, success: ->
      [min, max] = [60, 150]
      noUiSlider.create sliderEl,
        start:    [min, max]
        step:     5
        tooltips: true
        connect:  [false, true, false]
        format:
          to:   (value) -> value + ' €'
          from: (value) -> value.replace(' €', '')
        range:
          min: min
          max: max

      sliderEl.noUiSlider.on 'update', (values) ->
        $('input[name="rate"]').val $.map(values, (value) -> parseInt(value))
