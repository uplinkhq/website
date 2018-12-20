$(document).on 'submit-success', 'body#freelancers #apply form', ->
  ga 'send', 'event', 'FreelancerRequest', 'created', $('body').data('locale')
