module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-bowercopy'
  grunt.loadNpmTasks 'grunt-contrib-jshint'

  grunt.initConfig
    jshint:
      options:
        jshintrc: ".jshintrc"
      all: ["app/js/*.js"]
    bowercopy:
      libs:
        options:
          destPrefix: "app/js/vendor"
          clean: false
        files:
          "three.js": "threejs/build/three.js"
          "require.js": "requirejs/require.js"
          "physi.js": "physijs/physi.js"
          "physijs_worker.js": "physijs/physijs_worker.js"
          "jquery.js": "jquery/dist/jquery.min.js"
          "stats.min.js": "stats.js/build/stats.min.js"
      css:
        options:
          destPrefix: "app/css/vendor"
          clean: false
        files:
          "normalize.css": "normalize.css/normalize.css"

    watch:
      coffee:
        files: [ 'coffee/*.coffee']
        tasks: [ 'coffee'] # , 'concat:dev'
    coffee:
      compile:
        expand: true,
        flatten: true,
        cwd: "coffee/",
        src: ['*.coffee'],
        dest: 'js/',
        ext: '.js'
    connect:
      options:
        port: 9195
        livereload: 35729
        hostname: 'localhost'
        open:
          target: 'index.html'
        debug: true
      livereload:
        options:
          open: true
          base: ["app"]


  grunt.registerTask "serve", ->
    grunt.task.run ["connect:livereload", "watch"]

  grunt.registerTask "default", ["bowercopy", "jshint", "serve"]
