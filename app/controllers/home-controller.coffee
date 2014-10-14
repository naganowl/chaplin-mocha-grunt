define (require, exports) ->
  Controller = require 'controllers/base/controller'
  Items = require 'models/items'
  HomeView = require 'views/home-view'

  exports = class HomeController extends Controller
    title: 'Home'

    index: ->
      @collection = new Items()
      @view = new HomeView {@collection}
