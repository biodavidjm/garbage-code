'use strict';

var express = require('express');
var app = express();


app.set('view options', {layout: false});

var currentDir = process.cwd();
app.use(express.static( currentDir + '/'));

app.get('/', function (req, res) {
  res.send('Yep! it is working!');
  res.render('index.html');
});

var server = app.listen(1111, function () {

  var host = server.address().address;
  var port = server.address().port;

  console.log('Node Express Webapp');
  console.log('This server is listening at http://%s:%s', host, port);
  console.log('The script of the server is at '+ __dirname);
  console.log('Current directory: ' + process.cwd());

});
