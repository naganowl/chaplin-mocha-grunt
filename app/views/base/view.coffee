# TODO: Replace this with shared base view.
define (require, exports) ->
  Chaplin = require 'chaplin'

  exports = class View extends Chaplin.View
    autoRender: yes
    # Precompiled templates function initializer.
    getTemplateFunction: ->
      template = @template

      if template
        require('views/templates')[template]
