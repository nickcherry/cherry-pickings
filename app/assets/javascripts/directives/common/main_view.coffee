angular.module('cherryPickings').directive 'mainView', ->

  directive =
    replace: true
    restrict: 'E'
    scope: true
    templateUrl: 'directives/common/main_view.html'
    transclude: true
