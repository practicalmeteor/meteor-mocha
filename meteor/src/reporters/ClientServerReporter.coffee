{_}             = require("underscore")
MochaRunner     = require("./../lib/MochaRunner")
MirrorReporter  = require('./MirrorReporter')
{ObjectLogger}  = require("meteor/practicalmeteor:loglevel")
{EventEmitter}  = require("events")

log = new ObjectLogger('ClientServerReporter', 'info')

class ClientServerReporter


  constructor: (@clientRunner, @options = {})->
    try
      log.enter('constructor')
      @serverRunnerProxy = new EventEmitter()

      if @options.runOrder is "serial"
        @clientRunner = new EventEmitter()
        @runTestsSerially(@clientRunner, @serverRunnerProxy)

      if not MochaRunner.reporter
        log.info("Missing reporter to run tests. Use MochaRunner.setReporter(reporter) to set one.")
        return

      @reporter = new MochaRunner.reporter(@clientRunner, @serverRunnerProxy, @options)

      # we use nonreactive here because this constructor is called in an
      # autorun, and we don't want our autorun to be cancelled when the
      # parent is cancelled
      Tracker.nonreactive =>
        Tracker.autorun =>
          isConnected = Meteor.connection.status().connected
          if isConnected
            @initObserver()

      # Exposes global states of tests
      @clientRunner.on "start", ->
        window.mochaIsRunning = true

      @clientRunner.on "end", =>
        window.mochaIsRunning = false
        window.mochaIsDone = true

        MochaRunner.emit("end client")
        @clientTestsEnded = true
        if @serverTestsEnded
          MochaRunner.emit("end all")

      @serverRunnerProxy.on 'end', =>
        @serverTestsEnded = true
        MochaRunner.emit("end server")
        if @clientTestsEnded
          MochaRunner.emit("end all")

    finally
      log.return()

  initObserver: () =>
    if @observer
      @observer.stop()

    @observer = MochaRunner.serverRunEvents.find().observe( {
      added: _.bind(@onServerRunnerEvent, @)
    })

  runTestsSerially: (clientRunner, serverRunnerProxy)=>
    try
      log.enter("runTestsSerially",)
      serverRunnerProxy.on "end", =>
        mocha.reporter(MirrorReporter, {
          clientRunner: clientRunner
        })
        mocha.run(->)

    finally
      log.return()


  onServerRunnerEvent: (doc)->
    try
      log.enter('onServerRunnerEvent')
      expect(doc).to.be.an('object')
      expect(doc.event).to.be.a('string')

      if doc.event is "run order"
        return
      expect(doc.data).to.be.an('object')

      # Required by the standard mocha reporters
      doc.data.fullTitle = -> return doc.data._fullTitle
      doc.data.slow = -> return doc.data._slow
      doc.data.err?.toString = -> "Error: " + @message

      if doc.data.parent
        doc.data.parent.fullTitle = -> return doc.data.parent._fullTitle
        doc.data.parent.slow = -> return doc.data.parent._slow


      if doc.event is 'start'
        @serverRunnerProxy.stats = doc.data
        @serverRunnerProxy.total = doc.data.total

      @serverRunnerProxy.emit(doc.event, doc.data, doc.data.err)

    catch ex
      log.error ex
    finally
      log.return()


module.exports = ClientServerReporter
