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

lighthouseRock.bulbs = [ 200, 500, 750 ];
console.log(lighthouseRock.bulbs);