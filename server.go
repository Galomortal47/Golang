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
    "bufio"
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
  fmt.Println("Launching server...")
//  go send_data2()
  go generate_data()
  go recive_data()
  for{}
}

func recive_data(){
    /* Lets prepare a address at any address at port 10001*/
    ln, err := net.Listen("tcp", ":8081")
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
    writer := bufio.NewWriter(conn)
    n, err := conn.Read(buf)
    if err != nil{
      conn.Close()
      return
    }
    if(n > 4){
      json.Unmarshal(buf[0:n], &parsed)
      maper, ok := parsed.(map[string]interface{})
      if !ok {
        fmt.Println("Error on interface to map conversion")
      }
      database.Set(maper["id"].(string), parsed, cache.DefaultExpiration)
      writer.Write(send_buffer_size)
      writer.Write(send_buffer)
      writer.Flush()
    }
  }
}

func generate_data(){
  for{
    data := database.Items()
    data2, err := json.Marshal(data)
    CheckError(err)
    send_buffer = []byte((data2))
    fmt.Print("\rcurrent number of clients: ", len(data), " currently server is using : ", len(string(data2))*8*60/1000, " kbps of data");
    binary.LittleEndian.PutUint32(send_buffer_size ,uint32(len(data2)))
    time.Sleep(time.Second / 60)
  }
}

//func send_data2(){
//  for {
//    data := database.Items()
//    data2, err := json.Marshal(data)
//    CheckError(err)
//    address := clients_db.Items()
//    //fmt.Println(address)
//    buf := []byte((data2))
//    b := make([]byte, 4)
//    binary.LittleEndian.PutUint32(b,uint32(len(data2)))
//    for _, value := range address {
//        userIdArray:= value.Object.(*net.TCPConn)
//        userIdArray.Write(b)
//        userIdArray.Write(buf)
//    }
//    time.Sleep(time.Second / 60)
//  }
//}
