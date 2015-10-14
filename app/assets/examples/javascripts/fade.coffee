$(document).ready ->
  return unless $('html').hasClass('fade-example')

  wrapperEl = $('#wrapper')
  buttonEl = $('button')

  initialize = -> wrapperEl.addClass('initialized')
  revealDoughboy = -> wrapperEl.addClass('poked')

  setTimeout(initialize, 2000)
  buttonEl.on 'click', revealDoughboy
