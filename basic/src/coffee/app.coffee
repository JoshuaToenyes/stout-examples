window.jQuery = window.$ = require './../../lib/jquery-2.1.3.min.js'

Controller = require '/Users/josh/work/stout/dist/common/controller/Controller'
ClientApp  = require '/Users/josh/work/stout/dist/client/app/ClientApp'
ClientView = require '/Users/josh/work/stout/dist/client/view/ClientView'

helloTmpl = require './templates/hello'
goodbyeTmpl = require './templates/goodbye'


class HelloView extends ClientView
  constructor: ->
    super helloTmpl
    @el = document.body


class GoodbyeView extends ClientView
  constructor: ->
    super goodbyeTmpl
    @el = document.body


class HelloController extends Controller
  constructor: ->
    super arguments...
    @_view = new HelloView()
    @_view.on 'click:anchor', (e) =>
      @messageBus.publish 'nav:goto', e.data
  show: ->
    @_view.render()


class GoodbyeController extends Controller
  constructor: ->
    super arguments...
    @_view = new GoodbyeView()
    @_view.on 'click:anchor', (e) =>
      @messageBus.publish 'nav:goto', e.data
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
