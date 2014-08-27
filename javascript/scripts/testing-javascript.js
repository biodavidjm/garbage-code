//Javascript file for testing purposes

var totalGen = 19;
var totalMW = 0;

for (var generators = 1; generators <= totalGen; generators++ )
{
	var isEven = generators%2;
	if (isEven == 0)
	{
		if (generators<=4)
		{
			totalMW = totalMW+62;
			console.log("Generator #"+ generators +" is on, adding 62 MW, for a total of "+ totalMW +" MW!");
		}
		else
		{
			totalMW = totalMW+124;
			console.log("Generator #"+ generators +" is on, adding 124 MW, for a total of "+ totalMW +" MW!");
		}
	}
	else
	{
		console.log("Generator #" + generators + " is off.");
	}
}

// Function expressions: Anonymous functions
// Function on the fly: it will be held in memory only when it is used.
var diff = function (a,b) {
	return a*a - b*b;
};

console.log(diff);
console.log (diff(5,2));

var welcome;
var newUser = false;

if (newUser)
{
	welcome = function(){
		console.log("\nThanks for visiting our website!\n We hope you enjoy the improvements\n");
	};
}
else
{
	welcome = function(){
		console.log("\nHey, it's good to see you back\nKeep having fun!!\n")
	}
}

closeStatement (welcome);
function closeStatement()
{
	welcome();
}


// Good example.

// var fear = fearGenerated(numPeeps, rainInInches, numSharks);

// var fearMessage;

// if(fear < 200){
//   fearMessage = function () {
//     return confirm( "Fear Level: LOW\n" +
//       "Should be no problem at all...mwahaha.\n" +
//       "Still wanna ride?");
//   };

// } else if (fear<=300) { 
//   fearMessage = function () {
//     return confirm( "Fear Level: MEDIUM\n" + 
//       "You may want to rethink this one. MWAHAHA!\n" +
//       "Think you'll make it?");
//   };

// } else {
//   fearMessage = function () {
//     return confirm( "Fear Level: HIGH\n" + 
//       "ABANDON ALL HOPE!!\n" + 
//       "Have a death wish?" );
//   };
// }

// var startRide = confirmRide(fearMessage);

// function confirmRide( confirmToGo ){
//   return confirmToGo();
// }


var passengers = [ ["Thomas", "Meeks"],
                   ["Gregg", "Pollack"],
                   ["Christine", "Wong"],
                   ["Dan", "McGaw"] ];

var modifiedNames = [];

for(var i = 0; i < passengers.length; i++){
	var whatever = passengers[i][0]+" "+passengers[i][1];
	console.log(whatever);
	// console.log(fullName);
	// modifiedNames[i] = fullName;
	// console.log(modifiedNames[i]);
}
//I am mapping, but well, now I am going to use "map"
console.log("\nLet's use map now");

var modifiedNames2 = passengers.map( 
	function(arrayCell)
	{ 
		return arrayCell[0]+" "+arrayCell[1];
	} 
);
console.log(modifiedNames2);

//I can also map the values but I don't need to store them in any other array:
var modifiedNames = [ "Thomas Meeks", 
                      "Gregg Pollack", 
                      "Christine Wong", 
                      "Dan McGaw" ];
modifiedNames.map (
	function(arrayCell){
		console.log("Yo, "+arrayCell);
	}
); 

var first;
var second;
var third;
var fourth;
var puzzlers = [ 
	first = function(a){return a*3-8;},
	second = function(a){return (a+2)*(a+2)*(a+2);},
	third = function(a){return (a*a)-9;},
	fourth = function(a){return a%4;}
];

// Digging into function of functions:
var user = 1;
function adventureSelector ( userChoice ){
  if (userChoice == 1)
  {
  	return function(){
  		console.log("You've selected the Vines of Doom!\nHope you have a swingin' time.");
  	};
  }
  else if (userChoice == 2)
  {
  	return function(){
  		console.log("You've selected the Vines of Doom!\nHope you have a swingin' time.");
  	};
  }
  else if (userChoice == 3)
  {
  	return function(){
  		console.log("The Caves of Catastrophe, really?\nAlright, well....nice knowing you.");
  	};
  }
};

