App = require '/Users/josh/work/stout/dist/client/App'

app = new App

app.routes =
  '/': ->
    console.log 'hello!'
    document.write 'hello'

  '/bye': ->
    console.log 'bye!'
    document.write 'bye'

  '/name/:name': (name) ->
    document.write name

app.start()
