
root = exports ? this

(->
  root.app = angular.module("compromise", [])
  root.app.controller "headerController", ($scope) ->

  root.app.controller "canvasController", ($scope, $http) ->
    canvas = document.getElementById 'compromise'
    context = canvas.getContext '2d'

    $scope.generate = (title, top, left, right) ->
      req = {
        title: title,
        top: top,
        left: left,
        right: right
      }
      generation = $http.post('generate', req)

      generation.success (data,headers) ->
        console.log data
        $scope.imageURL = data.data.link
      generation.error (data, headers) ->
        console.error data 

    $scope.triangle = {
      title: "Compromise Sucks",
      topText: "Top",
      leftText: "Left",
      rightText: "Right",
      coords: {
        top: {
          x: 3,
          y: 0
        },
        left: {
          x: 0,
          y: 5.2
        },
        right: {
          x: 6,
          y: 5.2
        },
        center: {
          x: 3,
          y: 3.5
        }
      },
      transforms: {
        scale: 50,
        position: {
          x: 90,
          y: 70
        },
        textOffset: 10,
        fontSize: 18
      }
    }

    $scope.$watch('triangle', ->
      window.render(canvas, context, $scope.triangle)
    , true)

)()
