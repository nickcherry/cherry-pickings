if $('html').hasClass('the-perfect-fade-example')

  $(document).ready ->

    wrapperEl = $('#wrapper')
    buttonEl = $('button')

    initialize = -> wrapperEl.addClass('initialized')
    revealDoughboy = -> wrapperEl.addClass('poked')

    setTimeout(initialize, 2000)
    buttonEl.on 'click', revealDoughboy
