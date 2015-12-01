var http = require('http'),
  config = require('./config'),
  proxy = require('./proxy'),
  staticweb = require('./staticweb');

// 处理 apiPrefix 为其前后加上 /
config.apiPrefix = '/' + config.apiPrefix.replace(/^\/|\/$/g,'') + '/'; 

(function initArgs () {
  var cmd = process.argv.slice(2)[0];
  if (!cmd) {
    throw new Error('server path should be specified');
  }
  switch(cmd) {
    case 'blog':
      config.staticPath = 'theme';
      break;
    default:
      throw new Error('Unknown server path');
  }

})();
// 创建服务器
http.createServer(function (req, res) {
  if (req.url.indexOf( config.apiPrefix ) === 0) {
    console.log('request url: ' + req.url);
    proxy(req, res, config );
  } else {
    staticweb(req, res, config );
  }
}).listen( config.listenPort );

console.log('server started at: ' + config.listenPort);