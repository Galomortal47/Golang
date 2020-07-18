var packet = 'hello';
var client = this;
var total_players = 0;
var i;
var room = {};
var buffer = new Buffer.alloc(4);
var users = [];
var message = [];
var fs = require('fs');
var net = require('net');
var data;
var sockets = [];
var player_sockets = {};
var player_servers = {};
var room_aux = {}
var port = 8079;
var refresh_rate = 1000;

process.on('uncaughtException', function (err) {
  console.log('Caught exception: ', err);
});

process.on('message', function (message) {
    //console.log('Message from Child process : ' + message);
    for (i=0;i<sockets.length;i++)
    {
        var send = message;//JSON.stringify(message);
          buffer.writeUInt32LE(send.length);
          sockets[i].bufferisnotfull = sockets[i].write(buffer);
          sockets[i].bufferisnotfull = sockets[i].write(send);
      }
});

console.log("ServerBrowser Initialized to port: " + port);

  net.createServer(function(socket){ //connectionListener
  socket.bufferisnotfull = true;
  sockets.push(socket);
  console.log("user of ip: " + socket.address().address + " is server_Browsing on port: " + port );

  socket.on('drain', () => {
      socket.bufferisnotfull = true;
  });

  	socket.on('error', function(err){
        var index = sockets.indexOf(socket);
      if(!(index == -1)){
  		  sockets.splice(index,1);
      }
  	});

  	var size_int = 0;
  	var string = "";

  	socket.on('data', function(data){
  		// Cutting the Irelevants Parts of the buffer and converting to Json
      string = data.toString();
  		if (string[0] == "{"){
  			var fixs = string;
  		}
  		else
  		{
        var data_processed = data.slice(4,data.length);
        string = data_processed.toString();
      }

  		//verifying if json is valid
  			if (IsValidJSONString(string)){
  				// manipulating Json Data

  		  }
      });
  }).listen(port);

function IsValidJSONString(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}
