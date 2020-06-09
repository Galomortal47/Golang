package main

import (
    "fmt"
    "net"
    "os"
    "./redis"
    "encoding/json"
)

var parsed interface{}

/* A Simple function to verify error */
func CheckError(err error) {
    if err  != nil {
        fmt.Println("Error: " , err)
        os.Exit(0)
    }
}

func main() {
    redis.Flush()
    /* Lets prepare a address at any address at port 10001*/
    ServerAddr,err := net.ResolveUDPAddr("udp",":10001")
    CheckError(err)

    /* Now listen at selected port */
    ServerConn, err := net.ListenUDP("udp", ServerAddr)
    CheckError(err)
    defer ServerConn.Close()

    buf := make([]byte, 1024)

    for {
        n,_,err := ServerConn.ReadFromUDP(buf)
        json.Unmarshal((buf[0:n]), &parsed)
        md, _ := parsed.(map[string]interface{})
        fmt.Println(md["id"])
        redis.Set(string(buf[0:n]),string(buf[0:n]))
        //fmt.Println("Received ",string(buf[0:n]), " from ",addr)
        redis.Get(string(buf[0:n]))
        if err != nil {
            fmt.Println("Error: ",err)
        }
    }
}
