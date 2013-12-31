
root = exports ? this

(->
  root.app = angular.module("myApp", [])
  root.app.controller "mainController", ($scope) ->

    $scope.test = "scope Variable" 

  root.app.controller "anotherController", ($scope) ->
    $scope.foo = ['another', 'scope', 'variable'];

  console.log "Up and Running!"
)()