var joder = adventureSelector(user);

joder();

// A little bit more complicated now:
// I didn't understand this because I thought it was required to start by
// the given position of the array, which forced me to write something crazily complex
// for what they were asking...
console.log("\nCalling functions of functions in arrays");

var puzzlers = [
    function ( a ) { return 8*a - 10; },
    function ( a ) { return (a-3) * (a-3) * (a-3); },
    function ( a ) { return a * a + 4; },
    function ( a ) { return a % 5; }
];
var start = 2;


var applyAndEmpty = function( input, queue ) {

	//testing this:
	return input = queue[0](input);

  // var length = queue.length;
  // for(var i = 0; i<length; i++){
  //   input = queue.shift()(input);
  // }
  // return input;
};
console.log(applyAndEmpty(2, puzzlers));

// Now, time to evaluate this: “What is obtained when the result of passing 9
// into function 4 is then passed into the function whose array index matches
// the result of passing 3 into function 2?”

console.log(puzzlers[(puzzlers[1](3))](puzzlers[3](9)));

// CLOSURES
// I got right this fucking exercise but I didn't type "alert" when submitting the fucking result!!! damn it!!

console.log("Let's see now:");
var hidden = mystery();
var result = hidden(3);

function mystery ( ){
  var secret = 6;
  function mystery2 ( multiplier ) { 
    multiplier *= 3;
    return secret * multiplier;
  }
  return mystery2;
}

// Very interesting exercise to know how closure works. 
// Try to fill up the numbers below ang get the right number
// (hint: you also get this right)
var hidden = mystery(3);
var jumble = mystery3(hidden);
var result = jumble(2);

function mystery ( input ){
  var secret = 4;
  input+=2;
  function mystery2 ( multiplier ) { 
    multiplier *= input;
    return secret * multiplier;
  }
  return mystery2;
}
function mystery3 ( param ){
  function mystery4 ( bonus ){
    return param(6) + bonus;
  }
  return mystery4;
}

// input = 
// bonus = 
// multiplier =

// Closures allow you to use trackers as well!
var zones = [];
function warningMaker( obstacle ){
  var count = 0;
  return function ( number, location ) {
    count++;
    zones.push(location);
    console.log("Beware! There have been " +
          obstacle +
          " sightings in the Cove today!\n" +
          number +
          " " +
          obstacle +
          "(s) spotted at the " +
          location +
          "!\n" +
          "This is Alert #" +
          count +
          " today for " +
          obstacle +
          " danger.\n" +
          "Current danger zones are:"
         );
    for (var i = 0; i<zones.length; i++)
    {
      console.log(zones[i]);
    }
  };
}

var DesertWarning = warningMaker("Wild Dogs");
var IceCavesWarning = warningMaker("giant ice bat");
DesertWarning(30,"Dessert");
IceCavesWarning(20,"Frozen Falls");


// Common problems with closures

var listOfSharks = ["Sea Pain", "Great Wheezy",
                    "DJ Chewie", "Lil' Bitey",
                    "Finmaster Flex", "Swim Khalifa",
                    "Ice Teeth", "The Notorious J.A.W."];
var listOfTargets = ["icicle bat", "snow yeti",
                     "killer penguin", "frost tiger",
                     "polar bear", "iceberg",
                     "blue witch", "wooly mammoth"];

function makeTargetAssigner( sharks, targets ){
  for (var i = 0;i<sharks.length;i++)
  {
    return function(shark){
      for (var i=0; i<sharks.length; i++){
        if (sharks[i]==shark){
          alert("What up, " +
            shark +
            "!\n" +
            "There've been " +
            targets[i] + 
            " sightings in our 'hood!\n" +
            "Time for a swim-by lasering, homie!");
        }
      }
    }
  }
}



var getTargetFor = makeTargetAssigner(  listOfSharks,
                                        listOfTargets );
getTargetFor("Ice Teeth");
