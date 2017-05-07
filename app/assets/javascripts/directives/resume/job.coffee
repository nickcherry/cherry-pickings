angular.module('cherryPickings').directive 'job', ->
  directive =
    replace: true
    restrict: 'E'
    scope:
      companyName: '@'
      role: '@'
      range: '@'
    templateUrl: 'directives/resume/job.html'
    transclude: true
    link: (scope) ->
      scope.toggle = ->
        scope.expanded = !scope.expanded

      scope.getToggleText = ->
        if scope.expanded then 'Show Less' else 'Show More…'
