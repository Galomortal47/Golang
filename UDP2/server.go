package main

import (
    "fmt"
    "net"
    "os"
    "github.com/patrickmn/go-cache"
    "encoding/json"
    "strconv"
    "time"
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
    ServerAddr,err := net.ResolveUDPAddr("udp",":" + strconv.Itoa(Port))
    CheckError(err)

    /* Now listen at selected port */
    ServerConn, err := net.ListenUDP("udp", ServerAddr)
    CheckError(err)
    defer ServerConn.Close()

    buf := make([]byte, 1024)

    for {
        n,remoteAddr,err := ServerConn.ReadFromUDP(buf)
        //fmt.Println(remoteAddr.IP)
        json.Unmarshal((buf[8:n-1]), &parsed)
        maper, _ := parsed.(map[string]interface{})
        clients_db.Set(maper["id"].(string), remoteAddr.IP , cache.DefaultExpiration)
        database.Set(maper["id"].(string), string(buf[8:n-1]), cache.DefaultExpiration)
        if err != nil {
            fmt.Println("Error: ",err)
        }
    }
}

func send_data2(){ //client *net.UDPAddr
  for {
    data := database.Items()
    data2, _ := json.Marshal(data)
    address := clients_db.Items()
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

    }
  time.Sleep(time.Second / 60 )
  }
}
