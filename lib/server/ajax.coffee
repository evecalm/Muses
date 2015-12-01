
xiami = require '../fetch/xiami'



handleAjaxReq = (req, res, config)->
  
  params = getUrlParams req, config

  done = (result)->
    res.setHeader 'Content-Type', 'application/json; charset=utf-8'
    result = "#{result}" if typeof result isnt 'string'
    res.end result
  cmd = params.shift()
  queryData = {}
  fn = sendErrorMsg
  switch cmd
    when 'search'
      queryData.key = params.shift()
      queryData.page = params.shift()
      queryData.page = 1 unless queryData.page
      if queryData.key
        fn = xiami.search
      else
        queryData = 'keywords should not be empty'
      
    when 'song'
      queryData.id = params.shift()
      if queryData.id
        fn = xiami.getSongInfo
      else
        queryData = 'song\'s id should not be empty'

    when 'ablum'
      queryData.id = params.shift()
      if queryData.id
        fn = xiami.getAlbumInfo
      else
        queryData = 'ablum\'s id should not be empty'

    when 'artist'
      queryData.id = params.shift()
      if queryData.id
        fn = xiami.getArtistInfo
      else
        queryData = 'artist\'s id should not be empty'

    else
      queryData = "unknow api name: #{cmd}"

  fn queryData, done

      
    
  
# 返回错误消息
sendErrorMsg = (message, done)->
  done JSON.stringify {
    state: 300
    message: message
  }

# 解析URL参数
getUrlParams = (req, config)->
  apiPrefixReg = new RegExp '^' + config.apiPrefix
  
  path = req.url
  .replace apiPrefixReg, ''
  .replace /^\/|\/$/g, ''

  params = []

  path.split '/'
  .forEach (elm)->
    params.push decodeURIComponent elm

  params

module.exports = handleAjaxReq