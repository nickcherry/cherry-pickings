angular.module('cherryPickings').directive 'loader', ->

  directive =
    replace: true
    restrict: 'E'
    scope: { text: '@' }
    templateUrl: 'directives/common/loader.html'
