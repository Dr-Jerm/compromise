# canvas = document.getElementById 'compromise'
#     context = canvas.getContext '2d'

global = exports ? this

global.render = (canvas, context, triangle) -> 
  context.clearRect 0, 0, canvas.width, canvas.height

  drawText = ->
    coords = triangle.coords
    transforms = triangle.transforms

    # Text coordinates
    centerX = coords.center.x*transforms.scale+transforms.position.x
    centerY = coords.center.y*transforms.scale+transforms.position.y-transforms.fontSize/2

    topX = coords.top.x*transforms.scale+transforms.position.x
    topY = coords.top.y*transforms.scale+transforms.position.y-transforms.fontSize

    leftX = coords.left.x*transforms.scale+transforms.position.x-transforms.fontSize
    leftY = coords.left.y*transforms.scale+transforms.position.y+transforms.fontSize

    rightX = coords.right.x*transforms.scale+transforms.position.x+transforms.fontSize
    rightY = coords.right.y*transforms.scale+transforms.position.y+transforms.fontSize

    context.textAlign = "center"
    context.font = transforms.fontSize+"px sans-serif";
    context.fillStyle   = '#000'

    # wrapText context, "PICK TWO", (coords.center.x*transforms.scale+transforms.position.x), (coords.center.y*transforms.scale+transforms.position.y-transforms.fontSize/2, 60, transforms.fontSize + 3)
    wrapText("PICK TWO", centerX, centerY, 60, transforms.fontSize + 3)
    # context.fillText "TWO", (coords.center.x*transforms.scale+transforms.position.x), (coords.center.y*transforms.scale+transforms.position.y+transforms.fontSize/2)
    wrapText(triangle.title, topX, transforms.fontSize, 500, transforms.fontSize+3)
    wrapText(triangle.topText, topX, topY, 400, transforms.fontSize+3)
    wrapText(triangle.leftText, leftX, leftY, 100, transforms.fontSize+3)
    wrapText(triangle.rightText, rightX, rightY, 100, transforms.fontSize+3)


  drawTriangle = ->

    coords = triangle.coords
    transforms = triangle.transforms

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

  drawText()
  drawTriangle()
  drawWatermark()

