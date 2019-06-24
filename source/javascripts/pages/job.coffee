$(document).on 'turbolinks:load', ->
  if $('body.job').length && $freelancerCount.length
    cookieName = 'freelancer_count'
    if freelancerCount = Cookies.get(cookieName)
      setFreelancerCount freelancerCount
    else
      $.getJSON('https://api.uplink.tech/data/freelancer_count')
        .done (data) ->
          freelancerCount = data.results
          setFreelancerCount freelancerCount
          Cookies.set cookieName, freelancerCount, expires: 1
        .fail ->
          setFreelancerCount()

$freelancerCount = $('.freelancer-count')

setFreelancerCount = (count) ->
  if count?
    $freelancerCount.find('.loading, .fail').addClass('hidden')
    $freelancerCount.find('.done')
                    .removeClass('hidden')
                    .find('.data')
                    .text(count)
  else
    $freelancerCount.find('.fail')
                    .removeClass('hidden')
    $freelancerCount.find('.loading, .done')
                    .addClass('hidden')
