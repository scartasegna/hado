var http = require('http')

http.createServer(onRequest).listen(3000);
console.log('Server has started');

function onRequest(request, response){
  response.write('Hello V1.6.1');
  response.end();
}
