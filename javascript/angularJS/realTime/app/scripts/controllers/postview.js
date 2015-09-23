'use strict';


angular.module('realTimeApp')
	.controller('PostViewCtrl', function($scope, $routeParams, Post) {
		$scope.post = Post.get($routeParams.postId);
	});