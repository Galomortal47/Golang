package main

import (
    "fmt"
    "net"
    "os"
    "encoding/json"
    "time"
    "encoding/binary"
    "runtime"
    "./redis"
    "strings"
    "strconv"
    "sync"
)

var parsed interface{}
var parsed2 interface{}

var send_buffer = make([]byte, 1024)
var send_buffer_size = make([]byte, 4)

var data_interface = make(map[string]interface{})
var data_expire_time = make(map[string]int)
var mutex sync.RWMutex

var servername = "null"
var password = "123"
var _map = "null"
var gamemode = "null"
var maxs_ping = 1000

/* A Simple function to verify error */
func CheckError(err error) {
    if err  != nil {
        _, _, line, _ := runtime.Caller(1)
        fmt.Println( "\n" ,"Error: " , err, "erro at line: ", line )
        os.Exit(0)
    }
}

func main() {
  argsWithProg := os.Args[1:]
  fmt.Println("\n"+"Launching server...")
  go load_redis_config()
  go generate_data()
  go store_server_data()
  go old_data_purge()
  go UDPserver(argsWithProg)
  recive_data(argsWithProg)
}

func recive_data(port []string){ //function that distribute clients to handlers
    justString := strings.Join(port," ")
    fmt.Println("server TCP intialized in port:", justString)
    ln, err := net.Listen("tcp", justString)
    CheckError(err)
    defer ln.Close()
    for {
        conn, err := ln.Accept()
        CheckError(err)
        tcp := conn.(*net.TCPConn)
        tcp.SetNoDelay(true)
        go handleconnection(conn)
    } 
}

func UDPserver(port []string){
	justString := strings.Join(port," ")
	res1 := strings.Trim(justString, ":") 
     interger, _ := strconv.Atoi(res1)
     //fmt.Println(strconv.Itoa(interger))
     fmt.Println("server UDP intialized in port:", justString)
     addr := net.UDPAddr{
	   	Port: interger,
  		IP:   net.ParseIP("0.0.0.0"),
	}
    conn, err := net.ListenUDP("udp", &addr)
    CheckError(err)
    go handleconnectionUDP(conn)
}

func handleconnectionUDP( conn *net.UDPConn){
    buf := make([]byte, 1024)
    for{
    	rlen, _, err := conn.ReadFromUDP(buf[:])
    	CheckError(err)
    	//fmt.Println((buf[8:rlen-2]))
    	json.Unmarshal(buf[8:rlen-2], &parsed2)
    	//fmt.Println((parsed2))
	maper, _ := parsed2.(map[string]interface{})
     mutex.Lock()
      if(maper["pwd"].(string) == password){
        data_interface[maper["id"].(string)] = maper
        //fmt.Println((data_interface))
        data_expire_time[maper["id"].(string)] = int(time.Now().UnixNano() / int64(time.Millisecond))
      }
      mutex.Unlock()
    }
	}

func handleconnection( conn net.Conn){ // function that handle clients\
//  var slice = 0
  for{
    buf := make([]byte, 1024)
    _, err := conn.Read(buf)
    if err != nil{
      conn.Close()
      return
    }
    //fmt.Println(string(buf))
//	if(string(buf[0:1]) != "{"){ // checking if it's an message with or without an Uint32 contatining lengh of msg
//		slice = int(binary.LittleEndian.Uint32(buf[:4]))
//		if(slice > 1023){
//			slice = 0
//			}
//	}
//	fmt.Println((slice))
//    if(n > 0){
//	  if(string(buf[n-slice:n-slice+1]) == "{"){ // checking if it stats with a semi coolor, to see if it should shift 4 bytes or not
//		    json.Unmarshal(buf[n-slice:n], &parsed)
//	  }else{
//      if(string(buf[0:1]) == "{"){
//		      json.Unmarshal(buf[0:slice], &parsed)
//        }else{
//          json.Unmarshal(buf[4:slice+4], &parsed)
//        }
//	  }
// fmt.Println(parsed)
   //   maper, _ := parsed.(map[string]interface{})
   //   mutex.Lock()
   //   if(maper["pwd"].(string) == password){
   //     data_interface[maper["id"].(string)] = maper
   //     data_expire_time[maper["id"].(string)] = int(time.Now().UnixNano() / int64(time.Millisecond))
   //   }
   //   mutex.Unlock()
      conn.Write(send_buffer_size)
      conn.Write(send_buffer)
 //   }
  }
}
func generate_data(){ // capture database data and send to client
  for{
    mutex.RLock()
    data2, err := json.Marshal(data_interface)
    mutex.RUnlock()
    CheckError(err)
    send_buffer = []byte((data2))
    binary.LittleEndian.PutUint32(send_buffer_size ,uint32(len(data2)))
    time.Sleep(time.Second / 120)
  }
}

func old_data_purge(){
  for{
    for key,value := range data_expire_time{
      mutex.Lock()
      if(int(time.Now().UnixNano() / int64(time.Millisecond)) - value > maxs_ping){
        delete(data_expire_time, key)
        delete(data_interface, key)
      }
      mutex.Unlock()
    }

    time.Sleep(time.Second * 3)
  }
}

func load_redis_config(){// load commands uploaded to the redis database
  for{
    justString := strings.Join(os.Args[1:]," ")
    test := redis.Get("commands" + justString)
    //fmt.Println("commands" + justString)
    result := strings.Split(test," ")
    if("kill" == result[0]){
      os.Exit(0)
    }
    if("name" == result[0]){servername = result[1]}
    if("password" == result[0]){password = result[1]}
    if("map" == result[0]){_map = result[1]}
    if("gamemode" == result[0]){gamemode = result[1]}
    time.Sleep(time.Second)
  }
}

func store_server_data(){ // function that save metadeta to redis
  for{
      data := make(map[string]string)
      data["servername"] = servername
      data["map"] = _map
      data["gamemode"] = gamemode
      data["maxplayers"] = "32"
      data["password"] = password
      data["ping"] = strconv.Itoa(int(time.Now().UnixNano() / int64(time.Millisecond)))
      data["currplayer"] = strconv.Itoa(len(data_expire_time))
      data["port"] = strings.Join(os.Args[1:]," ")
      data2, err := json.Marshal(data)
      CheckError(err)
      justString := strings.Join(os.Args[1:]," ")
      redis.Set("golang server" + justString, string(data2))
      time.Sleep(time.Second)
    }
}
