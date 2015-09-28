angular.module('cherryPickings').service 'Scroller', ->

  service =

    toTop: (options={}) ->
      delay = options.delay || 0
      duration = options.duration || 0
      top = options.top || 0
      $("html, body, .modal").delay(delay).animate { scrollTop: top }, duration
