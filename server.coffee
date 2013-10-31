express = require("express")
app = express()

app.get "/good_json", (req, res) ->
  res.json message: "It Works!"

app.get "/bad_json", (req, res) ->
  res.send 200, "Bad JSON"

app.get "/not_found", (req, res) ->
  res.send 404

app.listen 3000

console.log "Server started at http://localhost:3000/"
