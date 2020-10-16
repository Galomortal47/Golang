const childProcess = require('child_process');
var run = require('./run.js');
const { exec } = require('child_process');
const redis = require('./redis.js');
var redis_db = new redis;

var servers = {};

process.stdin.on('data', (chunk) => {
  let str = chunk.toString();
  str = str.slice(0,-2)
  let res = str.split(" ");
  console.log(res);

  if (res[0] == "exit"){
    process.exit(0)
  }

  if (res[0] == "status"){
    console.log("the current status of the server is: ");
    run.datacomp();
  }

  if (res[0] == "start"){
    servers[res[1]] = exec('go run server.go :'+ res[1]);
    console.log("server lahched at port: " + res[1]);
  }

  if (res[0] == "close"){
    redis_db.set_cache("commands:" + res[1],10, "kill")
    //console.log("commands:" + res[1]);
    console.log("server closed at port: " + res[1]);
  }

  if (res[0] == "var"){
    redis_db.set_cache("commands:" + res[1],10, res[2] + " " + res[3])
    //console.log("commands:" + res[1]);
    console.log("var: " + res[2] +  " at server changed to: " + res[3] + " at port: " + res[1]);
  }

  if (res[0] == "clear"){
  console.clear()
  }
});
