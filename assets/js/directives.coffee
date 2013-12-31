root = exports ? this

root.qwer.directive "keypress", ($document) ->
  (scope, element, attrs) ->
    $document.bind "keypress", (e) ->
      charCode = e.charCode
      scope.userKeyPress charCode

root.qwer.directive 'keySquare', () ->
  restrict: 'E'
  templateUrl: 'partials/keySquare'
  scope: 
    key: '='
  
  link: (scope, element, attrs) ->
    keyCode = scope.key.charCodeAt(0)

    scope.userKeyPress = (keyCode) ->
      console.log keyCode+" dir"
    # debugger 
  
