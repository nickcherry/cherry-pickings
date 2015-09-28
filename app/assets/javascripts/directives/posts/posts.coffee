angular.module('cherryPickings').directive 'posts', ->

  directive =
    replace: true
    restrict: 'E'
    scope: { posts: '='}
    templateUrl: 'directives/posts/posts.html'
