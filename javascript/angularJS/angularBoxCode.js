// Useful collection of angular code
// 
// Nice filter to automatically cut the amount of text show for a string of text:
// 

.filter('cut', function () {
  return function (value, wordwise, max, tail) {
      if (!value) {return '';}

      max = parseInt(max, 10);
      if (!max) {return value;}
      if (value.length <= max) {return value;}

      value = value.substr(0, max);
      if (wordwise) {
          var lastspace = value.lastIndexOf(' ');
          if (lastspace !== -1) {
              value = value.substr(0, lastspace);
          }
      }

      return value + (tail || ' …');
  };
})

// Usage: {{text go here | cut:true:100:' ...'}}


// Another option is to study carefully the ng limitTo
// https://docs.angularjs.org/api/ng/filter/limitTo

// a directive to auto-collapse long text
// in elements with the "dd-text-collapse" attribute
// https://github.com/doukasd/AngularJS-Components/tree/master/dd-text-collapse

app.directive('ddTextCollapse', ['$compile', function($compile) {

    return {
        restrict: 'A',
        scope: true,
        link: function(scope, element, attrs) {

            // start collapsed
            scope.collapsed = false;

            // create the function to toggle the collapse
            scope.toggle = function() {
                scope.collapsed = !scope.collapsed;
            };

            // wait for changes on the text
            attrs.$observe('ddTextCollapseText', function(text) {

                // get the length from the attributes
                var maxLength = scope.$eval(attrs.ddTextCollapseMaxLength);

                if (text.length > maxLength) {
                    // split the text in two parts, the first always showing
                    var firstPart = String(text).substring(0, maxLength);
                    var secondPart = String(text).substring(maxLength, text.length);

                    // create some new html elements to hold the separate info
                    var firstSpan = $compile('<span>' + firstPart + '</span>')(scope);
                    var secondSpan = $compile('<span ng-if="collapsed">' + secondPart + '</span>')(scope);
                    var moreIndicatorSpan = $compile('<span ng-if="!collapsed">... </span>')(scope);
                    var lineBreak = $compile('<br ng-if="collapsed">')(scope);
                    var toggleButton = $compile('<span class="collapse-text-toggle" ng-click="toggle()">{{collapsed ? "less" : "more"}}</span>')(scope);

                    // remove the current contents of the element
                    // and add the new ones we created
                    element.empty();
                    element.append(firstSpan);
                    element.append(secondSpan);
                    element.append(moreIndicatorSpan);
                    element.append(lineBreak);
                    element.append(toggleButton);
                }
                else {
                    element.empty();
                    element.append(text);
                }
            });
        }
    };
}]);
