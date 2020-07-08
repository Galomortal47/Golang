package main

import (
    "fmt"
    "net"
    "os"
    "github.com/patrickmn/go-cache" // importing go cache
    "encoding/json"
    "time"
    "encoding/binary"
    "runtime"
    "./redis" // importing redis stuff
    "strings"
)

var parsed interface{}
var send_buffer = make([]byte, 1024)
var send_buffer_size = make([]byte, 4)

/* A Simple function to verify error */
func CheckError(err error) {
    if err  != nil {
        _, _, line, _ := runtime.Caller(1)// functiion to get error line
        fmt.Println( "\n" ,"Error: " , err, "erro at line: ", line )
        os.Exit(0)
    }
}

var database = cache.New(1*time.Second, 3*time.Second) // instancing a new data base

func main() {
  argsWithProg := os.Args[1:] // capturing enviromental variables
  fmt.Println("\n"+"Launching server...")
  go generate_data()
  go store_server_data()
  recive_data(argsWithProg)
}

func recive_data(port []string){ //function that distribute clients to handlers
    /* Lets prepare a address at any address at port 10001*/
    justString := strings.Join(port," ")
    fmt.Println("server intialized in port:", justString)
    ln, err := net.Listen("tcp", justString)
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
      json.Unmarshal(buf[0:n], &parsed) // convert JSON to map
      maper, _ := parsed.(map[string]interface{})
      database.Set(maper["id"].(string), parsed, cache.DefaultExpiration) // register data on database
      conn.Write(send_buffer_size)
      conn.Write(send_buffer) // write data back to client
    }
  }
}
func generate_data(){ // capture database data and send to client
  for{
    data := database.Items()
    data2, err := json.Marshal(data) // convert map to json
    CheckError(err)
    send_buffer = []byte((data2))
    binary.LittleEndian.PutUint32(send_buffer_size ,uint32(len(data2)))
    time.Sleep(time.Second / 120)
  }
}

func store_server_data(){
  for{
      data := database.Items()
      data2, err := json.Marshal(data) // convert map to json
      CheckError(err)
      justString := strings.Join(os.Args[1:]," ")
      fmt.Printf(string(data2))
      redis.Set(justString, string(data2))// store data on redis server
    //  redis.Get(justString)
      time.Sleep(time.Second)
    }
}
