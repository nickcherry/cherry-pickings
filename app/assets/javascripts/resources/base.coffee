angular.module('cherryPickings').factory 'ResourceBase', ($http, Config) ->

  class @ResourceBase

    constructor: (@route, @responseProfiles={}) ->

    list: (params={}) ->
      @action
        path: @route
        queryParams: params
        responseProfile: 'list'

    get: (id, params={}) ->
      @action
        path: @route
        pathParams: { id: id }
        queryParams: params
        responseProfile: 'get'

    create: (model, params={}) ->
      @action
        method: 'POST'
        path: @route
        pathParams: { id: model.id }
        queryParams: params
        data: model
        responseProfile: 'create'

    update: (model, params={}) ->
      @action
        method: 'PUT'
        path: @route
        pathParams: { id: model.id }
        queryParams: params
        data: model
        responseProfile: 'update'

    destroy: (id, params={}) ->
      @action
        method: 'DELETE'
        path: @route
        pathParams: { id: id }
        queryParams: params
        responseProfile: 'destroy'

    save: (model, query={}) ->
      if model.id then @update(model, query) else @create(model, query)

    # Replace route placeholders with values and prepend base URL
    resolvePath: (route, map={}) ->
      _.each map, (val, key) ->
        route = route.replace ":#{ key }", val || ''

      # Remove any unresolved placeholders (like in list, where we remove /:id from the path)
      route = route.replace(/\:[a-zA-Z]+/, '')

      @baseUrl() + route

    # Returns the base URL for API requests
    baseUrl: ->
      Config.apiBasePath

    # Serialize request data using ModelBase's serialize method
    serializeRequest: =>
      transforms = [@_decamelizeKeys]
      transforms.unshift (data, headersGetter) =>
        @_serializeModel(data)
      @_prependRequestTransform(transforms)

    # Return
    responseSchema: (name) ->
      @responseProfiles[name] || @responseProfiles.default

    # Use key-to-model-class mapping to cast response data to models
    modelizeResponse: (schema) ->
      transforms = [@_camelizeKeys]
      transforms.push (data, headersGetter) =>
        if schema.model
          @_toModel(data, schema.model)
        else
          @_compositeResponseToModel(data, schema)
      @_appendResponseTransform(transforms)

    action: (options) ->
      options.url ||= @resolvePath(options.path, options.pathParams)
      options.params ||= options.queryParams
      options.transformRequest ||= @serializeRequest()
      if options.model
        options.transformResponse = @modelizeResponse(model: options.model)
      else if schema = options.responseProfile
        schema = @responseSchema(options.responseProfile) if _.isString(schema)
        options.transformResponse = @modelizeResponse(schema)
      else if options.model != false && schema = @responseSchema('default')
        options.transformResponse = @modelizeResponse(schema)
      else
        options.transformResponse ||= @_appendResponseTransform(@_decamelizeKeys)

      $http(options)

    # INTERNAL: Prepend request transform to array of default request transforms
    _prependRequestTransform: (transforms...) ->
      defaults = $http.defaults.transformRequest
      _.flatten(transforms).concat defaults

    # INTERNAL: Append response transform to array of default response transforms
    _appendResponseTransform: (transforms...) ->
      defaults = $http.defaults.transformResponse
      defaults.concat _.flatten(transforms)

    # INTERNAL: Cast data to coffeescript model (or array of coffeescript models)
    _toModel: (data, modelClass) ->
      return new modelClass(data) unless _.isArray(data)
      _.map data, (item) -> new modelClass(item)

    _compositeResponseToModel: (data, schema) ->
      _.each schema, (modelClass, path) ->
        modelData = _.get(data, path, data)
        @_toModel(modelData, modelClass)
      data

    # INTERNAL: Attempt to serialize model or array of models
    _serializeModel: (model) ->
      serialize = (model) -> if model?.serialize then model.serialize() else model
      return serialize(model) unless _.isArray(model)
      _.map model, (item) -> serialize(model)

    _decamelizeKeys: (data, headersGetter) ->
      humps.decamelizeKeys(data)

    _camelizeKeys: (data, headersGetter) ->
      humps.camelizeKeys(data)
