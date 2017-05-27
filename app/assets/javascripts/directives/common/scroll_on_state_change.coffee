angular.module('cherryPickings').directive 'scrollOnStateChange', ($rootScope, Browser, Scroller) ->

  directive =
    restrict: 'A'
    link: (scope, el, attrs, controller) ->
      delay = attrs.scrollDelay || 0
      duration = attrs.scrollDuration || (if Browser.isMobile() then 0 else 350)
      top = attrs.scrollTop || 0

      $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
        return unless fromState.views
        Scroller.toTop(top: top, duration: duration, delay: delay)
