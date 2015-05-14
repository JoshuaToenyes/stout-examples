HTTPServerApp    = require '/Users/josh/work/stout/server/app/HTTPServerApp'

app = new HTTPServerApp

app.server.port = 8011

app.server.routes =
  '/*splat': app.static('static')

app.server.start()
