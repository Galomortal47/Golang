recomended framerate for clientt data is 30
it's not recommended more than 60 users in a single node with a framerate of 60 or above
do not put more than 200 users in a single node as it will cause extreme instability
an framerate above a 100 is not recomended, the server process data at 120, so anything above that is wasting resources
nthreads help latency, but reduce maximun number of clients, as it sideline data in multiple conections

commands for the CLI.js

status: show up all the status of the server nodes.

start [server node port]: spawn an server node at a specified port for example "start 8082".

mstart [server node port] [number of nodes]: spawn multiple server nodes, starting from the port number specified for example "start 8082 5"
will spawn on ports 8082,8083,8084,8085,8086,8087.

close [server node port]: close a server node at a specified port.

stime [server node port]: show online time of the server node at the specified port.

clear: cleans the text on screen.

var [server node port] [variable name] [new value]: change an server node variable at an specified port for example "var 8082 password 123" will change the 
server node password to "123".