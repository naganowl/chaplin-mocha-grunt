define (require, exports) ->
  Chaplin = require 'chaplin'

  exports = class Items extends Chaplin.Collection
    _(@prototype).extend Chaplin.SyncMachine
    url: '/items'
