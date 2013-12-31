###
http://dev.dota2.com/showthread.php?t=72063&p=510746&viewfull=1#post510746
###

root = exports ? this

(->
  root.qwer = angular.module("qwerGame", [])
  root.qwer.controller "mainNav", ($scope) ->

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

  root.qwer.controller "dotaGame", ($scope) ->
    $scope.keys = ['q', 'w', 'e', 'r'];

    $scope.userKeyPress = (keyCode) ->
      console.log keyCode

  console.log "Up and Running!"
)()