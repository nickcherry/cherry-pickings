angular.module('cherryPickings').service 'Preload', ($http, $templateCache, Config) ->

  service =

    init: ->
      # Preload and cache templates
      for templateUrl in Config.preloadTemplates
        $http.get templateUrl, { cache: $templateCache }
