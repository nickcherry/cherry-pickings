angular.module('cherryPickings').service 'VendorPrefix', ->

  service =

    props: (prop, value) ->
      _.tap {}, (props) ->
        props['-webkit-' + prop] = value
        props['-moz-' + prop] = value
        props['-ms-' + prop] = value
        props['-o-' + prop] = value
