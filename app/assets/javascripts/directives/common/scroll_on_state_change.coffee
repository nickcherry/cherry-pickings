angular.module('cherryPickings').directive 'scrollOnStateChange', ($rootScope, Scroller) ->

  directive =
    restrict: 'A'
    link: (scope, el, attrs, controller) ->
      delay = attrs.scrollDelay || 0
      duration = attrs.scrollDuration || 350
      top = attrs.scrollTop || 0

      $rootScope.$on '$stateChangeStart', ->
        Scroller.toTop(top: top, duration: duration, delay: delay)
