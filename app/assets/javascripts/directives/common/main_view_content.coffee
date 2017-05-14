angular.module('cherryPickings').directive 'mainViewContent', ->

  directive =
    replace: true
    restrict: 'E'
    scope: true
    templateUrl: 'directives/common/main_view_content.html'
    transclude: true
