angular.module('cherryPickings').directive 'mainViewErrors', ->

  directive =
    replace: true
    restrict: 'E'
    scope: true
    templateUrl: 'directives/common/main_view_errors.html'
