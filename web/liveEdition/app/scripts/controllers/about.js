'use strict';

/**
 * @ngdoc function
 * @name liveEditionApp.controller:AboutCtrl
 * @description
 * # AboutCtrl
 * Controller of the liveEditionApp
 */
angular.module('liveEditionApp')
  .controller('AboutCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
