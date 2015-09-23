'use strict';

angular.module('realTimeApp')
	.controller('PostsCtrl', function($scope, $location, Post) {

		$scope.posts = Post.all;
		
		$scope.post = {url: 'http://'};

		$scope.deletePost = function (post) {
			Post.delete(post);
		};
	});