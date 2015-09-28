angular.module('cherryPickings').service 'ModelBase', ->

  class ModelBase

    constructor: (attrs={}) ->
      @setAttributes(attrs)

    setAttributes: (attrs={}) ->
      _.each attrs, (val, key) =>
        @[_.camelCase(key)] = val; this

    update: (model, setRecompile=true) ->
      @setAttributes(model)
      @recompile = true if setRecompile

    copyTo: (model) ->
      model.update(this)

    serialize: ->
      _.reduce this, (data, val, key) ->
        data[_.snakeCase(key)] = val; data
      , {}
