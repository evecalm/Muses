
http = require 'http'
querystring = require 'querystring'
moment = require 'moment'
utils = require 'utility'
_ = require 'lodash'

###*
curl -X POST 'http://gw.api.taobao.com/router/rest' \
-H 'Content-Type:application/x-www-form-urlencoded;charset=utf-8' \
-d 'app_key=12129701' \
-d 'format=json' \
-d 'method=alibaba.xiami.api.search.songs.get' \
-d 'partner_id=apidoc' \
-d 'sign=614100B9F12FBF184D2E30D999AEF92A' \
-d 'sign_method=hmac' \
-d 'timestamp=2015-11-30+16%3A59%3A10' \
-d 'v=2.0' \
-d 'category=-1' \
-d 'is_pub=all' \
-d 'key=%E5%88%98%E5%BE%B7%E5%8D%8E' \
-d 'limit=10' \
-d 'page=1'
###

request = (method, params, done)->
  apiUrl = 'http://api.xiami.com/web'

  headers =
    'Referer': 'http://m.xiami.com/'
    'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4'

  now = new Date
  defaultParams =
    v: '2.0'
    app_key: 1
    _ksTS: now.getTime() + '_' + now.getMilliseconds()

  data = _.extend {}, defaultParams, params
  data.r = method

  req = http.request
    host: 'api.xiami.com'
    path: '/web'
    method: 'GET'
    headers: headers
  , (res)->
    console.log 'STATUS: ' + res.statusCode
    console.log 'HEADERS: ' + JSON.stringify res.headers
    res.setEncoding 'utf8'
    res.on 'data', (chunk)->
      console.log 'BODY: ' + chunk

    res.on 'end', ->
      console.log 'No more data in response.'


  req.on 'error', (e)->
    console.log 'problem with request: ' + e.message

  # req.write postData
  req.end()




search = (kwd, page=1, size=10)->

  postData =
    key: kwd
    page: 1
    limit: size
    app_key: '12129701'
    format: 'json'
    method: 'alibaba.xiami.api.search.songs.get'
    partner_id: 'apidoc'
    # sign_method: 'md5'
    sign_method: 'hmac'
    # timestamp: moment().format 'YYYY-MM-DD HH:mm:ss'
    timestamp: '2015-12-01 14:43:03'
    v: '2.0'
    category: -1
    is_pub: 'all'

  postData.sign = signParams postData
  postData.sign = '86209EAED580574B0D62CBFF4D408E5F'



  postData = querystring.stringify postData
  # replace encode space to +
  postData = postData.replace /%20/g, '+'


  console.log 'post data:  %s', postData
  req = http.request
    host: 'gw.api.taobao.com'
    path: '/router/rest'
    method: 'POST'
    headers:
      'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'
      'Content-Length': postData.length
  , (res)->
    console.log 'STATUS: ' + res.statusCode
    console.log 'HEADERS: ' + JSON.stringify res.headers
    res.setEncoding 'utf8'
    res.on 'data', (chunk)->
      console.log 'BODY: ' + chunk

    res.on 'end', ->
      console.log 'No more data in response.'


  req.on 'error', (e)->
    console.log 'problem with request: ' + e.message

  req.write postData
  req.end()




signParams = (data)->
  p = []
  for k, v of data
    p.push "#{k}#{v}"

  console.log 'params %o', p.sort()

  secret = 'test' + p.sort().join('') + 'test'
  console.log secret
  utils.md5(secret).toUpperCase()

search '刘德华'