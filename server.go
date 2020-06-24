package main

import (
    "fmt"
    "net"
    "os"
    "github.com/patrickmn/go-cache"
    "encoding/json"
    //"strconv"
    "time"
    //"byteBuffer"
    // /"math"
    //"bufio"
    "encoding/binary"
)

var Port = 10001

var parsed interface{}

/* A Simple function to verify error */
func CheckError(err error) {
    if err  != nil {
        fmt.Println("Error: " , err)
        os.Exit(0)
    }
}

var database = cache.New(1*time.Second, 3*time.Second)
var clients_db = cache.New(1*time.Second, 3*time.Second)

func main() {
  go send_data2()
  recive_data()
}

func recive_data(){
    /* Lets prepare a address at any address at port 10001*/
    fmt.Println("Launching server...")

    ln, _ := net.Listen("tcp", ":8081")

    conn, _ := ln.Accept()

    buf := make([]byte, 1024)

    for {
        n, _ := conn.Read(buf)

        if(n > 4){
          //fmt.Println(conn)
          json.Unmarshal(buf[0:n], &parsed)
          maper, _ := parsed.(map[string]interface{})
          clients_db.Set(maper["id"].(string), conn , cache.DefaultExpiration)
          database.Set(maper["id"].(string), string(buf[0:n]), cache.DefaultExpiration)
        }
    }
}

func send_data2(){ //client *net.UDPAddr
  for {
    data := database.Items()
    data2, _ := json.Marshal(data)
    address := clients_db.Items()
    //fmt.Println(data)
    for _, value := range address {
        userIdArray:= value.Object.(*net.TCPConn)
        buf := []byte((data2))
        //buf := []byte(string(data2) + "\n")
        //fmt.Println(string(buf))
        b := make([]byte, 4)
        binary.LittleEndian.PutUint32(b,uint32(len(data2)))
        //fmt.Println(b)
        userIdArray.Write(b)
        userIdArray.Write(buf)
        time.Sleep(time.Second / 60)
    }

  }
}
