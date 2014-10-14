define (require) ->
  HomeView = require 'views/home-view'

  describe 'HomeView', ->
    beforeEach ->
      @view = new HomeView()

    afterEach ->
      @view.dispose()

    it 'should render a view', ->
      expect(@view.$el).not.to.be.empty()
      expect(@view.$el).to.contain 'Such World'
