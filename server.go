package main

import (
    "fmt"
    "net"
    "os"
    "./redis"
    "encoding/json"
    "strconv"
)

var Port = 10000

var parsed interface{}

/* A Simple function to verify error */
func CheckError(err error) {
    if err  != nil {
        fmt.Println("Error: " , err)
        os.Exit(0)
    }
}

func main() {
    recive_data()
}

func recive_data(){
    port += 1
    redis.Flush()
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
        json.Unmarshal((buf[0:n]), &parsed)
        maper, _ := parsed.(map[string]interface{})
      //  redis.Set(maper["id"].(string),string(buf[0:n]))
        fmt.Println(maper["id"]," Received ",string(buf[0:n]))//, " from "),addr)
      //  redis.Get(maper["id"].(string))
        if err != nil {
            fmt.Println("Error: ",err)
        }
    }
}
