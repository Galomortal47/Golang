const { exec } = require('child_process');
const redis = require('./redis.js');
var redis_db = new redis;

var serverList = []
var i = 0;

process.on('uncaughtException', function (err) {
  console.log('Caught exception: ', err);
});

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
         console.log("server n" + key[i] + ": ");
         console.log("number of players: " + Object.keys(json).length.toString());
         console.log("data usage: " + parseInt((data[i].toString().length *2*8*60/1000)).toString() + " kbps");
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
