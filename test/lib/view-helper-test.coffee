define (require) ->
  Handlebars = require 'handlebars'
  viewHelper = require 'lib/view-helper'

  describe 'View helper lib', ->

    # Handlebars always passes a final argument to helpers, that's why we pass
    # an empty object in the tests.
    describe 'icon helper', ->

      it 'creates HTML element', ->
        el = Handlebars.helpers.icon 'uber'
        expect($ el.string).to.have.class 'glyphicon-uber'

      it 'adds classes', ->
        novice = Handlebars.helpers.icon 'novice', 'always'
        expect($ novice.string).to.have.class 'always'
