angular.module('cherryPickings').directive 'post', ($timeout, KatexService) ->

  directive =
    replace: true
    restrict: 'E'
    scope: { post: '='}
    templateUrl: 'directives/posts/post.html'
    link: (scope, element) ->

      watcher = scope.$watch 'post', (post) ->
        return unless post
        watcher()
        $timeout -> KatexService.katexify(element)
