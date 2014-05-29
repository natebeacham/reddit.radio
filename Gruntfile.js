module.exports = function(grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		sass: {
			dist: {
				files: {
					'media/css/radio.css': 'media/css/radio.sass'
				}
			}
		},
		coffee: {
			dist: {
				files: {
					'app.js': 'app.coffee',
					'media/js/radio.js': 'media/js/radio.coffee'
				}
			}
		},
		watch: {
			css: {
				files: '**/**/*.sass',
				tasks: ['sass']
			},
			js: {
				files: ['**/**/*.coffee', '*.coffee'],
				tasks: ['coffee']
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-sass');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-coffee');

	grunt.registerTask('default', ['watch']);
}
