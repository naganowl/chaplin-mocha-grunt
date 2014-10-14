# This is the runtime configuration file.  It complements the Gruntfile.js by
# supplementing shared properties.

require.config
  paths:
    # Almond is used to lighten the output filesize for production.
    almond: '../vendor/bower/almond/almond'

    # Map remaining vendor dependencies.
    backbone: '../vendor/bower/backbone/backbone'
    chaplin: '../vendor/bower/chaplin/chaplin'
    handlebars: '../vendor/bower/handlebars/handlebars.runtime'
    jquery: '../vendor/bower/jquery/dist/jquery'
    moment: '../vendor/bower/moment/moment'
    underscore: '../vendor/bower/lodash/dist/lodash'

  shim:
    handlebars:
      exports: 'Handlebars'
