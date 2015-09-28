angular.module('cherryPickings').directive 'tags', ->

  directive =
    replace: true
    restrict: 'E'
    scope: { tags: '='}
    templateUrl: 'directives/tags/tags.html'
