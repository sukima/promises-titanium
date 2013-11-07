Q                       = require("q")
{existsSync:exists}     = require("fs")
{resolve,join:joinPath} = require("path")
{spawn}                 = require("child_process")

specDir          = resolve(__dirname)
projectDir       = resolve(specDir, "..")
alloyDir         = joinPath(projectDir, "app")
resourcesDir     = joinPath(projectDir, "Resources")
alloy            = joinPath(projectDir, "node_modules", ".bin", "alloy")
uses_alloy       = exists(alloyDir)
jasmine_node     = joinPath(projectDir, "node_modules", ".bin", "jasmine-node")
verbose          = no
jasmineArgs      = []
args             = process.argv.slice 2

promisedSpawn = (command, args...) ->
  defer = Q.defer()
  console.log "executing: #{command}" if verbose
  spawnedProcess = spawn command, args, stdio: [process.stdin, null, null]
  spawnedProcess.stdout.on "data", (buffer) ->
    defer.notify {fd: "stdout", buffer}
  spawnedProcess.stderr.on "data", (buffer) ->
    defer.notify {fd: "stderr", buffer}
  spawnedProcess.on "error", defer.reject
  spawnedProcess.on "exit", (code) ->
    if code is 0 then defer.resolve code
    else defer.reject code
  defer.promise

printOutput = ({fd,buffer}) ->
  process[fd].write buffer.toString()

while args.length
  arg = args.shift()

  switch arg
    when "-v", "--verbose"
      verbose = yes
    when "-h", "--help"
      console.log "Usage: specRunner.coffee [-vh]"
      console.log "  -v, --verbose  Print out as much logging as possible"
      console.log "  -h, --help     This cruft"
      process.exit 1
    else
      jasmineArgs.push arg

if uses_alloy
  console.log "Compiling Alloy..."
  waitingForAlloy = promisedSpawn alloy, "compile", "--config", "platform=ios"
  if verbose
    waitingForAlloy.progress printOutput
else
  waitingForAlloy = Q("alloy not required")

waitingForAlloy.then ->
  console.log "Running specs...\n"
  process.env["NODE_PATH"] = resourcesDir
  waitingForJasmineNode = promisedSpawn jasmine_node, "--coffee", "--test-dir", specDir, jasmineArgs...
  waitingForJasmineNode.progress printOutput
.then ->
  process.exit 0
.fail (reason) ->
  console.error "Something went wrong:"
  console.error reason
  process.exit 127
.done()
