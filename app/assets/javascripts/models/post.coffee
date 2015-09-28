angular.module('cherryPickings').service 'Post', ($sce, ModelBase, Tag) ->

  class Post extends ModelBase

    constructor: (attrs={}) ->
      super(attrs)
      @bodyHtml = $sce.trustAsHtml(@bodyHtml)
      @tags = _.map @tags, (tag) -> new Tag(tag)
