if $('html').hasClass('child-to-parent-directive-communication-example')

  app = angular.module('cherryTavern', ['ngEmoticons', 'templates'])

  templateDirectory = 'examples/child_to_parent_directive_communication'

  app.controller 'CherryTavernController', ($scope) ->
    $scope.items = [
      { name: 'Beer', icon: ':beer:', price: 5.00 }
      { name: 'Cocktail', icon: ':cocktail:', price: 10.00 }
      { name: 'Sake', icon: ':sake:', price: 8.00 }
      { name: 'Wine', icon: ':wine_glass:', price: 8.00 }
    ]

  switch $('html').attr('id')

    #########################################################
    # Callbacks
    #########################################################

    when 'child-to-parent-directive-communication-callbacks-example'

      app.directive 'store', ->
        directive =
          replace: true
          restrict: 'E'
          scope: { items: '=' }
          templateUrl: templateDirectory + '/callbacks/store.html'
          link: (scope) ->
            cart = []
            scope.addToCart = (item) ->
              cart.push(item)
            scope.total = ->
              _.sum(cart, 'price')
            scope.summary = ->
              _.map _.groupBy(_.sortBy(cart, 'name'), 'name'), (items, name) ->
                "#{ items.length } #{ name }#{ if items.length > 1 then 's' else '' }"
              .join(', ')

      app.directive 'item', ->
        directive =
          replace: true
          restrict: 'E'
          scope: { item: '=', addToCart: '&' }
          templateUrl: templateDirectory + '/callbacks/item.html'



    #########################################################
    # Events
    #########################################################

    when 'child-to-parent-directive-communication-events-example'

      app.directive 'store', ->
        directive =
          replace: true
          restrict: 'E'
          scope: { items: '=' }
          templateUrl: templateDirectory + '/callbacks/store.html'
          link: (scope) ->
            cart = []
            scope.$on 'item:addToCart', (event, item) ->
              cart.push(item)
            scope.total = ->
              _.sum(cart, 'price')
            scope.summary = ->
              _.map _.groupBy(_.sortBy(cart, 'name'), 'name'), (items, name) ->
                "#{ items.length } #{ name }#{ if items.length > 1 then 's' else '' }"
              .join(', ')

      app.directive 'item', ->
        directive =
          replace: true
          restrict: 'E'
          scope: false
          templateUrl: templateDirectory + '/events/item.html'
          link: (scope) ->
            scope.addToCart = (item) ->
              scope.$emit('item:addToCart', item)


    #########################################################
    # Required Controller
    #########################################################

    when 'child-to-parent-directive-communication-required-controller-example'

      app.directive 'store', ->
        cart = []
        class StoreController
          addToCart: (item) ->
            cart.push(item)
          total: ->
            _.sum(cart, 'price')
          summary: ->
            _.map _.groupBy(_.sortBy(cart, 'name'), 'name'), (items, name) ->
              "#{ items.length } #{ name }#{ if items.length > 1 then 's' else '' }"
            .join(', ')
        directive =
          bindToController: { items: '=' }
          controller: StoreController
          controllerAs: 'ctrl'
          replace: true
          restrict: 'E'
          templateUrl: templateDirectory + '/required_controller/store.html'

      app.directive 'item', ->
        directive =
          require: '^store'
          replace: true
          restrict: 'E'
          scope: true
          templateUrl: templateDirectory + '/required_controller/item.html'
          link: (scope, element, attrs, storeController) ->
            scope.addToCart = storeController.addToCart


    #########################################################
    # Shared Scope
    #########################################################

    when 'child-to-parent-directive-communication-shared-scope-example'

      app.directive 'store', ->
        directive =
          replace: true
          restrict: 'E'
          scope: { items: '=' }
          templateUrl: templateDirectory + '/shared_scope/store.html'
          link: (scope) ->
            cart = []
            scope.addToCart = (item) ->
              cart.push(item)
            scope.total = ->
              _.sum(cart, 'price')
            scope.summary = ->
              _.map _.groupBy(_.sortBy(cart, 'name'), 'name'), (items, name) ->
                "#{ items.length } #{ name }#{ if items.length > 1 then 's' else '' }"
              .join(', ')

      app.directive 'item', ->
        directive =
          replace: true
          restrict: 'E'
          scope: true
          templateUrl: templateDirectory + '/shared_scope/item.html'

