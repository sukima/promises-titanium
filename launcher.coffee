Q                       = require("q")
{existsSync:exists}     = require("fs")
{resolve,join:joinPath} = require("path")
{spawn,exec}            = require("child_process")

titanium = resolve(__dirname, "node_modules", ".bin", "titanium")
args     = process.argv.slice 2
options  = {extraArgs: []}
gracefullyExit = no

childProcesses = []
process.on "SIGINT", ->
  gracefullyExit = yes
  console.log()
  for childProcess in childProcesses
    console.log "Killing process (#{childProcess.pid})" if options.verbose
    childProcess.kill "SIGINT"

shouldGracefullyexit = ->
  gracefullyExit and not options.android and not options.install

promisedSpawn = (command, args...) ->
  defer = Q.defer()
  console.log "executing: #{command} #{args.join(" ")}" if options.verbose
  spawnedProcess = spawn command, args, stdio: [process.stdin, null, null]
  spawnedProcess.stdout.on "data", (buffer) ->
    defer.notify {fd: "stdout", buffer}
  spawnedProcess.stderr.on "data", (buffer) ->
    defer.notify {fd: "stderr", buffer}
  spawnedProcess.on "error", defer.reject
  spawnedProcess.on "exit", (code) ->
    if code is 0 or shouldGracefullyexit()
      defer.resolve 0
    else
      defer.reject code
  childProcesses.push spawnedProcess
  defer.promise.progress printOutput

printOutput = ({fd,buffer}) ->
  # Fix output from titanium which uses an unsupported color code.
  buffer = buffer.toString().replace /\[90m\[1m/g, '[34m'
  process[fd].write buffer

fetchAppInfo = ->
  {readFile} = require("fs")
  Q.nfcall(readFile, "tiapp.xml", "utf8").then (data) ->
    app_id   = data.match(/<id>(.*)<\/id>/)[1]
    app_name = data.match(/<name>(.*)<\/name>/)[1]
    app_name = app_name.replace(/\s+/, "")
    {app_id, app_name}

outputError = (err) -> console.error "\nThere were errors (#{err})"

while args.length
  arg = args.shift()

  switch arg
    when "-h","--help"
      console.log "Usage: launcher.coffee [-vhdia] [-s simtype] [--sdk version]"
      console.log "  -v, --verbose      Print out as much logging as possible"
      console.log "  -h, --help         This cruft"
      console.log "  -c, --clean        Clean up build files"
      console.log "  -d, --debug        Attach to a running ti-inspector server for debugging"
      console.log "  -i, --install      Build and install on an attached iOS device"
      console.log "  -a, --android      Build and install on an attached Android device"
      console.log "  -s, --sim simtype  One of: iphone, iphone4, iphone5 (default)"
      console.log "  --sdk version      Choose the SDK version (default: 7.0)"
      console.log "  --                 Stop reading arguments and pass everything else"
      console.log "                     directly to the titanium cli"
      process.exit 1
    when "-v", "--verbose"
      options.verbose = on
    when "-c", "--clean"
      options.clean = yes
    when "-d", "--debug"
      options.debug = on
    when "-i", "--install"
      options.install = yes
    when "-a", "--android"
      options.android = yes
    when "-s", "--sim"
      options.simtype = args.shift()
    when "--sdk"
      options.sdk = args.shift()
    when "--"
      options.extraArgs = options.extraArgs.concat args
      args = []
    else
      options.extraArgs.push arg

if options.clean
  promisedSpawn(titanium, "clean").then ->
    process.exit 0
  .fail (err) ->
    outputError err
    process.exit 127
  .done()
  return # Stop processing this file

simargs = switch options.simtype
  when "iphone"
    []
  when "iphone4", "iphone4s"
    ["--retina"]
  else
    ["--retina", "--tall"]

options.sdk or= "7.0"

if options.android
  titaniumArgs = [ "build", "--platform", "android", "--build-only", "--avd-id=1" ]
else if options.install
  titaniumArgs = [ "build", "--platform", "ios", "--ios-version", options.sdk, "-T", "device" ]
else
  titaniumArgs = [ "build", "--platform", "ios", "--ios-version", options.sdk ]
  titaniumArgs.push "--debug-host", "localhost:8999" if options.debug
titaniumArgs.push "--log-level", "debug" if options.verbose
titaniumArgs.push options.extraArgs...

require("./server") unless options.install or options.android

waitingForTitanium = promisedSpawn titanium, titaniumArgs...
waitingForTitanium.then (val) ->
  return val unless options.android
  fetchAppInfo().then ({app_id,app_name}) ->
    waitingForAdb = promisedSpawn "adb", "uninstall", app_id
    waitingForAdb.then ->
      promisedSpawn "adb", "install", joinPath(__dirname, "build", "android", "bin", "app.apk")
    .then ->
      promisedSpawn "adb", "shell", "am", "start", "#{app_id}/.#{app_name}Activity"
.then ->
  process.exit 0
.fail (err) ->
  outputError err unless gracefullyExit
  process.exit 127
.done()
