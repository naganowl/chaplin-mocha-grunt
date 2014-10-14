define (require) ->
  Items = require 'models/items'

  describe 'Items', ->
    beforeEach ->
      @collection = new Items {}

    afterEach ->
      @collection.dispose()

    it 'should have a cid', ->
      expect(@collection.length).to.equal 1
