chaplin-mocha-grunt [![Build Status](https://travis-ci.org/naganowl/chaplin-mocha-grunt.png?branch=master)](https://travis-ci.org/naganowl/chaplin-mocha-grunt)
===

Web app boilerplate using the Chaplin framework with Mocha for tests and Grunt as the task runner.
Uses Stylus as the CSS pre-processor and CoffeeScript. Pages are hosted with Express.

## Getting Started

### Usage

If you've never installed or used `npm` or `bower`, you can skip the associated `cache` commands.

1. `npm cache clear`
1. `npm install`
1. `bower cache clean`
1. `bower install`

### Starting up the app

Running `grunt` will build the project, watch changed files and start up the server on [localhost:8000](http://localhost:8000).

The page should display a basic layout with header nav and body. By default, each file will be requested separately. In order to
have them served as a single file, run `grunt prod` which will minify the files (and provide source maps). Be sure to update the
`index.html` file to point to the minified file.

### Testing the app

If you ran `grunt`, then the tests will automatically run on save of `.coffee` files.
Otherwise, you can run `grunt test` which will run the test specs through PhantomJS and generate code coverage reports with Blanket.
Visit [localhost:8000/test/](http://localhost:8000/test/) to debug the tests in a browser.

By default, the tests are run without coverage for easier debugging via the console.
Coverage can be displayed via the link on the test page, with fully covered files hidden by default. There is a checkbox to
show all the files which is useful when inspecting branch coverage.


## Features

- Font file specification for different font-weights of a given style.
- Test mocks with Sinon and Chai, with jQuery assertions.
- Templating with Handlebars with `view-helpers.coffee` to add helpers.
  - Templates are compiled to a single file from `*.hbs` and into `Handlebars.templates`. They are keyed on the name of the file.
- Includes `moment.js` for relative time and "time arithmetic".
- Replaces `underscore` with `lodash` for better performance and additional utility methods.
- Uses Bootstrap 3 with a Handlebars helper for Glyphicons.
- Retina stylesheet to support image elements and background images on elements (when following conventions in `retina.styl`).
- Automatically run tests in the `test` directory with the `-test.coffee` suffix.
- Test coverage run on save, with thresholds configurable.
- Lint `*.coffee` files on save.
- CI test support with `grunt test:ci` command.
- Informs developer about errors with appropriate OS notifications (or Growl/Snarl) via `grunt-notify`.
