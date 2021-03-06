
url = require 'url'
path = require 'path'
fs = require 'fs'
# common files mimetype
mimeType =
  css: "text/css"
  gif: "image/gif"
  html: "text/html"
  ico: "image/x-icon"
  jpeg: "image/jpeg"
  jpg: "image/jpeg"
  js: "text/javascript"
  json: "application/json"
  pdf: "application/pdf"
  png: "image/png"
  svg: "image/svg+xml"
  swf: "application/x-shockwave-flash"
  tiff: "image/tiff"
  txt: "text/plain"
  wav: "audio/x-wav"
  wma: "audio/x-ms-wma"
  wmv: "video/x-ms-wmv"
  xml: "text/xml"


###
向客户端发送其请求的文件
@param  {string} filename 请求的文件路径
@param  {object} res      http.ServerResponse对象
@return {undefined}       无返回值
###
sendFile = (filename, res) ->
  fs.readFile filename, "binary", (err, file) ->
    if err
      res.writeHead 500,
        "Content-Type": "text/plain"

      res.end err + "\n"
      return
    res.writeHead 200,
      "Content-Type": mimeType[filename.split(".").pop()] or mimeType.txt

    res.write file, "binary"
    res.end()
    return

  return

###
向客户端发送404消息
@param  {object} res http.ServerResponse对象
@return {undefined}     无返回值
###
send404 = (res) ->
  res.writeHead 404,
    "Content-Type": "text/plain"

  res.end "404 Not Found\n"
  return

###
静态网站模块主函数
@param  {object} req  http.ClientRequest对象
@param  {object} res  http.ServerResponse对象
@param  {object} opts 配置项
@return {undefined}   无返回值
###
staticweb = (req, res, opts) ->
  uri = url.parse(opts.staticPath.replace(/^\/|\/$/g, "") + req.url).pathname
  cwd = process.cwd()
  filename = path.join(cwd, uri)
  fs.exists filename, (exists) ->
    if not exists or filename.indexOf(cwd) is -1
      send404 res
      return
    if fs.statSync(filename).isDirectory()
      filename += "/index.html"
      fs.exists filename, (exists) ->
        unless exists
          send404 res
          return
        else
          sendFile filename, res
        return

    else
      sendFile filename, res
    return

  return

module.exports = staticweb

