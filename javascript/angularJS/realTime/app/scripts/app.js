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
    'ngTouch',
    'firebase'
  ])
  // Constant for the firebase url, as it will be injected into the services or controllers
  .constant('FIREBASE_URL', 'https://vivid-inferno-633.firebaseio.com')
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
