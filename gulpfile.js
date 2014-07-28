var gulp = require('gulp');
var watch = require('gulp-watch');
var coffee = require('gulp-coffee');
var haml = require('gulp-haml');
var less = require('gulp-less');
var shell = require('gulp-shell');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');

var coffee_path = './src/coffee';
var less_path = './src/less';
var haml_path = './src/haml';

var tmp_css_path = './tmp/css';
var tmp_js_path = './tmp/js';

var cordova_app_path = '../cordova_apps/photobomb/';

var on_error = function (err) { console.error(err.message); };

gulp.task('coffee', function() {
  gulp.src(coffee_path + '/**/*.coffee')
    .pipe(coffee({bare: true})).on('error', on_error)
    .pipe(gulp.dest(tmp_js_path))
});

gulp.task('haml', function () {
  gulp.src(haml_path + '/**/*.haml')
    .pipe(haml())
    .pipe(gulp.dest('./www/'));
});

gulp.task('less', function () {
  gulp.src(less_path + '/**/*.less')
    .pipe(less())
    .pipe(gulp.dest(tmp_css_path));
});

gulp.task('cca prepare', shell.task([
  'cd ' + cordova_app_path + '; cca prepare'
]));

gulp.task('watch', function() {
  gulp.watch([coffee_path + '/**/*.coffee'], ['minify-js', 'cca prepare']);
  gulp.watch([less_path + '/**/*.less'], ['minify-css', 'cca prepare']);
  gulp.watch([haml_path + '/**/*.haml'], ['haml', 'cca prepare']);
});

gulp.task('minify-css', ['less'], function() {
  return gulp.src(['bower_components/bootstrap/dist/css/bootstrap.min.css',
                   'bower_components/bootstrap/dist/css/bootstrap-theme.min.css',
                   'bower_components/Font-Awesome/css/font-awesome.min.css',
                   tmp_css_path + '/**/*.css']).
              pipe(concat('all.css').on('error', on_error)).
              pipe(gulp.dest('./www/css'))
});

gulp.task('minify-js', ['coffee'], function() {
  return gulp.src(['bower_components/jquery/dist/jquery.min.js',
                   'bower_components/bootstrap/dist/js/bootstrap.min.js',
                   'bower_components/jquery-touchswipe/jquery.touchSwipe.min.js',
                   'bower_components/jquery.transit/jquery.transit.js',
                   'bower_components/textFit/textFit.min.js',
                   tmp_js_path + '/**/*.js']).
              pipe(concat('all.js').on('error', on_error)).
              pipe(gulp.dest('./www/js')).
              pipe(uglify())
});

gulp.task('default', ['watch']);
