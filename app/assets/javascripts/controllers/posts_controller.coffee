angular.module('cherryPickings').controller 'PostsController', ($location, $scope, PostResource) ->


  $scope.init = ->
    $scope.errors = null
    new PostResource().list().then (response) ->
      $scope.posts = response.data
      $scope.tag = $location.search().tag
      $scope.initialized = true
    , ->
      $scope.errors = ['There was a problem fetching the posts.']

  $scope.isEmpty = ->
    $scope.posts && $scope.posts.length == 0

  $scope.init()
