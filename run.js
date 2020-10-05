const { exec } = require('child_process');
const redis = require('./redis.js');
const publicIp = require('public-ip');
const childProcess = require('child_process');
var process = childProcess.fork('./browse_list.js');

var redis_db = new redis;
var serverList = []
var i = 0;
var ipv4
var ipv6

var send_data = []

redis_db.clean_all_cache()

process.on('uncaughtException', function (err) {
  console.log('Caught exception: ', err);
});

(async () => {
	ipv4 = await publicIp.v4();
  console.log(ipv4);
	//=> '46.5.21.123'

	ipv6 = await publicIp.v6();
  console.log(ipv6);
	//=> 'fe80::200:f8ff:fe21:67cf'
})();

setInterval(function () {
  if(i < 5){
    serverList[i] = exec('go run server.go ' + (i + 8082) + " " + "35c246d5");
    i++
    }
}, 200);

setInterval(function () {
      console.clear()
      var json_array = [];
      var string = redis_db.all_cache("golang_instance*");
      var key = string[0];
      var data = string[1];
      if (!(data == null)){
        for (i=0;i<data.length;i++){
          if (IsValidJSONString(data[i])){
             json_array[i] = JSON.parse(data[i]);
         }
       }
     }
     var json_sort = json_array.sort((a, b) => a.port - b.port);
       for (i=0;i<json_array.length;i++){
         json = json_sort[i];
           var space = "   ";
               var message =
                     "name: " + json.servername + space +
                     "map: " + json.map + space +
                     "gamemode: " + json.gamemode + space +
                     "ping: " + parseInt(json.ping) + space +
                     "players: " + json.currplayer + "/" + json.maxplayers + space +
                     "ip: " + ipv4 + space +
                     "port: " + json.port + space +
                     "password: " + json.password + space +
                     "ping_user" + json.ping_user;
                console.log(message);
                console.log("\n");
                json["ip"] = ipv4;
                json["port"] = key[i];
                json["password"] = "private";
                send_data[i] = json;

        process.send(JSON.stringify(send_data));
      }
}, 500);

function IsValidJSONString(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}
