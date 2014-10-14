# Break out the application running from the configuration definition to
# assist with testing.
require ["config"], ->

  # Load up any globals or config that app doesn't already implicitly require.
  require [
    "application"
    "routes"
    "dependencies"
  ], (Application, routes) ->

    # Initialize the application on DOM ready event.
    $ ->
      new Application {
        title: 'Web App'
        controllerSuffix: '-controller'
        routes
      }
