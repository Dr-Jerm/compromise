
describe 'mainController', ->
    scope = undefined

    beforeEach angular.mock.module 'myApp'

    beforeEach angular.mock.inject ($rootScope, $controller) ->
        scope = $rootScope.$new();

        $controller 'mainController', {$scope: scope}

    it 'should exist', ->
        expect(scope).toBeDefined()

    it 'should have scope variables defined', ->
        expect(scope.test).toBe('scope Variable')

describe 'anotherController', ->
    scope = undefined

    beforeEach angular.mock.module 'myApp'

    beforeEach angular.mock.inject ($rootScope, $controller) ->
        scope = $rootScope.$new();

        $controller 'anotherController', {$scope: scope}

    it 'should exist', ->
        expect(scope).toBeDefined()

    it 'should have more scope variables defined', ->
        expect(scope.foo.toString).toBe(['another', 'scope', 'variable'].toString)