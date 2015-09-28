angular.module('cherryPickings').directive 'mainViewErrors', ->

  directive =
    replace: true
    restrict: 'E'
    scope:
      errors: '='
      retry: '&'
      retryText: '@'
    templateUrl: 'directives/common/main_view_errors.html'
