define (require, exports) ->
  Chaplin = require 'chaplin'

  exports = class Controller extends Chaplin.Controller
    beforeAction: ->
      @adjustTitle @title
