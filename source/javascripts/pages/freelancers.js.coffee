$(document).on 'submit-success', 'body#freelancers #apply form', ->
  if gtag?
    gtag 'event', 'sign_up', method: $('body').data('locale')
