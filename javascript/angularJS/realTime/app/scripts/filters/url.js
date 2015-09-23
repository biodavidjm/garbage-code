'use strict';

angular.module('realTimeApp')
	.filter('hostnameFromUrl', function () {
		return function (str) {
			var url = document.createElement('a');

			url.href = str;

			return url.hostname;
		};
	});