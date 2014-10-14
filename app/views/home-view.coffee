define (require, exports) ->
  View = require 'views/base/view'

  # TODO: Bring in content mixins.
  exports = class HomeView extends View
    container: '#content'
    template: 'home'
