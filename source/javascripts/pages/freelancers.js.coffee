$(document).on 'submit-success', 'body#freelancers #apply form', ->
  # Track via LinkedIn
  image = document.createElement('img')
  img.src = 'https://dc.ads.linkedin.com/collect/?pid=1099289&conversionId=939865&fmt=gif'
  document.body.appendChild(image)

  # Track via Google Analytics
  if gtag?
    gtag 'event', 'sign_up', method: $('body').data('locale')
