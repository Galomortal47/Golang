const { exec } = require('child_process');

var serverList = []
var i;
for (i=0;i < 5; i++){
  serverList[i] = exec('go run server.go :808' + i);
  serverList[i].stdout.pipe(process.stdout);
}
