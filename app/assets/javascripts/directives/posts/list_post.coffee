angular.module('cherryPickings').directive 'listPost', ->

  directive =
    replace: true
    restrict: 'E'
    scope: { post: '='}
    templateUrl: 'directives/posts/list_post.html'
