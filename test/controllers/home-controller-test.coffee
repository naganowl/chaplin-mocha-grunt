define (require) ->
  HomeController = require 'controllers/home-controller'
  HomeView = require 'views/home-view'

  describe 'HomeController', ->
    beforeEach ->
      @controller = new HomeController()

    afterEach ->
      @controller.dispose()

    it 'should render', ->
      @controller.index()
      expect(@controller.view).to.be.an.instanceOf HomeView

    it 'adjusts the title', ->
      sinon.stub @controller, 'adjustTitle'
      @controller.beforeAction()
      expect(@controller.adjustTitle).to.be.calledOnce
