angular.module('cherryPickings').service 'PageClass', ($rootScope) ->

  service =

    init: ->
      $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
        $rootScope.pageClass = toState.pageClass
