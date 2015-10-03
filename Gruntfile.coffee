sass_options = 
  sourcemap: 'inline',
  trace: true,
  require: './themes.rb',
  compass: true,

remote_js = [
  'https://code.jquery.com/jquery-1.11.3.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/moment.js',
  'https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/locale/en-gb.js',
  'https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.0.3/js.cookie.js',
]

module.exports = (grunt) ->
  
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-env'
  
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    env:
      local:
        src: 'local.json'

    clean: 
      dist: 'dist',
      build: 'build',
      
    sass:
      core:
        options:
          sass_options
        files:
          'build/css/campl.css': 'scss/campl.scss'
      legacy:
        options:
          sass_options
        files:
          'build/css/campl_legacy.css': 'scss/campl_legacy.scss'
    
    cssmin:
      options:
        sourceMap: true
      core:
        files:[
          expand: true,
          cwd: 'build/css',
          src: ['*.css', '!*.min.css'],
          dest: 'build/css',
          ext: '.min.css',
        ]
    
    concat:
      core:
        src: [
          'lib/bootstrap/dist/js/bootstrap.js',
          'lib/datetimepicker/src/js/bootstrap-datetimepicker.js',
          'js/menu.js',
          'js/select_tab.js',
        ]
        dest:
          'build/js/campl.js'
      dev:
        src: [
          'js/theme_switcher.js',
        ]
        dest:
          'build/js/theme_switcher.js'
    
    uglify:
      options:
        sourceMap: true
        sourceMapIncludeSources: true
      core:
        src: '<%= concat.core.dest %>'
        dest: 'build/js/campl.min.js'
      dev:
        src: '<%= concat.dev.dest %>'
        dest: 'build/js/theme_switcher.min.js'
        
    copy:
      images:
        expand: true
        cwd: 'images'
        src: [
          'logo.png'
        ]
        dest: 'build/images'
      dist:
        expand: true
        cwd: 'build'
        src: [
          'images/**',
          'js/**',
          'css/**',
        ]
        dest: 'dist'
      deploy:
        expand: true
        cwd: 'build'
        src: ['**']
        dest: "/Users/bill/Sites/campl-ng"

    jade:
      options:
        data:
          ROOT: '/~bill/campl-ng'
          REMOTE_JS: remote_js
          LINKS: grunt.file.readJSON('links.json')
      compile:
        files:
          'build/base.html': ['templates-jade/layouts/page.jade']  

    watch:
      jade:
        files: 'templates-jade/**'
        tasks: ['jade', 'copy:deploy']
      
 

  grunt.registerTask 'default', ['clean', 'sass:core', 'concat:core']
  
  grunt.registerTask 'build-css', ['sass', 'cssmin']
  
  grunt.registerTask 'build-js', ['concat', 'uglify']
  
  grunt.registerTask 'build-images', ['copy:images']
  
  grunt.registerTask 'build', ['clean', 'build-css', 'build-js', 'build-images']
  
  grunt.registerTask 'dist', ['build', 'copy:dist']

  grunt.registerTask 'local', ['jade', 'copy:deploy']
  