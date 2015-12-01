http = require 'http'
config = require './config'
ajax = require './ajax'
staticweb = require './staticweb'

# 处理 apiPrefix 为其前后加上 /
config.apiPrefix = "/" + config.apiPrefix.replace(/^\/|\/$/g, "") + "/"
do initArgs = ->
  cmd = process.argv.slice(2)[0]
  throw new Error("server path should be specified")  unless cmd
  switch cmd
    when "blog"
      config.staticPath = "theme"
    else
      throw new Error("Unknown server path")
  return


# 创建服务器
http.createServer (req, res) ->
  if req.url.indexOf(config.apiPrefix) is 0
    console.log "request url: " + req.url
    ajax req, res, config
  else
    staticweb req, res, config
  return
.listen config.listenPort

console.log "server started at: " + config.listenPort