var express = require('express');
var path = require('path');
var morgan = require('morgan');
var proxy = require('proxy-middleware');
var url = require('url');
var os = require('os');
 
//app.get('/', function (req, res) {
    //console.log(req.url);
    //var options = {
        //hostname: 'www.uniprot.org',
        //path: req.url,
        //method: 'GET',
        //port: 80
    //};
    //var proxy_req = http.request(options, function(proxy_res) {
        //proxy_res.pipe(res,{end:true});
    //});
    //req.pipe(proxy_req,{end:true});
//});
 
var ipAddr = os.networkInterfaces().eth0[0].address;
var app = express();
app.use('/api/uniprot', proxy(url.parse('http://www.uniprot.org')));
app.use('/api/interpro', proxy(url.parse('http://www.ebi.ac.uk')));
app.use('/js', proxy(url.parse(['http://',ipAddr,':9000', '/js'].join())));
app.use('/', express.static(path.join(__dirname,'..')));
app.use(morgan('dev'));
 
var server = app.listen(8888);
console.log('Express server listening on http://%s:%d', server.address().address,8888);
