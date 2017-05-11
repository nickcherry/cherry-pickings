angular.module('cherryPickings').service 'Post', ($sce, ModelBase, Tag) ->

  class Post extends ModelBase

    constructor: (attrs={}) ->
      super(attrs)
      @title = $sce.trustAsHtml(@title)
      @bodyHtml = $sce.trustAsHtml(@bodyHtml)
      @tags = _.map @tags, (tag) -> new Tag(tag)
