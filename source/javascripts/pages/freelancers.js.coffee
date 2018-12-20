$(document).on 'submit-success', 'body#freelancers #apply form', ->
  if ga?
    ga 'send', 'event', 'FreelancerRequest', 'created', $('body').data('locale')
