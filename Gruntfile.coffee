module.exports = (grunt)->
  # APP 的发布目录地址
  RELEASE_PATH = 'public'

  pkg = grunt.file.readJSON 'package.json'

  # 记录版本是否已经更新过
  # 每次grunt 仅更新一次版本
  versionUpdated = false
  # 增加版本号
  increaseVersion = (pkg)->
    return if versionUpdated
    versionUpdated = true

    version = pkg.version
    max = 800
    vs = version.split('.').map (i)-> +i
    len = vs.length
    while len--
      break if (++vs[ len ]) < max
      vs[ len ] = 0
    pkg.version = vs.join '.'



  grunt.initConfig
    pkg: pkg
    # 清理文件夹
    clean:
      options:
        # 强制清理
        force: true

      dist: RELEASE_PATH


    # 合并文件
    concat:
      'dd.coffee':
        src:[
        ]
        dest: RELEASE_PATH + '/dd.coffee'

    # 替换版本号
    replace:
      options:
        patterns: [
          {
            # 实际替换的是 @@$$APP_VERSION$$
            match: '$$APP_VERSION$$',
            replacement: '<%= pkg.version %>'
          }
        ]
      # coffee 代码中的版本
      main:
        src: RELEASE_PATH + '/ddd.coffee'
        dest: RELEASE_PATH + '/ddd.coffee'
      # 更新markdown中模板应用的下载地址
      boilerplate:
        src: 'doc/slate/source/includes/_start.md'
        dest: 'doc/slate/source/includes/_start.md'



    # 编译coffee
    coffee:
      'ddd.coffee':
        options:
          bare: true
          sourceMap: false
        src: RELEASE_PATH + '/solo.coffee'
        dest: RELEASE_PATH + '/solo.js'


    # 压缩JS代码
    uglify:
      options:
        banner: '/*!\n'+
          ' * <%= pkg.name %> v<%= pkg.version %>\n' +
          ' * Copyright© <%= (new Date).getFullYear() %> <%= pkg.author.company %>\n' +
          ' */\n'
        # 移除console打印的日志
        # compress:
          # drop_console: true
        # 设置不压缩的关键字
        # mangle:
        #   except: ['require']
      min:
        options:
          sourceMap: false
          sourceMapIn: RELEASE_PATH + '/solo.js.map'
        src: RELEASE_PATH + '/solo.js'
        dest: RELEASE_PATH + '/solo.min.js'

    less:
      main:
        options:
          compress: true
          sourceMap: true
          sourceMapURL: 'solo.css.map'
          plugins: [
            new (require('less-plugin-autoprefix'))()
            # new (require('less-plugin-clean-css'))(cleanCssOptions)
          ]
          banner: '/*!\n'+
          ' * <%= pkg.name %> v<%= pkg.version %>\n' +
          ' * Copyright© <%= (new Date).getFullYear() %> <%= pkg.author.company %>版权所有\n' +
          ' */\n\n'
        src: 'src/style/dd.less'
        dest: RELEASE_PATH + '/dd.css'

    # 拷贝文件
    copy:
      # css字体文件
      css:
        cwd: 'src/style/'
        src: 'font/**'
        dest: RELEASE_PATH
        expand: true
      # 文档markdowns

    open:
      main:
        path: 'http://localhost:8888/',
        delay: 3000
    # 执行shell命令
    exec:
      viewblog: 'node lib/server/app.js blog'
      admin: 'node lib/server/app.js admin'


  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-replace'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-open'

  # 更新框架版本号
  grunt.registerTask 'update-version', ->
    increaseVersion pkg
    return

  grunt.registerTask 'view', [  'open:main', 'exec:viewblog' ]
  grunt.registerTask 'admin', [ 'open:main', 'exec:admin']

