const { exec } = require('child_process');
const redis = require('./redis.js');
const publicIp = require('public-ip');

var redis_db = new redis;
var serverList = []
var i = 0;
var ipv4
var ipv6

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
    serverList[i] = exec('go run server.go :808' + i);
    i++
    }
}, 10);

setInterval(function () {
      console.clear()
      var string = redis_db.all_cache("*");
      var key = string[0]
      var data = string[1]
      for (i=0;i<data.length;i++){
        if (IsValidJSONString(data[i])){
         var json = JSON.parse(data[i]);
           console.log(
             "name: " + json.servername + "\n" +
             "map: " + json.map + "\n" +
             "gamemode: " + json.gamemode + "\n" +
             "ping: " + parseInt(json.ping) + "\n" +
             "players: " + json.currplayer + "/" + json.maxplayers + "\n" +
             "ip: " + ipv4 + "\n" +
             "port: " + key[i] + "\n" +
             "password: " + json.password
         );
         console.log("\n");
      }
    }
}, 1000);

function IsValidJSONString(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}