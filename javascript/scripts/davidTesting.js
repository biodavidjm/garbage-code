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
  console.out("Welcome to the Badlands National Park! Try to enjoy your stay.");
}
else{
  console.out("Sorry, the Badlans are particularly bad today. We're closed!");
}
