'use strict';

/**
 * @ngdoc function
 * @name liveEditionApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the liveEditionApp
 */

angular.module('liveEditionApp')
	.controller('MainCtrl', function ($scope) {
		$scope.awesomeThings = [
		  'HTML5 Boilerplate',
		  'AngularJS',
		  'Karma'
		];
		$scope.here = {
			isTheHead: 'Dictyostelium discoideum',
			isTheTitle: 'Testing Live Edition',
			desc: 'What would you like to say about dicty?\nAll right, write it down here'
		};
	});
