MochaRunner               = require("../lib/MochaRunner")
{ ObjectLogger }          = require("meteor/practicalmeteor:loglevel")
ClientServerBaseReporter  = require("./ClientServerBaseReporter")

log = new ObjectLogger('ConsoleReporter', 'info')


class ConsoleReporter extends  ClientServerBaseReporter


  constructor: (clientRunner, serverRunner, options)->
    try
      log.enter('constructor')
      super(clientRunner, serverRunner, options)
      @clientRunner = clientRunner
      @serverRunner = serverRunner
      @options = options
      MochaRunner.on "end all", => @finishAndPrintTestsSummary()

    finally
      log.return()

  ###
    Overwriting from ClientServerBaseReporter
  ###
  registerRunnerEvents: (where)->
    try
      log.enter("registerRunnerEvents")
      # Call super.registerRunnerEvents to register events from ClientServerBaseReporter first
      super(where)

      @["#{where}Runner"].on "start", => @printReporterHeader(where)
      @["#{where}Runner"].on 'test end', (test)=> @printTest(test, where)

      # Log for errors with hooks
      @["#{where}Runner"].on "fail", (hook)=> @printTest(hook, where) if hook.type is 'hook'

    finally
      log.return()


  printReporterHeader: (where)=>
    try
      log.enter("printReporterHeader", where)
      return if @options.runOrder isnt 'serial'
      # i.e client = Client
      where = where[0].toUpperCase() + where.substr(1)
      console.log("\n--------------------------------------------------")
      console.log("------------------ #{where} tests ------------------")
      console.log("--------------------------------------------------\n")
    finally
      log.return()


  printTest: (test, where)->
    try
      log.enter("prinTest", test)
      state = test.state or (if test.pending then "pending")

      # Since the test are running in parallel we don't need
      # to specify where they are client or   server tests.
      if @options.runOrder is 'serial'
        where = ""
      else
        # Get first chart 's' or 'c' for client/server
        where = where[0].toUpperCase() + ": "

      console.log("#{where}#{test.fullTitle()} : #{state}")

      if test.state is "failed"
        console.log("  " + (test.err.stack || test.err))

      console.log("")
    finally
      log.return()


  finishAndPrintTestsSummary: ()=>
    try
      log.enter("finishAndPrintTestsSummary")
      return if not @clientStats?.total? or not @serverStats?.total?

      console.log("\n--------------------------------------------------")
      console.log("---------------------RESULTS----------------------")
      console.log("PASSED:", @stats.passes)
      console.log("FAILED:", @stats.failures)
      console.log("SKIPPED:", @stats.pending)
      console.log("TOTAL:", @stats.total)
      console.log("--------------------------------------------------")
      console.log("--------------------------------------------------\n")
    finally
      log.return()


module.exports = ConsoleReporter

