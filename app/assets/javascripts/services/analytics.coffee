angular.module('cherryPickings').service 'Analytics', ($rootScope, $window) ->

  class Analytics
    init: ->
      if $window.ga
        $rootScope.$on '$stateChangeSuccess', (event) ->
          $window.ga 'send', 'pageview',
            page: window.location.pathname
            location: window.location.href

  new Analytics()
