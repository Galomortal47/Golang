package main

import (
    "fmt"
    "net"
    "os"
    "github.com/patrickmn/go-cache"
    "encoding/json"
    "time"
    "encoding/binary"
    "runtime"
    "strings"
)

var Port = 10001
var parsed interface{}
var send_buffer = make([]byte, 1024)
var send_buffer_size = make([]byte, 4)

/* A Simple function to verify error */
func CheckError(err error) {
    if err  != nil {
        _, _, line, _ := runtime.Caller(1)
        fmt.Println( "\n" ,"Error: " , err, "erro at line: ", line )
        os.Exit(0)
    }
}

var database = cache.New(1*time.Second, 3*time.Second)
//var clients_db = cache.New(1*time.Second, 3*time.Second)

func main() {
  argsWithProg := os.Args[1:]
  fmt.Println("\n"+"Launching server...")
  go generate_data()
  recive_data(argsWithProg)
}

func recive_data(port []string){
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

func handleconnection( conn net.Conn){
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
      database.Set(maper["id"].(string), parsed, cache.DefaultExpiration)
      conn.Write(send_buffer_size)
      conn.Write(send_buffer)
    }
  }
}
func generate_data(){
  for{
    data := database.Items()
    data2, err := json.Marshal(data)
    CheckError(err)
    send_buffer = []byte((data2))
    fmt.Print("\rcurrent number of clients: ", len(data), " currently server is using : ", len(send_buffer)*8*60 / 1000, " kbps of data");
    binary.LittleEndian.PutUint32(send_buffer_size ,uint32(len(data2)))
    time.Sleep(time.Second / 120)
  }
}
