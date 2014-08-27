//Javascript file for testing purposes	
console.log("Train #"+1+" is running.");
console.log("Train #"+2+" is running dude.");
console.log("Yeah, train #"+3+" is also running!\n");

var trainsOperational = 8;
var trainNumber = 1;

console.log("Now it's time for loops--->");
while (trainNumber <= trainsOperational) {
	console.log("Train #"+trainNumber+" is running.");
	trainNumber++;
}

console.log("That's all\n");

var parkIsOpen = true;

if ( parkIsOpen) {
  console.log("Welcome to the Badlands National Park! Try to enjoy your stay.");
}
else{
  console.log("Sorry, the Badlans are particularly bad today. We're closed!");
}

console.log("The Dam Complex exercise");

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

alert("Welcome to our page");
var userName = prompt("What is your name?");
confirm("dude, are you are " +userName+ "?");

var gotName = false;
while(gotName == false){
    var userName = prompt("Yo passenger! What's your name?");
}

// Anonymous functions
// Function on the fly: it will be held in memory only when it is used.
var diff = function (a,b) {
	return a*a - b*b;
};

console.log(diff);
