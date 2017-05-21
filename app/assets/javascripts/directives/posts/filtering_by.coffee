angular.module('cherryPickings').directive 'filteringBy', ->

  directive =
    replace: true
    restrict: 'E'
    scope: { tag: '=' }
    templateUrl: 'directives/posts/filtering_by.html'
