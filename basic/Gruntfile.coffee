minifyify = require 'minifyify'
fs = require 'fs'


module.exports = (grunt) ->

  config =

    pkg: (grunt.file.readJSON('package.json'))


    jade:
      index:
        options:
          client: false
          locals:
            title: '<%= pkg.name %>'
            description: '<%= pkg.description %>'
            author: '<%= pkg.author %>'
        files:
          'dist': ['src/jade/index.jade']
      partials:
        options:
          client: true
          wrap: 'node'
        files:
          'tmp/js/templates': ['src/jade/partials/**/*.jade']


    coffeelint:
      options:
        configFile: 'coffeelint.json'
      app: ['src/**/*.coffee']


    coffee:
      options:
        sourceMap: true
      app:
        expand: true
        flatten: false
        cwd: 'src/coffee'
        src: ['./**/*.coffee']
        dest: 'tmp/js'
        ext: '.js'


    coffeeredux:
      options:
        bare: false
        sourceMap: true
      app:
        expand: true
        flatten: false
        cwd: 'src/coffee'
        src: ['./**/*.coffee']
        dest: 'tmp/js'
        ext: '.js'


    browserify:
      options:
        #transform: ['coffeeify']
        browserifyOptions:
          debug: true
      app:
        files:
          'dist/js/app.js': ['tmp/js/**/*.js']
        # options:
        #   preBundleCB: (bundler) ->
        #     bundler.plugin('minifyify', {map: 'bundle.map'})
        #     bundler.bundle (err, src, map) ->
        #       fs = require 'fs'
        #       fs.writeFile 'dist/js/app2.js', src
        #       fs.writeFile 'dist/js/bundle.map', map


    watch:
      compile:
        files: ['src/**/*.coffee', 'test/**/*.coffee']
        tasks: ['compile']
        configFiles:
          files: ['Gruntfile.coffee']
          options:
            reload: true


    copy:
      maps:
        files: [
          {expand: true, flatten: true, src: ['tmp/js/**/*.map'], dest: 'dist/js'}
          {expand: true, src: ['src/coffee/**/*'], dest: 'dist/'}
        ]


    connect:
      server:
        options:
          port: 8000
          base: 'dist'


    clean:
      all: [
        'dist'
        'tmp'
        'src/**/*.js'
        'src/**/*.map'
      ]

    minifyify:
      app:
        src: 'tmp/js/app.js'
        dest: 'dist/js/app.js'
        map: 'tmp/js/app.jsmap.json'



  grunt.registerMultiTask 'minifyify', '', ->

    browserify = require 'browserify'
    bundler = new browserify({debug: true})
    mkdirp = require 'mkdirp'
    #
    # namespace = this.name + '.' + this.target
    #
    # # Fetch configuration data
    # this.requiresConfig namespace + '.src', namespace + '.dest', namespace + '.map'
    #
    # src  = grunt.config namespace + '.src'
    # dest = grunt.config namespace + '.dest'
    # map  = grunt.config namespace + '.map'
    #
    # options = grunt.config 'options'
    #
    # # Run minifyify
    done = this.async()
    #
    # readStream  = fs.createReadStream src
    # writeStream = fs.createWriteStream dest

    bundler.add './tmp/js/app.js'

    bundler.plugin('minifyify', {map: 'bundle.map'})
    bundler.bundle (err, src, map) ->
      fs = require 'fs'
      mkdirp.sync 'dist/js'
      fs.writeFileSync 'dist/js/app.js', src
      fs.writeFileSync 'dist/js/bundle.map', map

      #
      # readStream.on 'open', ->
      #   readStream.pipe(minifyify(options)).pipe(writeStream)
      #
      # readStream.on 'error', (error) ->
      #   grunt.log.writeln error
      #   done false
      #
      # writeStream.on 'finish', ->
      done()

  grunt.initConfig(config)
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-coffee-redux'
  grunt.loadNpmTasks 'grunt-jade'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'compile', [
    'coffeelint'
    'clean'
    'coffee'
    #'coffeeredux'
    'browserify'
    #'minifyify'
    'copy'
    'jade'
    ]

  grunt.registerTask 'run', [
    'compile'
    'connect:server:keepalive'
  ]
