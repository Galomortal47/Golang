var packet = {   "id":"test", "test":"test"
}

var net = require('net');

var refresh_rate = process.env.refresh_rate;

var HOST = process.env.ip;
var PORT = process.env.port;
var server = process.env.server;

var client = new net.Socket();

//const socket = net.createConnectieeon({port: PORT, host: HOST });

var buffer = new Buffer.alloc(4);

process.on('uncaughtException', function (err) {
  console.log('Caught exception: ', err);
});

client.connect(PORT, HOST, function() {
  console.log('Client connected to: ' + HOST + ':' + PORT);
  var id = (Math.floor((Math.random() * 10000))).toString();
  console.log("bot" + id);
	packet.id = "bot" + id;
  final_pac = JSON.stringify(packet);
  //buffer.writeUInt32LE(final_pac.length);
  client.write(final_pac);
    // Write a message to the socket as soon as the client is connected, the server will receive it as message from the client
});

setInterval(function () {
  final_pac = JSON.stringify(packet);
  client.write(final_pac);
}, refresh_rate);
