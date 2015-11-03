angular.module 'cherryPickings', [
    'templates'
    'ui.router'
  ]

.config ($httpProvider, $locationProvider, $stateProvider, $urlRouterProvider) ->

  ##################################################################
  # Enable HTML5Mode
  ##################################################################

  $locationProvider.html5Mode(true)

  ##################################################################
  # Set CSRF token on outgoing requests
  ##################################################################

  authToken = angular.element('meta[name="csrf-token"]').attr('content')
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = authToken

  ##################################################################
  # Define app routes / states
  ##################################################################

  $stateProvider

    .state 'root',
      views:
        'header':
          controller: 'HeaderController'
          templateUrl: 'header.html'
        'footer':
          controller: 'FooterController'
          templateUrl: 'footer.html'

    .state 'root.posts',
      url: '/blog'
      pageClass: 'posts'
      views:
        'main@':
          controller: 'PostsController'
          templateUrl: 'posts.html'

    .state 'root.post',
      url: '/blog/:id'
      pageClass: 'post'
      views:
        'main@':
          controller: 'PostController'
          templateUrl: 'post.html'

  $urlRouterProvider.otherwise ($injector, $location) ->
    $state = $injector.get '$state'
    $state.go 'root.posts'

.run ($rootScope, Analytics, Browser, PageClass, Preload, Scroller) ->
  Scroller.toTop()
  Analytics.init()
  Browser.init()
  PageClass.init()
  Preload.init()
  $rootScope.appInitialized = true
