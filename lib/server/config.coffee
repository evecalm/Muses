# 配置选项, 选项不能有多余空格!
module.exports =
  
  # 远程服务器地址
  # "host": "10.50.133.88",
  host: "192.168.6.157"
  
  # 远程服务器端口
  port: 8091
  
  # "port": 80,
  # 服务器端接口前缀
  # "urlPrefix": "sjtbweb",
  urlPrefix: "serverj/webmail"
  
  # 客户端 ajax api 请求地址前缀,
  #    用此前缀来判断请求的是静态页面还是接口
  #    *该配置项不能为空*
  apiPrefix: "api"
  
  # 静态网页路径
  staticPath: "webmail"
  
  # 服务器监听的端口
  listenPort: 8888