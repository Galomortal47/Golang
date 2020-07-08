const { exec } = require('child_process');
const redis = require('./redis.js');
var redis_db = new redis;

var serverList = []
var i = 0;

setInterval(function () {
  if(i < 5){
    serverList[i] = exec('go run server.go :808' + i);
    i++
    }
}, 10);

setInterval(function () {
      console.clear()
      console.log(redis_db.all_cache("*"));
}, 1000);
