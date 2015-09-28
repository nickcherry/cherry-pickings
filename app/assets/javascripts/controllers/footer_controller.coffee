angular.module('cherryPickings').controller 'FooterController', ($scope) ->
  $scope.copyrightYear = (new Date()).getFullYear()
