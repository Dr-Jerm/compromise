
root = exports ? this

(->
  root.app = angular.module("compromise", [])
  root.app.controller "headerController", ($scope) ->

  root.app.controller "canvasController", ($scope, $http) ->
    canvas = document.getElementById 'compromise'
    context = canvas.getContext '2d'

    $scope.generate = (top, left, right) ->
      req = {
        top: top,
        left: left,
        right: right
      }
      generation = $http.post('generate', req)

      generation.success (data,headers) ->
        console.log data
      generation.error (data, headers) ->
        console.error data 

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

    triangleUpdater = ->
      context.clearRect 0, 0, canvas.width, canvas.height

      drawText()
      drawTriangle()
      drawWatermark()


    $scope.$watch 'triangle', triangleUpdater, true

    drawText = ->
      coords = $scope.triangle.coords
      transforms = $scope.triangle.transforms

      # Text coordinates
      centerX = coords.center.x*transforms.scale+transforms.position.x
      centerY = coords.center.y*transforms.scale+transforms.position.y-transforms.fontSize/2

      topX = coords.top.x*transforms.scale+transforms.position.x
      topY = coords.top.y*transforms.scale+transforms.position.y-transforms.fontSize

      leftX = coords.left.x*transforms.scale+transforms.position.x-transforms.fontSize
      leftY =coords.left.y*transforms.scale+transforms.position.y+transforms.fontSize

      rightX = coords.right.x*transforms.scale+transforms.position.x+transforms.fontSize
      rightY = coords.right.y*transforms.scale+transforms.position.y+transforms.fontSize

      context.textAlign = "center"
      context.font = transforms.fontSize+"px sans-serif";
      context.fillStyle   = '#000'

      # wrapText context, "PICK TWO", (coords.center.x*transforms.scale+transforms.position.x), (coords.center.y*transforms.scale+transforms.position.y-transforms.fontSize/2, 60, transforms.fontSize + 3)
      wrapText("PICK TWO", centerX, centerY, 60, transforms.fontSize + 3)
      # context.fillText "TWO", (coords.center.x*transforms.scale+transforms.position.x), (coords.center.y*transforms.scale+transforms.position.y+transforms.fontSize/2)
      wrapText($scope.triangle.topText, topX, topY, 400, transforms.fontSize+3)
      wrapText($scope.triangle.leftText, leftX, leftY, 100, transforms.fontSize+3)
      wrapText($scope.triangle.rightText, rightX, rightY, 100, transforms.fontSize+3)

    
    drawTriangle = ->

      coords = $scope.triangle.coords
      transforms = $scope.triangle.transforms

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

    drawWatermark = ->
      context.fillStyle = '#ddd'
      context.fillRect(0, 443, 500, 20);

      context.fillStyle = '#aaa'
      context.textAlign = 'right'
      context.fillText "compromiseSucks.com", 495, 458

    wrapText = (text, x, y, maxWidth, lineHeight) ->
      words = text.split ' '
      line = ''

      for word in words
        testLine = line + word + " "
        metrics = context.measureText testLine
        testWidth = metrics.width

        if testWidth > maxWidth && line.length > 0
          context.fillText line, x, y
          line = word + " "
          y += lineHeight
        else
          line = testLine

      context.fillText line, x, y

  console.log "Up and Running!"
)()
