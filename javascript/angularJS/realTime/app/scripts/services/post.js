'use strict';

angular.module('realTimeApp')
	.factory('Post', function($resource){
		return $resource('https://vivid-inferno-633.firebaseio.com/posts/:id.json');
	});