var sys = require("sys"),  
my_http = require("http");  
my_http.createServer(function(request,response){  
    sys.puts("Hey! something is touching me");  
    response.writeHeader(200, {"Content-Type": "text/plain"});  
    response.write("Hello there, this is the first testing server by DavidJM");  
    response.end();  
}).listen(8080);  
sys.puts("Server Running on 8080");require('module');