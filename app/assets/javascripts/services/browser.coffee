angular.module('cherryPickings').service 'Browser', ($rootScope) ->

  class Browser

    @init: ->
      $rootScope.browser ||= {}
      $rootScope.browser.chrome = @chrome()
      $rootScope.browser.firefox = @firefox()
      $rootScope.browser.ios = @ios()
      $rootScope.browser.safari = @safari()

    @android: -> bowser.android
    @chrome: -> bowser.chrome
    @dateInput: -> bowser.chrome || bowser.ios
    @firefox: -> bowser.firefox
    @mobile: -> bowser.mobile
    @ios: -> bowser.ios
    @safari: -> bowser.safari
