$(document).on 'turbolinks:load', ->
  if $('body#companies').length
    initRateSlider()
    watchOptions()

initRateSlider = ->
  el         = document.getElementById('rate-slider')
  [min, max] = [60, 150]

  noUiSlider.create el,
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

  el.noUiSlider.on 'update', (values) ->
    $('input[name="rate"]').val $.map(values, (value) -> parseInt(value))

watchOptions = ->
  $('#freelancer-request .option').click ->
    $container = $(@).parents('.container')

    toggleables = ['.option', '.option-fields']
    # If one of the confirmations is already visible, don't toggle it anymore.
    unless $container.find('.note-confirm').is(':visible')
      toggleables.push '.option-confirmation'
    $container.find(toggleables.join(', ')).toggleClass('active')

    $container.find('.option-fields :input').prop('disabled', (_, val) -> !val)
