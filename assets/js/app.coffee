
root = exports ? this

(->
  root.app = angular.module("compromise", [])
  root.app.controller "headerController", ($scope) ->

    $scope.test = "scope Variable" 

  root.app.controller "canvasController", ($scope) ->
    canvas = document.getElementById 'compromise'
    context = canvas.getContext '2d'

    $scope.test = "foo"
    
    $scope.debug = -> 
      debugger

    $scope.triangle = {
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
        }
      },
      transforms: {
        scale: 15,
        position: {
          x: 50,
          y: 20
        },
        textOffset: 10
      }
    }

    triangleUpdater = ->

      coords = $scope.triangle.coords
      transforms = $scope.triangle.transforms

      context.clearRect 0, 0, canvas.width, canvas.height

      drawTriangle()

      context.textAlign = "center"
      # context.font = "bold 12px sans-serif";
      context.fillText $scope.triangle.topText, (coords.top.x*transforms.scale+transforms.position.x), (coords.top.y*transforms.scale+transforms.position.y-transforms.textOffset)
      context.fillText $scope.triangle.leftText, (coords.left.x*transforms.scale+transforms.position.x-transforms.textOffset), (coords.left.y*transforms.scale+transforms.position.y+transforms.textOffset)
      context.fillText $scope.triangle.rightText, (coords.right.x*transforms.scale+transforms.position.x+transforms.textOffset), (coords.right.y*transforms.scale+transforms.position.y+transforms.textOffset)

    $scope.$watch 'triangle', triangleUpdater, true
    
    drawTriangle = ->

      coords = $scope.triangle.coords
      transforms = $scope.triangle.transforms

      # context.fillStyle   = '#00f'
      context.strokeStyle = '#000'
      context.lineWidth   = 2

      context.beginPath()
      context.moveTo (coords.top.x*transforms.scale+transforms.position.x), (coords.top.y*transforms.scale+transforms.position.y)
      context.lineTo (coords.left.x*transforms.scale+transforms.position.x), (coords.left.y*transforms.scale+transforms.position.y)
      context.lineTo (coords.right.x*transforms.scale+transforms.position.x), (coords.right.y*transforms.scale+transforms.position.y)
      context.lineTo (coords.top.x*transforms.scale+transforms.position.x), (coords.top.y*transforms.scale+transforms.position.y)
      context.lineTo (coords.left.x*transforms.scale+transforms.position.x), (coords.left.y*transforms.scale+transforms.position.y)

      # context.fill()
      context.stroke()
      context.closePath()

  console.log "Up and Running!"
)()
