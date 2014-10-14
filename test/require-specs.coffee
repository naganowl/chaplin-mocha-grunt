# Re-use application config file.
require {baseUrl: '../src'}, ['config'], ->
  require [
    'jquery'
    'dependencies'
  ], ->
    require.config
      baseUrl: '../src'
      paths:
        # Vendor dependencies
        chai: '../vendor/bower/chai/chai'
        'chai-jquery': '../vendor/bower/chai-jquery/chai-jquery'
        sinon: '../vendor/bower/sinon/index'
        'sinon-chai': '../vendor/bower/sinon-chai/lib/sinon-chai'
      shim:
        'chai-jquery': ['jquery', 'chai']
        'sinon-chai': ['sinon', 'chai']

    require [
      # Used for setup.
      'chai'
      'sinon-chai'
      'chai-jquery'

      # Vendor
      'sinon'
    ], (chai, sinonChai, chaiJquery) ->
      # Create `window.describe` etc. for our BDD-like tests.
      mocha.setup ui: 'bdd'
      chai.use sinonChai
      chai.use chaiJquery

      if window.PHANTOMJS
        blanket.options "reporter",
          "../node_modules/grunt-blanket-mocha/support/grunt-reporter.js"

      if window.location.search.indexOf('cov=true') >= 0
        $('#change-coverage').on 'change', ->
          $("#blanket-main .rs:contains('100 %')")
            .parent(":not('.grand-total')").toggle()
      else
        $('label').hide()

      # Create another global variable for simpler syntax.
      window.expect = chai.expect

      # Normally the server provides this information
      window.config = url_root: '/backoffice/'

      # Dynamically require all test files.
      $.ajax(
        url: '../testSpecs.txt'
        dataType: 'text'
      )
      .done((data) ->
        specList = data.split '\n'
        # Remove blank line from end.
        specList.pop()

        specs = $.map specList, (spec) -> spec.replace '.coffee', ''

        # Load all of our specs.
        require specs, ->
          mocha.run()
      )
      .fail ->
        console.log 'Failure with loading spec list! ', arguments
