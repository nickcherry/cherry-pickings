angular.module('cherryPickings').service 'Browser', ($rootScope) ->

  class Browser

    @init: ->
      $rootScope.browser ||= {}
      $rootScope.browser.chrome = @isChrome()
      $rootScope.browser.firefox = @isFirefox()
      $rootScope.browser.ios = @isIos()
      $rootScope.browser.safari = @isSafari()

    @isAndroid: -> bowser.android
    @isChrome: -> bowser.chrome
    @isFirefox: -> bowser.firefox
    @isMobile: -> bowser.mobile
    @isIos: -> bowser.ios
    @isSafari: -> bowser.safari
