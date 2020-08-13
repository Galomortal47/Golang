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
var send_buffer = make([]byte, 1024)
var send_buffer_size = make([]byte, 4)

var data_interface = make(map[string]interface{})
var data_expire_time = make(map[string]int)
var mutex sync.RWMutex

var maxs_ping = 600

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
  go generate_data()
  go store_server_data()
  go old_data_purge()
  recive_data(argsWithProg)
}

func recive_data(port []string){ //function that distribute clients to handlers
    justString := strings.Join(port," ")
    fmt.Println("server intialized in port:", justString)
    ln, err := net.Listen("tcp", ":8083")
    CheckError(err)
    defer ln.Close()
    for {
        conn, err := ln.Accept()
        CheckError(err)
        go handleconnection(conn)
    }
}

func handleconnection( conn net.Conn){ // function that handle clients
  for{
    buf := make([]byte, 1024)
    n, err := conn.Read(buf)
    if err != nil{
      conn.Close()
      return
    }
    if(n > 4){
      json.Unmarshal(buf[0:n], &parsed)
      maper, _ := parsed.(map[string]interface{})
      mutex.Lock()
      data_interface[maper["id"].(string)] = maper
      data_expire_time[maper["id"].(string)] = int(time.Now().UnixNano() / int64(time.Millisecond))
      mutex.Unlock()
      conn.Write(send_buffer_size)
      conn.Write(send_buffer)
    }
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
    time.Sleep(time.Second / 60)
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

func store_server_data(){ // function that save metadeta to redis
  for{
      data := make(map[string]string)
      data["servername"] = "stonkis22"
      data["map"] = "de_dust2"
      data["gamemode"] = "deathmatch"
      data["maxplayers"] = "32"
      data["password"] = "123"
      data["ping"] = strconv.Itoa(int(time.Now().UnixNano() / int64(time.Millisecond)))
      data["currplayer"] = strconv.Itoa(len(data_expire_time))
      data2, err := json.Marshal(data)
      CheckError(err)
      justString := strings.Join(os.Args[1:]," ")
      redis.Set(justString, string(data2))
      time.Sleep(time.Second)
    }
}
