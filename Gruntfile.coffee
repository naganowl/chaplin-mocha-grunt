module.exports = (grunt) ->
  'use strict'

  # For use as rename method in copy:assets.
  # Used to flatten the directory and place matched file in dest.
  flattenFile = (dest, src) ->
    if src.indexOf(@path) is 0
      dest + src.slice @path.length
    else
      dest + src

  # Load all grunt tasks matching the `grunt-*` pattern
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    clean:
      public:
        src: 'public/*'

    handlebars:
      compile:
        options:
          amd: yes
          namespace: 'Handlebars.templates'
          processName: (file) ->
            file.replace('app/views/templates/', '').replace '.hbs', ''
        files:
          'public/src/views/templates.js': 'app/views/templates/*.hbs'

    stylus:
      compile:
        options:
          compress: no
          'include css': yes
          urlfunc: 'embedurl'
          linenos: yes
          define:
            '$version': '<%= pkg.version %>'
        files:
          'public/stylesheets/application.css': [
            'app/views/styles/**/*.styl'
            '!app/views/styles/retina.styl'
            'app/views/styles/retina.styl'
          ]

    coffee:
      compile:
        expand: yes
        cwd: 'app/'
        src: ['*.coffee', '**/*.coffee']
        dest: 'public/src/'
        ext: '.js'
      # For Mocha tests in browser.
      test:
        expand: yes
        cwd: 'test/'
        src: ['*.coffee', '**/*.coffee']
        dest: 'public/src/test'
        ext: '.js'

    # Docs: https://github.com/jrburke/r.js/blob/master/build/example.build.js
    requirejs:
      compile:
        options:
          baseUrl: 'public/src'
          mainConfigFile: 'public/src/config.js'

          findNestedDependencies: yes
          name: "almond"

          # Handlebars templates won't load correctly with this enabled.
          wrap: no

          out: 'public/javascripts/application.min.js'
          include:['initialize'].concat(grunt.util.
            _(grunt.file.expandMapping(['controllers/*controller.js'], ''
              cwd: 'public/src/'
              rename: (base, path) ->
                path.replace /\.js$/, ''
            )).pluck 'dest')
          optimize: 'none'

          generateSourceMaps: yes
          # Do not preserve any license comments when working with source
          # maps.  These options are incompatible.
          preserveLicenseComments: no
          waitSeconds: 7

    copy:
      main:
        src: 'index.html'
        dest: 'public/index.html'
      test:
        src: [
          'test/index.html'
          'vendor/**/mocha.css'
          'node_modules/grunt-blanket-mocha/**/support/*.js'
        ]
        dest: 'public/'
      assets:
        # `path` property is needed for the rename method.
        files: [
          # Fonts, images, etc.
          expand: yes
          src: 'app/assets/**'
          dest: 'public/'
          path: 'app/assets'
          rename: flattenFile
        ,
          # Fonts, images, etc.
          expand: yes
          src: 'vendor/bower/bootstrap/fonts/**'
          dest: 'public/fonts/'
          path: 'vendor/bower/bootstrap/fonts'
          rename: flattenFile
        ,
          # Vendor source files.
          src: [
            'vendor/**/*.js'
            '!vendor/**/{doc,example,lang,test}*/**'
          ]
          dest: 'public/'
        ]

    concat:
      # Stylus doesn't concat well with Bootstrap.
      css:
        src: [
          'vendor/bower/bootstrap/dist/css/bootstrap.css'
          'public/stylesheets/application.css'
        ]
        dest: 'public/stylesheets/application.css'

    cssmin:
      compile:
        options:
          keepSpecialComments: 0
        src: [
          'vendor/bower/bootstrap/dist/css/bootstrap.css'
          'public/stylesheets/application.css'
        ]
        dest: 'public/stylesheets/application.min.css'

    blanket_mocha:
      options:
        threshold : 50
        globalThreshold : 65
        log : yes
        logErrors: yes
        moduleThreshold : 60
        modulePattern : "./src/(.*?)/"
      ci:
        src: 'public/test/index.html'
        dest: 'test-results.xml'
        options:
          reporter: 'XUnit'
      test:
        src: 'public/test/index.html'

    coffeelint:
      source: ['{app,test}/**/*.coffee', 'Gruntfile.coffee']
      options:
        arrow_spacing: level: 'warn'
        cyclomatic_complexity: level: 'warn'
        max_line_length: level: 'warn'
        no_backticks: level: 'warn'
        no_empty_param_list: level: 'warn'
        no_stand_alone_at: level: 'warn'

    shell:
      options:
        failOnError: yes
      specs:
        command: 'find test -regex ".*-test\.coffee" > public/testSpecs.txt'

    concurrent:
      pipe:
        tasks: ['server', 'watch']
        options:
          logConcurrentOutput: yes

    server:
      options:
        host: '127.0.0.1'
        port: 8000

      release:
        options:
          prefix: 'public/'

    # Only run tasks on modified files.
    watch:
      options:
        spawn: no
        interrupt: yes
        dateFormat: (time) ->
          grunt.log
            .writeln("Compiled in #{time}ms @ #{(new Date).toString()} 💪\n")

      stylus:
        files: 'app/views/styles/**/*.styl'
        tasks: ['newer:stylus', 'concat:css']

      coffee_hbs:
        files: ['{app,test}/**/*.coffee', 'app/views/templates/**/*.hbs']
        tasks: [
          'newer:handlebars'
          'newer:coffee'
          'coffeelint'
          'blanket_mocha:test'
        ]

      lint:
        files: 'Gruntfile.coffee'
        tasks: 'coffeelint'

      main:
        files: 'index.html'
        tasks: 'copy:main'

      test:
        files: 'test/index.html'
        tasks: 'copy:test'


  # Create aliased tasks.
  grunt.registerTask('default', ['build', 'coffeelint', 'test', 'concurrent'])
  grunt.registerTask('test', ['blanket_mocha:test'])
  grunt.registerTask('test:ci', ['compile', 'copy', 'blanket_mocha:ci'])

  grunt.registerTask 'compile', [
    'handlebars'
    'coffee'
    'shell:specs'
  ]

  grunt.registerTask 'build', [
    'clean'

    'stylus'
    'compile'

    'concat:css'
    'copy'
  ]

  grunt.registerTask 'prod', [
    'clean'

    'handlebars'
    'stylus'
    'coffee:compile'

    'copy:assets'
    'copy:main'
    'cssmin'

    'requirejs'
  ]
