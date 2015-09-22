'use strict';

/**
 * @ngdoc overview
 * @name realTimeApp
 * @description
 * # realTimeApp
 *
 * Main module of the application.
 */

angular
  .module('realTimeApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
  ])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/posts.html',
        controller: 'PostsCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
