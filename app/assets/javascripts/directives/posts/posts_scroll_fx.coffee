angular.module('cherryPickings').directive 'postsScrollFx', ($timeout, Browser, VendorPrefix) ->

  class ScrollFxManager

    CONTENT_SELECTOR = '.post-content'
    TOP_SLOPE_SELECTOR = '.post-top-slope'

    START_ANIMATING_BY_SCROLL_PERCENT = 0.95
    FINISH_ANIMATING_BY_SCROLL_PERCENT = 0.5
    CLEAR_BY_SCROLL_PERCENT = -2

    WRAPPER_OPACITY_START = 0.01
    WRAPPER_OPACITY_FINISH = 1
    WRAPPER_OPACITY_DIFF = WRAPPER_OPACITY_FINISH - WRAPPER_OPACITY_START

    TOP_SLOPE_MARGIN_TOP_START = 60
    TOP_SLOPE_MARGIN_TOP_FINISH = 0
    TOP_SLOPE_MARGIN_TOP_DIFF = TOP_SLOPE_MARGIN_TOP_FINISH - TOP_SLOPE_MARGIN_TOP_START

    constructor: (@scope, @el, @attrs) ->

    init: ->
      @attrs.$observe 'recalculateScrollFxOn', @onChildrenUpdated

      $(window).on('resize', @onChildrenUpdated)
      $(window).on('scroll', @onScroll)
      @scope.$on '$destroy', ->
        $(window).off('resize', @onChildrenUpdated)
        $(window).off('scroll', @onScroll)

    analyzeChildren: =>
      @children = _.map $(@el).children(), (el) ->
        wrapperEl = $(el)
        {
          wrapperEl: wrapperEl
          topSlopeEl: wrapperEl.children(TOP_SLOPE_SELECTOR)
          height: wrapperEl.height()
          top: wrapperEl.offset().top
        }

    onChildrenUpdated: =>
      $timeout =>
        @analyzeChildren()
        @onScroll()
      , 0

    onScroll: =>

      windowHeight = $(window).height()
      scrollTop = $(document).scrollTop()
      startAnimatingOffset = scrollTop + windowHeight * START_ANIMATING_BY_SCROLL_PERCENT
      finishAnimatingOffset = scrollTop + windowHeight * FINISH_ANIMATING_BY_SCROLL_PERCENT

      _.each @children, (child, i) ->

        clearAnimationOffet = scrollTop + CLEAR_BY_SCROLL_PERCENT * child.height

        if child.top <= clearAnimationOffet
          #################################################
          # Scrolled through entire post
          #################################################

          wrapperProps = { visibility: 'hidden', opacity: WRAPPER_OPACITY_FINISH }
          topSlopeProps = { 'margin-top': "#{ TOP_SLOPE_MARGIN_TOP_FINISH }px" }

        else if child.top <= finishAnimatingOffset
          #################################################
          # Animation finished
          #################################################

          wrapperProps = { visibility: 'visible', opacity: WRAPPER_OPACITY_FINISH  }
          topSlopeProps = { 'margin-top': "#{ TOP_SLOPE_MARGIN_TOP_FINISH }px" }

        else if child.top <= startAnimatingOffset
          #################################################
          # Animation in progress
          #################################################

          percent = (startAnimatingOffset - child.top) / (startAnimatingOffset - finishAnimatingOffset)

          wrapperOpacity = WRAPPER_OPACITY_START + percent * WRAPPER_OPACITY_DIFF
          topSlopeMarginTop = TOP_SLOPE_MARGIN_TOP_START + percent * TOP_SLOPE_MARGIN_TOP_DIFF

          wrapperProps = { visibility: 'visible', opacity: wrapperOpacity }
          topSlopeProps = { 'margin-top': "#{ topSlopeMarginTop }px" }

        else
          #################################################
          # Animation not started
          #################################################

          wrapperProps = { visibility: 'hidden', opacity: WRAPPER_OPACITY_START }
          topSlopeProps = { 'margin-top': "#{ TOP_SLOPE_MARGIN_TOP_START }px" }

        child.wrapperEl.css(wrapperProps)
        child.topSlopeEl.css(topSlopeProps)


  directive =
    restrict: 'A'
    link: (scope, el, attrs, controller) ->
      unless Browser.mobile() || Browser.firefox()
        new ScrollFxManager(scope, el, attrs).init()
