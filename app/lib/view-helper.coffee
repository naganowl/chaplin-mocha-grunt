define (require) ->
  Handlebars = require 'handlebars'

  # General view helpers
  # http://handlebarsjs.com/#helpers

  # Output element for use with font icon classes.
  # We use generic class name with a specific one for cleaner stylesheets.
  # You can specify a second argument to add additional classes.
  #
  # **e.g.** `{{icon 'awesome' 'extra-classy'}}`
  Handlebars.registerHelper 'icon', (name, className) ->
    className = if typeof className is 'string' then " #{className}" else ''
    new Handlebars.SafeString(
      "<span class='glyphicon glyphicon-#{name}#{className}'></span>"
    )
