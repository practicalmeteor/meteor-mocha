{_}            = require("underscore")
BaseReporter   = require("./BaseReporter")
{ObjectLogger} = require("meteor/practicalmeteor:loglevel")

log = new ObjectLogger('MeteorPublishReporter', 'info')

class MeteorPublishReporter extends BaseReporter

  @publisher: null 

  constructor: (runner, options)->
    try
      log.enter 'constructor', arguments
      expect(options.reporterOptions, 'options.reporterOptions').to.be.an('object')

      # Update runner tests
      runner.grep(options.reporterOptions.grep)

      super(runner, options)

#      @publisher = practical.mocha.MeteorPublishReporter.publisher
      @publisher = options.reporterOptions.publisher
      expect(@publisher, '@publisher').to.be.an('object')
      expect(@publisher.ready, '@publisher.ready').to.be.a('function')
      expect(@publisher.added, '@publisher.added').to.be.a('function')
      expect(@publisher.onStop, '@publisher.onStop').to.be.a('function')

      @sequence = 0

      # Make sure we always run within a Fiber
      @added = Meteor.bindEnvironment(@added, null, @)

      # Specify how to run tests 'serial' or 'parallel'
      # Running in 'serial' will start server tests first and then client tests
      @added 'run order', process.env.MOCHA_RUN_ORDER || 'parallel'


      @runner.on 'start', =>
        try
          log.enter 'onStart', arguments
#          @added 'start', {total: @stats.total}
          @added 'start', @stats
        finally
          log.return()

      @runner.on 'suite', (suite)=>
        try
          log.enter 'onSuite', arguments
#          log.info "suite:", suite.title
#          @added 'suite', {title: suite.title, _fullTitle: suite.fullTitle(), root: suite.root}

          @added 'suite', @cleanSuite(suite)
        finally
          log.return()

      @runner.on 'suite end', (suite)=>
        try
          log.enter 'onSuiteEnd', arguments
          @added 'suite end', @cleanSuite(suite)
        finally
          log.return()

      @runner.on 'test end', (test)=>
        try
          log.enter 'onTestEnd', arguments
          @added 'test end', @cleanTest(test)
        finally
          log.return()

      @runner.on 'pass', (test)=>
        try
          log.enter 'onPass', arguments
          @added 'pass', @cleanTest(test)
        finally
          log.return()

      @runner.on 'fail', (test, error)=>
        try
          log.enter 'onFail', arguments
          @added 'fail', @cleanTest(test)
        finally
          log.return()

      @runner.on 'end', =>
        try
          log.enter 'onEnd', arguments
          @added 'end', @stats
        finally
          log.return()

      @runner.on 'pending', (test)=>
        try
          log.enter 'onPending', arguments
          log.debug "test", test
          @added 'pending', @cleanTest(test)
        finally
          log.return()
    finally
      log.return()


  added: (event, data)=>
    try
      log.enter 'added', arguments
#      log.info event, data
      @sequence++
      doc =
        _id: "#{@sequence}"
        event: event
        data: data
      @publisher.added('mochaServerRunEvents', doc._id, doc)
    catch ex
      log.error "Can't send report data to client."
      log.error "Error:", (ex.stack || ex.message)
      log.error "Document:", doc
    finally
      log.return()


  ###*
  # Return a plain-object representation of `test`
  # free of cyclic properties etc.
  #
  # @param {Object} test
  # @return {Object}
  # @api private
  ###
  cleanTest: (test)->
    try
      log.enter("cleanTest", arguments)

      properties = ["title", "type", "state","speed", "pending",
        "duration", "async", "sync", "_timeout", "_slow", "body"]
      return  _.extend(_.pick(test, properties),{
        _fullTitle: test.fullTitle()
        parent: @cleanSuite(test.parent)
        # So we can show the server side test code in the reporter. This property is null ff the test or suite is pending
        fn: test.fn?.toString()
        err: @errorJSON(test.err)
        isServer: true
      })
    catch ex
      log.error(ex)

    finally
      log.return()


  cleanSuite: (suite)->
    try
      log.enter("cleanSuite", arguments)
      return _.extend(_.pick(suite, ["title", "root", "pending"]),{
        _fullTitle: suite.fullTitle()
        isServer: true
      })
    catch ex
      log.error(ex)
    finally
      log.return()

  ###*
  # Transform `error` into a JSON object.
  # @param {Error} err
  # @return {Object}
  ###

  errorJSON: (err) =>
    return if not err
    ###
      Only picking the defaults properties define by ECMAScript to avoid problems
      with custom error that may have properties that can't be stringify such as functions.
      See https://goo.gl/bsZh3B and https://goo.gl/AFp6KB
    ###
    return _.pick(err, ["name", "message", "stack"])



module.exports = MeteorPublishReporter
