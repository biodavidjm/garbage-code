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
    console.log("\nBeware! There have been " +
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
      console.log("\t"+(i+1)+". "+zones[i]);
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
          console.log("What up, " +
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

// Level 3, the importance of load order: hoisting 
// 1. All var gets declared to undefined first
// 2. functions are overwrite according to the order they are in the code

// All declared variables are first manually initialized to an undefined value
// and come first in the load order.

// All loaded functions that end up being overwritten by other functions with the
// same name will just disappear from their current place in the load order (and
// will not be seen in your answer).

// Declared functions that end up replacing other functions, however, will NOT
// take the order place of the previous version, but instead will just fall into
// the load order behind existing loaded functions.

// All unreachable executable code that follows a return statement (where the
// function ends) will disappear from your answer.

// Do not understand what the hell were they asking for. They should have
// asked: "Please, rewrite the following piece of code in the way it will be
// executed by the compiler...

function theBridgeOfHoistingDoom () {
  function balrog(){
    return "fire";
  }
  var ring;
  function elf(){
    return "pointy ears";
  }
  ring = wizard;
  wizard = balrog;
  return wizard();
  function balrog(){
    return "whip";
  }
  function wizard(){
    return "white";
  }
  var power = ring();
  return elf();
  function elf(){
    return "immortal";
  }
}

// And the right answer would be:
function theBridgeOfHoistingDoom () {
  var ring = undefined;
  var power = undefined;

  function balrog(){
    return "whip";
  }
  function elf(){
    return "immortal";
  }
  function wizard(){
    return "white";
  }
  ring = wizard;
  wizard = balrog;
  return wizard();
}

// FIND THE ERROR HERE
function theBridgeOfHoistingDoom( ){
  var sword = undefined;
  var dwarf = undefined;
  var fall = undefined;
  var ring = undefined;
  function fellowship(){
    return "friends";
  }
  sword = "sting";
  dwarf = function (){ 
    return "axe";
  }
  fall = "Fly you fools!";
  fellowship = function (){
    return "broken";
  }
  ring();
  return sword;
}

// Ring is not a function!!!!


console.log("\n\nTIME FOR OBJECTS!!");
console.log("**********************\n");

var vehicle1 = {type: "Motorboat", capacity: 6, storedAt: "Ammunition Depot"};
var vehicle2 = {type: "Jet Ski", capacity: 1, storedAt: "Reef Dock"};
var vehicle3 = {type: "Submarine", capacity: 8, storedAt: "Underwater Outpost"};

console.log(vehicle1.capacity);
var vehicles = [vehicle1, vehicle2, vehicle3];
var findVehicle = function(name, list)
{
  for (var i = 1; i<list.length;i++)
  {
    if (name == list[i].type)
    {
      return list[i].storedAt;
    }
  }
};

console.log(findVehicle("Submarine",vehicles));

vehicle1.capacity = (vehicle1.capacity + 4);
vehicle2.submersible  = false;
vehicle3.weapon = "Torpedoes";
vehicle1.submersible  = false;
vehicle2.weapon = "Lasers";
vehicle3.capacity = (vehicle3.capacity*2);
vehicle1.weapon = "Rear-Mounted Slingshot";
vehicle3.submersible  = true;

// But if you want to asign a property with spaces, then you use this
// notation:

vehicle3["# of weapons"]=8;
vehicle2["# of weapons"]=4;
vehicle1["# of weapons"]=1;

console.log(vehicle1.capacity);
console.log(vehicle2.submersible);
console.log(vehicle3.weapon);

var superBlinders = [ ["Firelight", 4000], ["Solar Death Ray", 6000], ["Supernova", 12000] ];
var lighthouseRock = {
  gateClosed: true,
  bulbs: [ 200, 500, 750 ],
  capacity: 30,
  secretPassageTo: "Underwater Outpost"
};
console.log(lighthouseRock.bulbs);
delete lighthouseRock.bulbs;
console.log(lighthouseRock.bulbs);

var highestWattage = 0;
var superBlinderName;
for (var i = 0;i<superBlinders.length;i++)
{
  if(highestWattage < superBlinders[i][1])
  {
    highestWattage = superBlinders[i][1]
    superBlinderName = superBlinders[i][0];
  }
}
console.log(superBlinderName);

// Let's see this:
var superBlinders = [ ["Firestorm", 4000], ["Solar Death Ray", 6000], ["Supernova", 12000] ];
var lighthouseRock = {
  gateClosed: true,
  weaponBulbs: superBlinders,
  capacity: 30,
  secretPassageTo: "Underwater Outpost",
  numRangers: 0
};
//This is the function I had to create...
function addRangers (theobject, location, name, skillz, station)
{
  theobject.numRangers++;
  theobject["ranger"+theobject.numRangers] = {located: location, author: name, feature: skillz, place: station};
}

addRangers(lighthouseRock, "Here", "Nick Walsh", "magnification burn", 2);
addRangers(lighthouseRock, "there","Drew Barontini", "uppercut launch", 3);
addRangers(lighthouseRock, "whatever", "Christine Wong", "bomb defusing", 1);


// Another exercise:
var superBlinders = [ ["Firestorm", 4000], ["Solar Death Ray", 6000], ["Supernova", 12000] ];
var lighthouseRock = {
  gateClosed: true,
  weaponBulbs: superBlinders,
  capacity: 30,
  secretPassageTo: "Underwater Outpost",
  numRangers: 3,
  ranger1: {name: "Nick Walsh", skillz: "magnification burn", station: 2},
  ranger2: {name: "Drew Barontini", skillz: "uppercut launch", station: 3},
  ranger3: {name: "Christine Wong", skillz: "bomb defusing", station: 1}
};

// function dontPanic (bigObject, location)
// {
//   console.log("Avast, me hearties!\nThere be Pirates nearby! Stations!\n");
//   for (var i = 0)
// }

// NO idea what the hell they were asking. Unfair. I got confused with the location!!!
// It was a piece of cake but they didn't stayed the problem properly.

var superBlinders = [ ["Firestorm", 4000], ["Solar Death Ray", 6000], ["Supernova", 12000] ];
var lighthouseRock = {
  gateClosed: true,
  weaponBulbs: superBlinders,
  capacity: 30,
  secretPassageTo: "Underwater Outpost",
  numRangers: 3,
  ranger1: {name: "Nick Walsh", skillz: "magnification burn", station: 2},
  ranger2: {name: "Drew Barontini", skillz: "uppercut launch", station: 3},
  ranger3: {name: "Christine Wong", skillz: "bomb defusing", station: 1}
};
function dontPanic (location){
  var list = "";
  for(var i = 1; i<=location.numRangers; i++){
    list = list + location["ranger" + i].name + ", man the " +
           location.weaponBulbs[location["ranger"+i].station-1][0] + 
           "!\n";
  }
  console.log("Avast, me hearties!\n" + 
        "There be Pirates nearby! Stations!\n" + list);
}
dontPanic(lighthouseRock);

// Object functionality
// 1. I have to add this function...
// function addRanger(location, name, skillz, station){
//   location.numRangers++;
//   location["ranger" + location.numRangers] = {
//     name: name, 
//     skillz: skillz, 
//     station: station 
//   }; 
// }
// to the object "lighthouseRock"

var superBlinders = [ ["Firestorm", 4000], ["Solar Death Ray", 6000], ["Supernova", 12000] ];
var lighthouseRock = {
  gateClosed: true,
  weaponBulbs: superBlinders,
  capacity: 30,
  secretPassageTo: "Underwater Outpost",
  numRangers: 3,
  ranger1: {name: "Nick Walsh", skillz: "magnification burn", station: 2},
  ranger2: {name: "Drew Barontini", skillz: "uppercut launch", station: 3},
  ranger3: {name: "Christine Wong", skillz: "bomb defusing", station: 1},
  //Here it is
  addRanger: function (name, skillz, station) 
  {
    this[name] = {skillz: skillz, station: station};
  }
};

//Now let's add a new Ranger...
lighthouseRock.addRanger("Jordan Wade", "dual-wield hand crossbow", 4);

// Now,  I need to create a new function to add elements to the array of superBlinders
var superBlinders = [ ["Firestorm", 4000], ["Solar Death Ray", 6000], ["Supernova", 12000] ];
var lighthouseRock = {
  gateClosed: true,
  weaponBulbs: superBlinders,
  capacity: 30,
  secretPassageTo: "Underwater Outpost",
  numRangers: 3,
  ranger1: {name: "Nick Walsh", skillz: "magnification burn", station: 2},
  ranger2: {name: "Drew Barontini", skillz: "uppercut launch", station: 3},
  ranger3: {name: "Christine Wong", skillz: "bomb defusing", station: 1}, 
  addRanger: function (name, skillz, station){
    this.numRangers++;
    this["ranger" + this.numRangers] = {
      name: name, 
      skillz: skillz, 
      station: station 
    }; 
  },
  addBulb: function(name, wattage){
      var temp = [name, wattage];
      lighthouseRock.weaponBulbs.push(temp);
  }
};

//Now let's use the following function to add elements...
lighthouseRock.addBulb = function (name, wattage){
  this.weaponBulbs.push([name, wattage]);
};
// There we go:
lighthouseRock.addBulb("Blasterbright", 5000);
lighthouseRock.addBulb("Sight Slayer", 1800);
lighthouseRock.addBulb("Burner of Souls", 7500);

// A lot of text to describe this exercise:
var vehicle3 = {
  type: "Submarine", capacity: 8, storedAt: "Underwater Outpost",
  ranger1: { name: "Gregg Pollack", skillz: "Lasering", dayOff: "Friday"},
  ranger2: { name: "Bijan Boustani", skillz: "Roundhouse Kicks", dayOff: "Tuesday"},
  ranger3: { name: "Ashley Smith", skillz: "Torpedoing", dayOff: "Friday"},
  ranger4: { name: "Mark Krupinski", skillz: "Sniping", dayOff: "Wednesday"},
  numRangers: 4
};
function relieveDuty (vehicle, day){
  var offDuty = [ ];
  var onDuty = [ ];
  for(var i = 1; i<=vehicle["numRangers"]; i++){
    if(vehicle["ranger" + i]["dayOff"] == day){
      offDuty.push(vehicle["ranger" + i]);
    }
    else{
      onDuty.push(vehicle["ranger" + i]);
    }
    delete vehicle["ranger" + i];
  }
  vehicle.numRangers -= offDuty.length;
  for(var j = 1; j<=vehicle["numRangers"]; j++){
    vehicle["ranger" + j] = onDuty.shift();
  }
  return offDuty;
}
var offToday = relieveDuty(vehicle3, "Friday");


// Enumeration
console.log("\nTime to include function to enumerate the properties and values of the objects within the objects");
var rockSpearguns = {
  Sharpshooter: {barbs: 2, weight: 10, heft: "overhand"},
  Pokepistol: {barbs: 4, weight: 8, heft: "shoulder"},
  Javelinjet: {barbs: 4, weight: 12, heft: "waist"},
  Firefork: {barbs: 6, weight: 8, heft: "overhand"},
  "The Impaler": {barbs: 1, weight: 30, heft: "chest"}
};
function listGuns (guns) {
  for (var speargun in guns) {
    console.log("Behold! "+speargun+", with "+guns[speargun].heft+" heft!");
  }
}
listGuns(rockSpearguns);

//Now, I have to include the function inside the object:
console.log("\nNow the function is moving inside the object:");
var rockSpearguns = {
  Sharpshooter: {barbs: 2, weight: 10, heft: "overhand"},
  Pokepistol: {barbs: 4, weight: 8, heft: "shoulder"},
  Javelinjet: {barbs: 4, weight: 12, heft: "waist"},
  Firefork: {barbs: 6, weight: 8, heft: "overhand"},
  "The Impaler": {barbs: 1, weight: 30, heft: "chest"},
  listGuns: function (){
    for(var property in this){
      if (this[property]["barbs"]){
        console.log("Behold! " + property +
                    ", with " + this[property]["heft"] +
                    " heft!");      
      }
    }
  }
};
//Use the fucking bracket notation to call the fucking function
rockSpearguns['listGuns']();
console.log("\nAlternatively, you can use the damn 'dot' notation:");
rockSpearguns.listGuns();

// LEVEL 5 of Javascript Roadtrip Part 3
// Object prototype
console.log("\nLEVEL 5 of JAVASCRIPT PART 3")

console.log("- Create a method in an Array prototype:")
var canyonCows = [
  {name: "Bessie", type: "cow", hadCalf: "Burt"},
  {name: "Donald", type: "bull", hadCalf: null},
  {name: "Esther", type: "calf", hadCalf: null},
  {name: "Burt", type: "calf", hadCalf: null},
  {name: "Sarah", type: "cow", hadCalf: "Esther"},
  {name: "Samson", type: "bull", hadCalf: null},
  {name: "Delilah", type: "cow", hadCalf: null}
];

Array.prototype.countCattle = function(animal){
  var numberAnimal = 0;
  for (var i = 0;i<this.length;i++){
    if (this[i].type == animal){
      numberAnimal++;
    }
  }
  return numberAnimal;
}

var tellme = canyonCows.countCattle("cow");
console.log(tellme);

//Next exercise
console.log("\nCount the number of elements adding function to the Array prototype...")
var canyonCows = [
  {name: "Bessie", type: "cow", hadCalf: "Burt"},
  {name: "Donald", type: "bull", hadCalf: null},
  {name: "Esther", type: "calf", hadCalf: null},
  {name: "Burt", type: "calf", hadCalf: null},
  {name: "Sarah", type: "cow", hadCalf: "Esther"},
  {name: "Samson", type: "bull", hadCalf: null},
  {name: "Delilah", type: "cow", hadCalf: null}
];
var valleyCows = [
  {name: "Danielle", type: "cow", hadCalf: null},
  {name: "Brittany", type: "cow", hadCalf: "Christina"},
  {name: "Jordan", type: "bull", hadCalf: null},
  {name: "Trevor", type: "bull", hadCalf: null},
  {name: "Christina", type: "calf", hadCalf: null},
  {name: "Lucas", type: "bull", hadCalf: null}
];
var forestCows = [
  {name: "Legolas", type: "calf", hadCalf: null},
  {name: "Gimli", type: "bull", hadCalf: null},
  {name: "Arwen", type: "cow", hadCalf: null},
  {name: "Galadriel", type: "cow", hadCalf: null},
  {name: "Eowyn", type: "cow", hadCalf: "Legolas"}
];

Array.prototype.countCattle = function ( kind ){
  var numKind = 0;
  for(var i = 0; i<this.length; i++){
    if(this[i].type == kind){
      numKind++;
    }
  }
  return numKind;
};
console.log(canyonCows.countCattle("calf")+valleyCows.countCattle("bull")+forestCows.countCattle("cow"));

// Hijos de puta!! esta la tenía bien!!!!
console.log("\nNow we need two functions here added to the object and array prototype");

var forestCows = [
  {name: "Legolas", type: "calf", hadCalf: null},
  {name: "Gimli", type: "bull", hadCalf: null},
  {name: "Arwen", type: "cow", hadCalf: null},
  {name: "Galadriel", type: "cow", hadCalf: null},
  {name: "Eowyn", type: "cow", hadCalf: "Legolas"}
];

Object.prototype.noCalvesYet = function() {
  if (this.type == "cow" && this.hadCalf == null) {
      return true;
    }
    return false;
};

Array.prototype.countForBreeding = function() {
  var numToBreed = 0;
  for (var i = 0; i<this.length;i++){
    if (this[i].noCalvesYet()){
      numToBreed++;
    }
  }
  return numToBreed;
};

console.log(forestCows.countForBreeding());

console.log("\nAnd now I have to use this functions to go through this list and provide the number:");

var canyonCows = [
  {name: "Bessie", type: "cow", hadCalf: "Burt"},
  {name: "Donald", type: "bull", hadCalf: null},
  {name: "Esther", type: "calf", hadCalf: null},
  {name: "Burt", type: "calf", hadCalf: null},
  {name: "Sarah", type: "cow", hadCalf: "Esther"},
  {name: "Samson", type: "bull", hadCalf: null},
  {name: "Delilah", type: "cow", hadCalf: null}
];

var valleyCows = [
  {name: "Danielle", type: "cow", hadCalf: null},
  {name: "Brittany", type: "cow", hadCalf: "Christina"},
  {name: "Jordan", type: "bull", hadCalf: null},
  {name: "Trevor", type: "bull", hadCalf: null},
  {name: "Christina", type: "calf", hadCalf: null},
  {name: "Lucas", type: "bull", hadCalf: null}
];

var forestCows = [
  {name: "Legolas", type: "calf", hadCalf: null},
  {name: "Gimli", type: "bull", hadCalf: null},
  {name: "Arwen", type: "cow", hadCalf: null},
  {name: "Galadriel", type: "cow", hadCalf: null},
  {name: "Eowyn", type: "cow", hadCalf: "Legolas"}
];

var badlandsCows = [
  {name: "Voldemort", type: "bull", hadCalf: null},
  {name: "Maleficent", type: "cow", hadCalf: null},
  {name: "Ursula", type: "cow", hadCalf: "Draco"},
  {name: "Draco", type: "calf", hadCalf: null},
  {name: "Joker", type: "bull", hadCalf: null},
  {name: "Chucky", type: "calf", hadCalf: null},
  {name: "Samara", type: "cow", hadCalf: "Chucky"}
];
console.log("What a minute. What's going on with "+forestCows.countForBreeding());
var numPriorityCows = canyonCows.countForBreeding()+valleyCows.countForBreeding()+forestCows.countForBreeding()+badlandsCows.countForBreeding();
console.log("\tHerd-merger has indicated "+numPriorityCows+" cows of top breeding priority.");

//INHERETANCE AND CONSTRUCTOR
console.log("\nTime for Inheritance:");
var genericPost = {
  x: 0, 
  y: 0, 
  postNum: undefined,
  connectionsTo: undefined,
  sendRopeTo: function ( connectedPost ) {
     if(this.connectionsTo == undefined){
       var postArray = [ ];
       postArray.push(connectedPost);
       this.connectionsTo = postArray;
     } else {
       this.connectionsTo.push(connectedPost);
     }
   }
  };

console.log(genericPost);

var post1 = Object.create(genericPost);
var post2 = Object.create(genericPost);
post1.x = -2;
post1.y = 4;
post1.postNum = 1;

post2.x = 5;
post2.y = 1;
post2.postNum = 2;

post1.connectionsTo = post2;
post2.connectionsTo = post1;


console.log(post1);
console.log(post2);

// Next challenge:
var post8 = Object.create(genericPost);
var post9 = Object.create(genericPost);
var post10 = Object.create(genericPost);

post8.x = 0;
post8.y = -3;
post8.postNum = 8;
post8.sendRopeTo(post10);
post9.x = 6;
post9.y = 8;
post9.postNum = 9;
post9.sendRopeTo(post10);

post10.x = -2;
post10.y = 3;
post10.postNum = 10;
post10.sendRopeTo(post8);
post10.sendRopeTo(post9);
post9.numBirds = 0;
post10.weathervane = "N";
post8.lightsOn = false;
post10.lightsOn = false;

//Building a constructor
// I got it fucking right!!
// function Fencepost (xX, yY, postNUMB) {
//   this.x = xX;
//   this.y = yY;
//   this.postNum = postNUMB;
//   this.connectionsTo = [];
//   this.sendRopeTo = function(connectedPost) {
//        this.connectionsTo.push(connectedPost);
//   };
// }
//This was the solution!!
function Fencepost (x, y, postNum){
  this.x = x;
  this.y = y;
  this.postNum = postNum;
  this.connectionsTo = [];
  this.sendRopeTo = function ( connectedPost ){
    this.connectionsTo.push(connectedPost);
  };
}

var post18 = new Fencepost(-3, 4, 18);
var post19 = new Fencepost(5,-1,19);
var post20 = new Fencepost(-2,10,20);

// post18.sendRopeTo(post20);
// post20.sendRopeTo(post18);
// post18.sendRopeTo(post19);
// post19.sendRopeTo(post18);

//Now Identify the portions of the constructor that should be available to everybody
// function Fencepost (x, y, postNum){
//   this.x = x;
//   this.y = y;
//   this.postNum = postNum;
//   this.connectionsTo = [];
// }

// function Fencepost(x, y, postNum){
//   this.x = x;
//   this.y = y;
//   this.postNum = postNum;
//   this.connectionsTo = [];
// }

// Fencepost.prototype = 
// {
//   sendRopeTo: function ( connectedPost )
//   {
//     this.connectionsTo.push(connectedPost);
//   },
//   removeRope: function ( removeTo )
//   {
//     var temp = [];
//     for(var i = 0; i<this.connectionsTo.length; i++)
//     {
//        if(this.connectionsTo[i].postNum != removeTo)
//        {
//          temp.push(this.connectionsTo[i]);
//        }
//     }
//   },
//   movePost: function (x, y)
//   {
//     this.x = x;
//     this.y = y;
//   },
// }

// OVERRIDING PROTOTYPAL METHODS
var x = 4;
var y = "4";
console.log(x.valueOf()+" and y = "+y.valueOf());
if (x.valueOf()===y.valueOf())
{
  console.log("Yep, they are equal");
}
else
{
  console.log("noooooop, they are NOT equal");
}

console.log("\nNow let's override the native valueOf");

Fencepost.prototype.valueOf = function () {
  var pre = ( Math.pow(this.x, 2) + Math.pow(this.y,2) );
  var straightLineDistance =  Math.sqrt(pre);
  return straightLineDistance;
};

var xx = Math.pow(x,2);
console.log(xx);

console.log(post18.valueOf());

console.log("\n\nAND FINALLY, finally, the final exercise, override the toString method...");

var post18 = new Fencepost(-3, 4, 18);
var post19 = new Fencepost(5,-1,19);
var post20 = new Fencepost(-2,10,20);

function Fencepost (x, y, postNum){
  this.x = x;
  this.y = y;
  this.postNum = postNum;
  this.connectionsTo = [];
}

Fencepost.prototype = {
  sendRopeTo: function ( connectedPost ){
    this.connectionsTo.push(connectedPost);
  },
  removeRope: function ( removeTo ){
    var temp = [];
    for(var i = 0; i<this.connectionsTo.length; i++){
      if(this.connectionsTo[i].postNum != removeTo){
        temp.push(this.connectionsTo[i]);
      }
    }
    this.connectionsTo = temp;
  },
  movePost: function (x, y){
    this.x = x;
    this.y = y;
  },
  valueOf: function (){
  return Math.sqrt( this.x*this.x + this.y*this.y );
  }
};

Fencepost.prototype.toString = function() {
  var list = "";
  for (var i = 0; i < this.connectionsTo; i++)
  {
    list = list + this.connectionsTo[i].postNum + "\n";
  }
  return "Fence post #"+this.postNum+":\n"+
  "Connected to posts:\n" + list +
  "Distance from ranch:"+this.valueOf()+" yards\n";
}

post18.toString();


