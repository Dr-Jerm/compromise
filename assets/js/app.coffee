###
http://dev.dota2.com/showthread.php?t=72063&p=510746&viewfull=1#post510746
###

(->
  qwer = angular.module("qwerGame", [])
  qwer.controller "mainNav", ($scope) ->

    $scope.menuItems = [
      {
        class: 'home'
        text: 'Home'
      }
      {
        class: 'other'
        text: 'Other'
      }
    ]

  qwer.controller "dotaGame", ($scope) ->
    $scope.keys = ['q', 'w', 'e', 'r'];

  qwer.directive 'keySquare', () ->
    restrict: 'E'
    templateUrl: 'partials/keySquare'
    scope: 
      keyCode: '='
    
    link: (scope, element, attrs) ->
      debugger 
    

  console.log "Up and Running!"
)()