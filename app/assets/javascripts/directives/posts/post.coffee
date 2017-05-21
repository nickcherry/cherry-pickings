angular.module('cherryPickings').directive 'post', ->

  directive =
    replace: true
    restrict: 'E'
    scope: { post: '='}
    templateUrl: 'directives/posts/post.html'
