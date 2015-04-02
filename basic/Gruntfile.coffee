minifyify = require 'minifyify'
fs = require 'fs'
modRewrite = require('connect-modrewrite');


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
      app:
        expand: true
        flatten: false
        cwd: 'src/coffee'
        src: ['./**/*.coffee']
        dest: 'tmp/js'
        ext: '.js'


    browserify:
      app:
        files:
          'dist/js/app.js': ['tmp/js/**/*.js']


    watch:
      compile:
        files: ['src/**/*.coffee']
        tasks: ['compile']
        configFiles:
          files: ['Gruntfile.coffee']
          options:
            reload: true


    connect:
      server:
        options:
          port: 8000
          base: 'dist'
          middleware: (connect, options, middlewares) ->
            middlewares.unshift(modRewrite(['!\\.html|\\.js|\\.svg|\\.css|\\.png$ /index.html [L]']))
            return middlewares


    clean:
      tmp: ['tmp']
      all: [
        'dist'
        'tmp'
        'src/**/*.js'
        'src/**/*.map'
      ]


    open:
      test:
        path: 'http://localhost:8000/'
        app: 'Safari'


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
  grunt.loadNpmTasks 'grunt-open'

  grunt.registerTask 'compile', [
    'coffeelint'
    'clean'
    'coffee'
    'browserify'
    'jade'
    'clean:tmp'
    ]

  grunt.registerTask 'run', [
    'compile'
    'open'
    'connect:server:keepalive'
  ]
