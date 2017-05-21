angular.module('cherryPickings').filter 'filterByTag', ->
  (posts, tag) ->
    return posts unless tag
    _.filter posts, (post) ->
      _.includes(_.map(post.tags, 'name'), tag)
