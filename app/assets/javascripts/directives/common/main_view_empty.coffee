angular.module('cherryPickings').directive 'mainViewEmpty', ->

  directive =
    replace: true
    restrict: 'E'
    scope: true
    templateUrl: 'directives/common/main_view_empty.html'
    transclude: true
