Controller = require '/Users/josh/work/stout/dist/common/controller/Controller'
ClientApp  = require '/Users/josh/work/stout/dist/client/app/ClientApp'
#View = require '/Users/josh/work/stout/dist/'


helloTmpl = require './templates/hello'
goodbyeTmpl = require './templates/goodbye'



class HelloController extends Controller

  constructor: ->
    super arguments...


class GoodbyeController extends Controller

  constructor: ->
    super arguments...



app = new ClientApp

helloController = new HelloController app
goodbyeController = new GoodbyeController app



app.routes =
  '/': ->
    document.write helloTmpl()

  '/bye': ->
    document.write goodbyeTmpl()

  '/name/:name': (name) ->
    document.write name

app.start()
