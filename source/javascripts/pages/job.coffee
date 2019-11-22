$(document).on 'turbolinks:load', ->
  if $('body.job').length && $freelancerCount.length
    cookieName = 'freelancer_count'
    if freelancerCount = Cookies.get(cookieName)
      displayFreelancerCount freelancerCount
    else
      $.getJSON('https://api.uplink.tech/data/freelancer_count')
        .done (data) ->
          freelancerCount = data.results
          displayFreelancerCount freelancerCount
          Cookies.set cookieName, freelancerCount, expires: 1

$freelancerCount = $('#freelancer-count')

displayFreelancerCount = (count) ->
  if count? && parseInt(count) > 1000
    html = "<span title='Diese Zahl ist live und wurde gerade eben von unserem Server geladen.' data-toggle='tooltip'>
      <i class='far fa-satellite-dish'></i>
      #{count}
    </span>"
    $freelancerCount.addClass('active')
                    .html(html)
    $('[data-toggle="tooltip"]').tooltip()
