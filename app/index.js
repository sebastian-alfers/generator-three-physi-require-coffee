'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var yosay = require('yosay');

var ThreePhysiRequireCoffeeGenerator = yeoman.generators.Base.extend({
  initializing: function () {
    this.test = "a";
    this.pkg = require('../package.json');
  },

  prompting: function () {
    var done = this.async();
    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to the incredible ThreePhysiRequireCoffee generator!'
    ));

    var prompts = [{
      type: 'input',
      name: 'appName',
      message: 'What is your app name?',
      default: "ThreePhysisDemo"
    }];

    this.prompt(prompts, function (props) {
      this.log('jea - your name is ' + props.appName)
      this.appName = props.appName;

      //this.test = "c";

      done();
    }.bind(this));
  },

  writing: {
    app: function () {
      this.dest.mkdir('app');
      this.template('_package.json', 'package.json');
      this.template('_bower.json', 'bower.json');
      this.template('_Gruntfile.coffee', 'Gruntfile.coffee');

      this.src.copy('css/_styles.css', 'app/css/styles.css');
      this.src.copy('js/_main.js', 'app/js/main.js');

      this.template('_index.html', 'app/index.html');
    },

    projectfiles: function () {
      this.src.copy('editorconfig', '.editorconfig');
      this.src.copy('jshintrc', '.jshintrc');
    }
  },

  end: function () {
    this.installDependencies();
  }
});

module.exports = ThreePhysiRequireCoffeeGenerator;
