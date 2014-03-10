// For any third party dependencies, like jQuery, place them in the lib folder.

// Configure loading modules from the lib directory,
// except for 'app' ones, which are in a sibling
// directory.
requirejs.config({
    baseUrl: 'lib',
    paths: {
        app: '../app',
    },
    shim: {
		'underscore' : {
			exports: '_',
			init: function () {
				return this._.noConflict();
			}
		},
		'three' : {
			exports: 'THREE'
		},
		'backbone':{
			deps: ['underscore'],
			exports: 'Backbone'
		},
		'jquery' : {
			exports: '$'
		}
	}
		
});

// Start loading the main app file. Put all of
// your application logic in there.
require(
		['cs!app/views/ThreeDeeView'], 
		function main(App) {
			var v = new App.MainThreeDeeView();
			v.debugGeom();
		}
);
