// the main (app) module
var myApp = angular.module("myApp", []);

// add a controller
myApp.controller("myCtrl", function($scope) {
    $scope.customerName = "Eddie";
    $scope.credit = 123;
    $scope.saveChanges = function(source) {
        alert("changes saved from " + source);
    };
});

// add a directive
myApp.directive("myDir", function() {
    return {
        restrict: "E",
        scope: {
            name: "@", // by value
            amount: "=", // by reference
            save: "&" // event
        },
        template: "<div>" +
            "  {{name}}: <input ng-model='amount' />" +
            "  <button ng-click='save()'>Save</button>" +
            "</div>",
        replace: true,
        transclude: false,
        link: function(scope, element, attrs) {

            // show initial values: by-val members will be undefined
            console.log("initial value for name:" + scope.name);
            console.log("initial value for amount:" + scope.amount);

            // change element just to show we can
            element.css("background", "blue");
            // log changes to the 'amount' variable
            scope.$watch("amount", function(newVal, oldVal) {
                console.log("amount has changed " + oldVal + " >> " + newVal);
            });

            // log changes to the 'name' variable
            scope.$watch("name", function(newVal, oldVal) {
                console.log("name has changed " + oldVal + " >> " + newVal);
            });
        }
    }
});