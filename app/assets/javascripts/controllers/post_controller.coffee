angular.module('cherryPickings').controller 'PostController', ($scope, $stateParams, PostResource) ->

  $scope.init = ->
    $scope.errors = null
    new PostResource().get($stateParams.id).then (response) ->
      $scope.post = response.data
      $scope.initialized = true
    , ->
      $scope.errors = ['There was a problem fetching the post.']

  $scope.init()
