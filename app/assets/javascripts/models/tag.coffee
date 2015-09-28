angular.module('cherryPickings').service 'Tag', (ModelBase) ->

  class Tag extends ModelBase

    constructor: (attrs={}) ->
      super(attrs)
