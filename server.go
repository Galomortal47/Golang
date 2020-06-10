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

func main() {
  go send_data()
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
        n,_,err := ServerConn.ReadFromUDP(buf)
        json.Unmarshal((buf[8:n-1]), &parsed)
        maper, _ := parsed.(map[string]interface{})
        database.Set(maper["id"].(string), string(buf[8:n-1]), cache.DefaultExpiration)
        //fmt.Println(maper["id"]," Received ",string(buf[0:n]))//, " from "),addr)
        //foo, found := database.Get(maper["id"].(string))
        //	if found {
        //		fmt.Println(foo.(string))
        //	}
        if err != nil {
            fmt.Println("Error: ",err)
        }
    }
}

func send_data(){
  for {
    data := database.Items()
    data2, _ := json.Marshal(data)
    //buf := []byte(data2)
    fmt.Println(len(data2))
    time.Sleep(time.Second / 60)
  }
}
