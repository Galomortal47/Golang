package main

import (
    "fmt"
    "net"
    "os"
    "github.com/patrickmn/go-cache"
    "encoding/json"
    //"strconv"
    "time"
    //"bufio"
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
          //fmt.Println(n, buf[0:n])
          json.Unmarshal(buf[0:n], &parsed)
          maper, _ := parsed.(map[string]interface{})
          //clients_db.Set(maper["id"].(string), remoteAddr.IP , cache.DefaultExpiration)
          database.Set(maper["id"].(string), string(buf[0:n]), cache.DefaultExpiration)
        }
    }
}

func send_data2(){ //client *net.UDPAddr
  for {
    data := database.Items()
    data2, _ := json.Marshal(data)
    address := clients_db.Items()
    fmt.Println(string(data2))
    for _, value := range address {
		    //fmt.Println(key, value.Object)
        userIdArray:= value.Object.(net.IP)

        ServerAddr,err := net.ResolveUDPAddr("udp",userIdArray.String() + ":10002")
        CheckError(err)

        LocalAddr, err := net.ResolveUDPAddr("udp", "127.0.0.1:0")
        CheckError(err)

        Conn, err := net.DialUDP("udp", LocalAddr, ServerAddr)
        CheckError(err)
        //fmt.Println(string(data2))
        buf := []byte((data2))
        Conn.Write(buf)
        time.Sleep(time.Second / 60)
    }

  }
}
