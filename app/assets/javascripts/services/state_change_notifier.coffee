angular.module('cherryPickings').service 'StateChangeNotifier', ($rootScope) ->

  service =

    init: ->
      $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
        $(window).trigger('$stateChangeStart', event, toState, toParams, fromState, fromParams)
