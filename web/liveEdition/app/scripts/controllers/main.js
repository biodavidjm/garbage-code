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
  });
