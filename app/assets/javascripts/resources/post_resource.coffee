angular.module('cherryPickings').factory 'PostResource', (ResourceBase, Post) ->

  class PostResource extends ResourceBase

    constructor: ->
      super '/posts/:id', default: { model: Post }
