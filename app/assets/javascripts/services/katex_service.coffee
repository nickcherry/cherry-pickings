angular.module('cherryPickings').service 'KatexService', ->

  katexify: (element) ->
    element.find('.katex-wrapper').each (i, el) ->
      katex.render $(el).html(), el
