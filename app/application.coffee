define (require, exports) ->
  Chaplin = require 'chaplin'
  routes = require 'routes'

  # The application object
  exports = class Application extends Chaplin.Application

    initMediator: ->
      Chaplin.mediator.ent = null
      super
