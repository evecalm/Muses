http = require 'http'
###
为小于10的数字添加前置0
@param  {number} num 要转换的数字
@return {string}     转换之后的字符串
###
preZero = (num) ->
  (if num < 10 then ("0" + num) else num + "")

###
获取时间字符串, 格式为 YYYY-MM-DD HH:mm
@param  {number} timeStamp 时间戳, 为false则使用当前时间
@param  {boolean} dateOnly 为true时只返回日期, false则有日期和时间
@return {string}           时间字符串
###
getTimeStr = (timeStamp, dateOnly) ->
  time = undefined
  str = undefined
  if timeStamp
    time = new Date(timeStamp)
  else
    time = new Date()
  str = time.getFullYear() + "-" + preZero(time.getMonth() + 1) + "-" + preZero(time.getDate())
  str += " " + preZero(time.getHours()) + ":" + preZero(time.getMinutes())  unless dateOnly
  str

###
转发请求并将请求数据进行处理后发送回客户端
@param  {object} opt     请求头, 包括请求地址, 端口, 请求方法, header等
@param  {string} reqBody 客户端请求的内容, 主要指post方法发送过来的数据, get的数据包含在请求地址中
@param  {object} res      http.ServerResponse对象
@return {undefined}         无返回值
###
httpRequest = (opt, reqBody, res) ->
  req = http.request(opt, (cres) ->
    resBody = ""
    console.log cres.statusCode
    res.writeHead cres.statusCode, cres.headers
    cres.on("data", (chunk) ->
      res.write chunk, "binary"
      return
    ).on "end", ->
      res.end()
      return

    return
  )
  req.on "error", (error) ->
    res.writeHead 200
    res.end JSON.stringify(
      errorCode: 500
      error: error.message
    )
    return

  req.write reqBody
  req.end()
  return

###
代理模块主函数
@param  {object} req  http.ClientRequest对象
@param  {object} res  http.ServerResponse对象
@param  {object} opts 配置项, 包含请求的主机名, 端口等
@return {undefined}      无返回值
###
proxy = (req, res, opts) ->
  opt =
    host: opts.host
    port: opts.port
    method: req.method
    headers: req.headers

  reqBody = ""
  path = opts.urlPrefix.replace(/^\/|\/$/g, "")
  path = "/" + path  if path isnt ""
  path += req.url.replace(opts.apiPrefix, "/")
  opt.path = path
  req.on "data", (chunk) ->
    reqBody += chunk
    return

  req.on "end", ->
    httpRequest opt, reqBody, res
    return

  console.log "request redirect to :" + JSON.stringify(opt.path)
  return

module.exports = proxy