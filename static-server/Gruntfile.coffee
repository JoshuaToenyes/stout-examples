module.exports = (grunt) ->

  config =

    pkg: (grunt.file.readJSON('package.json'))


    coffeelint:
      options:
        configFile: 'coffeelint.json'
      app: ['src/**/*.coffee']


    coffee:
      app:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['*.coffee']
        dest: 'dist'
        ext: '.js'


    watch:
      compile:
        files: ['src/*.coffee']
        tasks: ['compile']
        configFiles:
          files: ['Gruntfile.coffee']
          options:
            reload: true


    clean:
      dist: ['dist']


    execute:
      target:
        src: ['dist/index.js']


  grunt.initConfig(config)

  for pkg of config.pkg.devDependencies
    if /grunt\-/.test pkg
      grunt.loadNpmTasks pkg

  grunt.registerTask 'compile', [
    'clean'
    'coffeelint'
    'clean'
    'coffee'
    ]

  grunt.registerTask 'run', [
    'compile'
    'execute'
  ]
