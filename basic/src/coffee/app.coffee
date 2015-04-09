window.jQuery = window.$ = require './../../lib/jquery-2.1.3.min.js'

Controller = require '/Users/josh/work/stout/dist/common/controller/Controller'
ClientApp  = require '/Users/josh/work/stout/dist/client/app/ClientApp'
ClientView = require '/Users/josh/work/stout/dist/client/view/ClientView'
FormView   = require '/Users/josh/work/stout/dist/client/view/FormView'
Model      = require '/Users/josh/work/stout/dist/common/model/Model'

helloTmpl = require './templates/hello'
personTmpl = require './templates/person'
personFormTmpl = require './templates/person-form'
goodbyeTmpl = require './templates/goodbye'


class Person extends Model
  @property 'firstName',
    default: 'John'
  @property 'lastName',
    default: 'Smith'
  @property 'male',
    default: true

class PersonView extends ClientView
  constructor: (@_person) ->
    super personTmpl, @_person
  render: ->
    super()

class PersonFormView extends FormView
  constructor: (person) ->
    super personFormTmpl, person
    @bindings =
      'firstName':  '.firstName'
      'lastName':   '.lastName'
      'male':       '.male'

class HelloView extends ClientView
  constructor: (@_person1, @_person2) ->
    super helloTmpl
    @el = document.body
    @person1Form = new PersonFormView @_person1
    @person1View = new PersonView @_person1
    @person2Form = new PersonFormView @_person2
    @person2View = new PersonView @_person2

  render: ->
    super()
    @el.appendChild @person1Form.render()
    @el.appendChild @person1View.render()
    @el.appendChild @person2Form.render()
    @el.appendChild @person2View.render()

class GoodbyeView extends ClientView
  constructor: ->
    super goodbyeTmpl
    @events =
      'click a': 'test'
    @el = document.body


class HelloController extends Controller
  constructor: ->
    super arguments...
    person1 = new Person
    person2 = new Person
    @_view = new HelloView(person1, person2)
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
    @_view.on 'test', (e) ->
      console.log e
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
