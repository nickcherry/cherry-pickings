angular.module('cherryPickings').service 'Config', ($location) ->

  config = {}

  config.env = if $location.host().indexOf('heroku') > -1 then 'production' else 'development'
  config.apiBasePath = '/api'
  config.preloadTemplates = [
    'directives/posts/post'
    'directives/posts/posts'
    'directives/tags/tags'
    'directives/common/loader'
    'directives/common/main_view_errors'
  ]

  config
