root = exports ? this

root.app.directive "keypress", ($document) ->
  (scope, element, attrs) ->
    $document.bind "keypress", (e) ->
      charCode = e.charCode
      console.log charCode

root.app.directive 'partialTest', () ->
  restrict: 'E'
  templateUrl: 'partials/partial1'
  link: (scope, element, attrs) ->
    console.log('partial loaded!')
  
