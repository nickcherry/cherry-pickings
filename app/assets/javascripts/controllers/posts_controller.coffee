angular.module('cherryPickings').controller 'PostsController', ($scope, PostResource) ->

  $scope.init = ->
    $scope.errors = null
    new PostResource().list().then (response) ->
      $scope.posts = response.data
      $scope.initialized = true
    , ->
      $scope.errors = ['There was a problem fetching the posts.']

  $scope.init()
