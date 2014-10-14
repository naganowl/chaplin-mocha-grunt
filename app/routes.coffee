define (require, exports) ->
  exports = (match) ->
    match '', 'home#index', name: 'home'
