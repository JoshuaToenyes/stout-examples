Controller = require '/Users/josh/work/stout/dist/common/controller/Controller'
ClientApp  = require '/Users/josh/work/stout/dist/client/app/ClientApp'
ClientView = require '/Users/josh/work/stout/dist/client/view/ClientView'
#View = require '/Users/josh/work/stout/dist/'


helloTmpl = require './templates/hello'
goodbyeTmpl = require './templates/goodbye'


class HelloView extends ClientView
  constructor: ->
    super null, helloTmpl
    @el = document.body


class GoodbyeView extends ClientView
  constructor: ->
    super null, goodbyeTmpl
    @el = document.body


class HelloController extends Controller
  constructor: ->
    super arguments...
    @_view = new HelloView()
  show: ->
    @_view.render()


class GoodbyeController extends Controller
  constructor: ->
    super arguments...
    @_view = new GoodbyeView()
  show: ->
    @_view.render()


app = new ClientApp

helloController = new HelloController app
goodbyeController = new GoodbyeController app

app.routes =
  '/': ->
    helloController.show()

  '/bye': ->
    goodbyeController.show()

  '/name/:name': (name) ->
    document.write name
