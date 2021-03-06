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
 datacomp(false)
}, 1000);

function datacomp(print){
      //console.clear()
      var string = redis_db.all_cache("golang server*");
      var key = string[0]
      var data = string[1]
      if (!(data == null)){
        for (i=0;i<data.length;i++){
          if (IsValidJSONString(data[i])){
           var json = JSON.parse(data[i]);
           var space = "   "
           if (!(json == null)){
               var message =
                     "name: " + json.servername + space +
                     "map: " + json.map + space +
                     "gamemode: " + json.gamemode + space +
                     "ping: " + parseInt(json.ping) + space +
                     "players: " + json.currplayer + "/" + json.maxplayers + space +
                     "ip: " + ipv4 + space +
                     "port: " + json.port + space +
                     "password: " + json.password;
                if(print){
                     console.log(message);
                     console.log("\n");
                }
                json["ip"] = ipv4
                send_data[i] = json
          }
        }
        process.send(JSON.stringify(send_data))
      }
    }
}

function IsValidJSONString(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}

module.exports = {
    datacomp: function () {
      datacomp(true);
    }
};
