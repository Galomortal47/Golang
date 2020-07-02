const cp = require("child_process");

var test = 10;
var threads = 1;
var servers_n = 1;
var i = 1

setInterval(function () {
	if(i < test){
		var env = {
			port : 8081,
			server:'mada',
			ip: "127.0.0.1",
			refresh_rate: 60
		};
		var p1 = cp.fork("stress.js", {env:env});
		i += 1;
	}
}, 60);
