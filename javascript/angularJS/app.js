// The file that includes our modules

(function(){

	var app = angular.module('store', [ ]); //The empty array are the dependencies

	app.controller('StoreController', function(){
		this.products = gems;
	});

	var gems = [
		{
			name: 'Vetusta Morla',
			price: 10,
			description: 'The last album by Vetusta Morla',
			canPurchase: true,
			soldOut: false		
		},
		{
			name: 'Depeche Mode',
			price: 15,
			description: 'The entire collection of a legendary band',
			canPurchase: true,
			soldOut: false		
		}
	]
})();


