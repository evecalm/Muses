
http = require 'http'
querystring = require 'querystring'
moment = require 'moment'
utils = require 'utility'
_ = require 'lodash'
# fs = require 'fs'

# 发送请求
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

  queryData = querystring.stringify( data ).replace '%20', '+'

  path = '/web?' + queryData

  req = http.request
    host: 'api.xiami.com'
    path: path
    method: 'GET'
    headers: headers
  , (res)->
    json = ''
    res.setEncoding 'utf8'
    res.on 'data', (chunk)->
      json += chunk

    res.on 'end', ->
      # fs.appendFile 'data.txt', json + '\n\n'
      done json

  req.on 'error', (e)->
    done JSON.stringify {
      state: 400
      message: e.message
    }
    # console.log 'problem with request: ' + e.message

  req.end()


### 搜索歌曲
{
  "state": 0,
  "message": "",
  "request_id": "0ab6004714489582497883250e",
  "data": {
    "songs": [
      {
        "song_id": 1774011652,
        "song_name": "听爸爸的话（张一清）",
        "album_id": 0,
        "album_name": "",
        "album_logo": "http://img.xiami.net/images/artistlogo/77/14020454152677_1.jpg",
        "artist_id": 1188901595,
        "artist_name": "白桦树娃娃",
        "artist_logo": "http://img.xiami.net/images/artistlogo/77/14020454152677_1.jpg",
        "listen_file": "http://m5.file.xiami.com/595/1188901595/0/1774011652_0_l.mp3?auth_key=dab17dce03c2b760052299209e9bb2b2-1449014400-0-null",
        "demo": 1,
        "lyric": "",
        "is_play": 0,
        "play_counts": 0,
        "singer": ""
      }
    ],
    "previous": 1,
    "next": 1,
    "total": 1
  }
}
###
search = (kwd, page, size, done)->
  request 'search/songs', {
    key: kwd
    page: page
    limit: size
  }, done

### 获取歌曲的详细信息
{
  "state": 0,
  "message": "",
  "request_id": "0ab51f3a14489571804176220e",
  "data": {
    "songs": [
      {
        "song_id": 1774011652,
        "song_name": "听爸爸的话（张一清）",
        "album_id": 0,
        "album_name": "",
        "album_logo": "http://img.xiami.net/images/artistlogo/77/14020454152677_1.jpg",
        "artist_id": 1188901595,
        "artist_name": "白桦树娃娃",
        "artist_logo": "http://img.xiami.net/images/artistlogo/77/14020454152677_1.jpg",
        "listen_file": "http://m5.file.xiami.com/595/1188901595/0/1774011652_0_l.mp3?auth_key=dab17dce03c2b760052299209e9bb2b2-1449014400-0-null",
        "demo": 1,
        "lyric": "",
        "is_play": 0,
        "play_counts": 0,
        "singer": ""
      }
    ],
    "previous": 1,
    "next": 1,
    "total": 1
  }
}
###
getSongInfo = (songId, done)->
  request 'song/detail', {
    id: songId
  }, done

### 获取专辑信息
{
  "state": 0,
  "message": "",
  "request_id": "0ab51f3b14489574658531044e",
  "data": {
    "artist_name": "刘德华",
    "album_id": 2921,
    "artist_id": 648,
    "album_name": "经典重现",
    "song_count": 39,
    "gmt_publish": 1071763200,
    "album_logo": "http://img.xiami.net/images/album/img48/648/29211392024408_1.jpg",
    "album_status": 0,
    "pinyin": "jing dian zhong xian",
    "songs": [
      {
        "song_id": 23987,
        "song_name": "神雕大侠",
        "album_id": 2921,
        "album_name": "经典重现",
        "artist_id": 648,
        "singers": "刘德华",
        "mv_id": "",
        "flag": 0,
        "album_logo": "http://img.xiami.net/images/album/img48/648/29211392024408_1.jpg"
      }
    ]
  }
}
###
getAlbumInfo = (albumId, done)->
  request 'album/detail', {
    id: albumId
  }, done

### 获取歌手信息
{
  "state": 0,
  "message": "",
  "request_id": "0ab6004714489575640068939e",
  "data": {
    "artist_id": 648,
    "company": "",
    "area": "Hongkong 香港",
    "gender": "M",
    "english_name": "Andy Lau",
    "category": 1,
    "logo": "http://img.xiami.net/images/artistlogo/37/14230160708537_1.jpg",
    "albums_count": 104,
    "recommends": 7141,
    "play_count": 44911845,
    "artist_name": "刘德华"
  }
}
###
getArtistInfo = (artistId, done)->
  request resp, 'artist/detail', {
    id: artistId
  }, done
search '张一清', 1, 10

# getSongInfo null, 24019

# getAlbumInfo null, 2921

# getArtistInfo 648

